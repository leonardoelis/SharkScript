grammar SharkScript;

@header { import java.util.*; }
@members {
	Variavel x = new Variavel();
	ControleVariavel cv = new ControleVariavel();
	Funcionamento f = new Funcionamento();
	String saida="";
	int escopo;
	int tipo;
	String nome;
	int tipoConteudo;
	String varDeclarada;
	String conteudo;
}

start: {escopo = 0; saida += "import java.util.Scanner;\n\npublic class Programa{\n\t";}
		comandos 'begin' {escopo = 1; saida += "\n\tpublic static void main(String args[]){\n\t\tScanner entrada = new Scanner(System.in);\n\t";}  comandos 'end'{saida+="}\n}";} {System.out.println(saida); cv.print();};
declara: (tipoVar ID {x = new Variavel($ID.text, tipo, escopo);
						if(!cv.adiciona(x)){
							System.out.println("Variavel "+$ID.text+" j� foi declarada!!!");
							System.exit(0);
						} } PV {saida += $ID.text+";\n\t";} );

comandos: (comandoDecisao | comandoAtribuicao | comandoRepeticao | comandoRepeticao2 | comandoImpressao | comandoLeitura | declara)*;
comandoDecisao: 'if' {saida+="\tif";} AP {saida+="(";}(ID {saida+=$ID.text;}| Expr {saida+=$Expr.text;}| Int {saida+=$Int.text;}| Float {saida+=$Float.text;}| Texto {saida+=$Texto.text;}) OpRel {saida+=$OpRel.text;} (ID {saida+=$ID.text;}| Expr {saida+=$Expr.text;}| Int {saida+=$Int.text;}| Float {saida+=$Float.text;}| Texto {saida+=$Texto.text;}) FP {saida+=")";} AC {saida+="{\n\t";}(comandos) FC {saida+="\t}";}('else'{saida+="else";} AC {saida+="{\n\t";} (comandos) FC {saida+="\t}\n\t";})?;
comandoAtribuicao: ID{saida+="\t"+$ID.text;} { if(!cv.jaExiste($ID.text)){
							System.out.println("Variavel "+$ID.text+ " ainda n�o foi declarada");
							System.exit(0);
						} else{
							varDeclarada = $ID.text;
						}} OpAtrib{saida+=$OpAtrib.text;} (ID{saida+=$ID.text;} {//System.out.println($ID.text);
										// Verifica se a vari�vel j� existe
										if(!cv.jaExiste($ID.text)){
											System.out.println("Variavel "+$ID.text+ " ainda n�o foi declarada");
											System.exit(0);
										} else{
											// Se j� existe, verifica se as duas vari�veis s�o do mesmo tipo
											if(!cv.checarID(varDeclarada, $ID.text)){
												System.out.println("Variavel "+varDeclarada+" e "+$ID.text+" s�o de tipos diferentes");
												System.exit(0);
											} else{
												// Se s�o do mesmo tipo, verifica se a segunda j� foi inicializada
												if(!cv.checarInicializacao($ID.text)){
													System.out.println("Variavel "+$ID.text+" ainda n�o foi inicializada");
													System.exit(0);
												} else{
													// Se j� foi inicializada, guarda o valor contido nessa vari�vel e o tipo de conte�do dela
													conteudo = String.valueOf(cv.getConteudoVar($ID.text));
													tipoConteudo = cv.getTipoConteudo($ID.text);
													// Guarda o valor da segunda vari�vel dentro da primeira
													cv.setConteudo(varDeclarada, conteudo, tipoConteudo);
												}
											}
										}
										} | Expr{saida+=$Expr.text;} {//System.out.println($Expr.text);
												  // Verifica se a vari�vel � do mesmo tipo do resultado da express�o aritm�tica
												    try{
												  		if(!cv.checarExpr(varDeclarada, $Expr.text, cv)){
				        									System.out.println("Variavel "+varDeclarada+" e resultado de "+$Expr.text+" s�o de tipos diferentes");
				        									System.exit(0);
												    	} else{
												    		// Se sim, guarda o resultado da express�o e o tipo de conte�do da vari�vel
												    		conteudo = String.valueOf(cv.calcular($Expr.text, cv));
												    		tipoConteudo = cv.getTipoConteudo(varDeclarada);
												    		// Guarda o resultado da express�o aritm�tica dentro da vari�vel
												    		cv.setConteudo(varDeclarada, conteudo, tipoConteudo);
												    	}
												    } catch(Exception ex){
												    	System.out.println(ex);
												    }
												    } | (Int{saida+=$Int.text;} {/*System.out.println($Int.text);*/ tipoConteudo = 0; conteudo = $Int.text;} 
													 | Float{saida+=$Float.text+"f";} {/*System.out.println($Float.text);*/ tipoConteudo = 1; conteudo = $Float.text;}
													 | Texto{saida+=$Texto.text;} {/*System.out.println($Texto.text);*/ tipoConteudo = 2; conteudo = $Texto.text;}) 
													
													{// Verifica se a vari�vel � do mesmo tipo do valor que ela est� recebendo
													if(!cv.checarCaracteres(varDeclarada, tipoConteudo)){
														System.out.println("Variavel "+varDeclarada+" e o valor recebido s�o de tipos diferentes");
														System.exit(0);
													} else{
														// Se for do mesmo tipo, salva esse conte�do na vari�vel
														cv.setConteudo(varDeclarada, conteudo, tipoConteudo);
													}
													}) PV{saida+=";\n\t";};

