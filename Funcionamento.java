import java.util.*;

public class Funcionamento {
	Scanner entrada = new Scanner(System.in);
    
    public Funcionamento(){

    }

    public void comandoPrint(Object conteudo){
        System.out.println(conteudo);
    }

    public void comandoRead(String var, int tipoConteudo, ControleVariavel cv){
        entrada.useLocale(Locale.US);
        Variavel v = cv.busca(var);
        if (tipoConteudo == 0) {
            v.setConteudoInt(entrada.nextInt());
        } else if (tipoConteudo == 1){
            v.setConteudoFloat(entrada.nextFloat());
        } else{
            v.setConteudoString(entrada.nextLine());
        }
    }
}