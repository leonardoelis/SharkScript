import javax.script.*;

public class Calculo{
    public Calculo(){

    }

    public Object calcularExpressao(String exp, ControleVariavel cv) throws Exception{
        StringBuilder newExp = new StringBuilder(exp);
        String var = "";
        int posInicial = 0, posFinal = 0;
        for (int i = 0; i < exp.length(); i++) {
            // Verifica se o primeiro caracter é uma letra, se sim adiciona esse caracter em 'var'
            if ((exp.charAt(i) >= 65 && exp.charAt(i) <= 90) || (exp.charAt(i) >= 97 && exp.charAt(i) <= 122)) {
                var += exp.charAt(i);
                posInicial = i;
                int cont = i + 1;
                // enquanto os próximos caracteres forem letra ou número, vai adicionando os caracteres do nome da variavel em 'var'
                while (cont < exp.length() && ((exp.charAt(cont) >= 65 && exp.charAt(cont) <= 90) || (exp.charAt(cont) >= 97 && exp.charAt(cont) <= 122) || (exp.charAt(cont) >= 48 && exp.charAt(cont) <= 57))) {
                    var += exp.charAt(cont);
                    cont++;
                }
                i = cont - 1;
                posFinal = cont;
            }
            if (!var.equalsIgnoreCase("")) {
                // Verifica se a variável que está na expressão já existe
                if (!cv.jaExiste(var)) {
                    System.out.println("A variavel "+var+" ainda não foi declarada");
                    System.exit(0);
                } else{
                    // Se sim, verifica se ela é uma String
                    if (cv.getTipoConteudo(var) == 2) {
                        System.out.println("A variavel "+var+" não pode realizar calculos");
                        System.exit(0);
                    } else{
                        // Se não for String, verifica se ela já foi inicializada
                        if (!cv.checarInicializacao(var)) {
                            System.out.println("A variavel "+var+" ainda não foi inicializada");
                            System.exit(0);
                        } else{
                            String conteudo = String.valueOf(cv.getConteudoVar(var));
                            newExp.replace(posInicial, posFinal, conteudo);
                            exp = newExp.toString();
                            i = 0;
                        
                        }
                    }
                }
            }
            //System.out.println(var);
            var = "";
        }
        // create a script engine manager
        ScriptEngineManager factory = new ScriptEngineManager();
        // create a JavaScript engine
        ScriptEngine engine = factory.getEngineByName("JavaScript");
        // evaluate JavaScript code from String
        Object obj = engine.eval(exp);
        return obj;
    }
}