comandoRepeticao: 'while'{saida+="\twhile";} AP{saida+="(";} (ID {saida+=$ID.text;}| Expr {saida+=$Expr.text;}| Int {saida+=$Int.text;}| Float {saida+=$Float.text;}| Texto {saida+=$Texto.text;}) OpRel {saida+=$OpRel.text;} (ID {saida+=$ID.text;}| Expr {saida+=$Expr.text;}| Int {saida+=$Int.text;}| Float {saida+=$Float.text;}| Texto {saida+=$Texto.text;}) FP {saida+=")";} AC {saida+="{\n\t";} (comandos) FC{saida+="\t}\n\t";};
comandoRepeticao2: 'do' {saida+="\tdo";} AC{saida+="{\n\t";} (comandos) FC{saida+="\t}";} 'while'{saida+="while";} AP{saida+="(";} (ID {saida+=$ID.text;}| Expr {saida+=$Expr.text;}| Int {saida+=$Int.text;}| Float {saida+=$Float.text;}| Texto {saida+=$Texto.text;}) OpRel {saida+=$OpRel.text;} (ID {saida+=$ID.text;}| Expr {saida+=$Expr.text;}| Int {saida+=$Int.text;}| Float {saida+=$Float.text;}| Texto {saida+=$Texto.text;}) FP{saida+=")";} PV{saida+=";\n\t";};
comandoImpressao: 'print'{saida+="\tSystem.out.println";} AP{saida+="(";} (ID{saida+=$ID.text;} {//System.out.println($ID.text);
									// Verifica se a vari�vel j� existe
									if(!cv.jaExiste($ID.text)){
										System.out.println("Variavel "+$ID.text+ " ainda n�o foi declarada");
										System.exit(0);
									} else{// Se j� existe, verifica se a vari�vel j� foi inicializada
											if(!cv.checarInicializacao($ID.text)){
												System.out.println("Variavel "+$ID.text+" ainda n�o foi inicializada");
												System.exit(0);
											} else{
												// Se j� foi inicializada, pega o valor dessa vari�vel e imprime na tela
												conteudo = String.valueOf(cv.getConteudoVar($ID.text));
												f.comandoPrint(conteudo);
											}
										}
									} | Expr{saida+=$Expr.text;} {try{
												conteudo = String.valueOf(cv.calcular($Expr.text, cv));
												f.comandoPrint(conteudo);
											} catch(Exception ex){
												System.out.println(ex);
											}
											} | (Int {saida+=$Int.text; conteudo = $Int.text;} | Float {saida+=$Float.text; conteudo = $Float.text;}| Texto {saida+=$Texto.text; conteudo = $Texto.text;}) 
												{f.comandoPrint(conteudo);} ) FP {saida+=")";} PV {saida+=";\n\t";};

comandoLeitura: 'read' AP ID {saida+="\t"+$ID.text+" = entrada."+cv.tipoScanner(cv.getTipoConteudo($ID.text))+"\n\t";}{// Verifica se a vari�vel j� existe
								if(!cv.jaExiste($ID.text)){
									System.out.println("Variavel "+$ID.text+ " ainda n�o foi declarada");
									System.exit(0);
								} else{
									// Se j� existe, pega o tipo de conte�do dela e chama o m�todo para fazer a leitura
									tipoConteudo = cv.getTipoConteudo($ID.text);
									f.comandoRead($ID.text, tipoConteudo, cv);
								}}FP PV;

tipoVar: ('int' {tipo = 0; saida += "	int ";} | 'float' {tipo = 1; saida += "\tfloat ";} | 'str' {tipo = 2; saida += "	String ";} );
ID: ([a-z] | [A-Z]) ([a-z] | [A-Z] | [0-9])*;
Int: ([0-9])+;
Float: ([0-9])+ '.' ([0-9])* | '.' ([0-9])+;
Texto: '"'([!-�] | ' ')+'"';
OpRel: '<' | '>' | '<=' | '>=' | '==' | '!=';
Expr: (Int | Float| ID) ('*' | '/' | '+' | '-' | ' * ' | ' / ' | ' + ' | ' - ' | ' *' | ' /' | ' +' | ' -' | '* ' | '/ ' | '+ ' | '- ' |(Int | Float | ID))+;
OpAtrib: '=';
AP: '(';
FP: ')';
AC: '{';
FC: '}';
PV: ';';
WS: [ \t\r\n]+ -> skip;