import java.util.ArrayList;

public class ControleVariavel {
    private ArrayList<Variavel> contvar;

    public ControleVariavel() {
        contvar = new ArrayList<Variavel>();
    }

    public boolean adiciona(Variavel v){
        for(int i=0; i<contvar.size(); i++){
            if( (contvar.get(i).getNome().equals(v.getNome())) && (contvar.get(i).getEscopo() == v.getEscopo()) )
                return false;
        }
        contvar.add(v);
        return true;
    }
    
    public Variavel busca(String nome){
        for(int i=contvar.size()-1; i>=0; i--){
            if(contvar.get(i).getNome().equals(nome))
                return contvar.get(i);
        }
        return null;
    }
    
    public boolean jaExiste(String nome){
        for(int i=contvar.size()-1; i>=0; i--){
            if(contvar.get(i).getNome().equals(nome))
                return true;
        }
        return false;
    }
    
    public void print(){
        for(int i=0; i<contvar.size(); i++){
            contvar.get(i).imprime();
            System.out.println("\n\n");
        }    
    }

    public boolean checarCaracteres(String varDeclarada, int conteudo){
        Variavel v = busca(varDeclarada);
        if(v.getTipo() == conteudo)
            return true;
        return false;
    }

    public boolean checarExpr(String varDeclarada, String exp, ControleVariavel cv) throws Exception{
        Variavel v = busca(varDeclarada);
        // Verifica se a variável é String
        if (v.getTipo() == 2) {
            return false;
        }
        Object resultado = calcular(exp, cv);
        // Tenta fazer o cast pra double, se não faz o cast pra int
        try{
            double resDouble = (double) resultado;
            float resFloat = (float) resDouble;
            // Verifica se a variável é float, assim como o resultado da expressão
            if (v.getTipo() == 1) {
                return true;
            }
            return false;
        } catch(Exception ex){
            int resInt = (int) resultado;
            // Verifica se a variável é int, assim como o resultado da expressão
            if (v.getTipo() == 0) {
                return true;
            }
            return false;
        }
    }

    public Object calcular(String exp, ControleVariavel cv) throws Exception{
        Calculo c = new Calculo();
        return c.calcularExpressao(exp, cv);
    }

    public boolean checarID(String varDeclarada, String varAtribuida){
        Variavel declarada = busca(varDeclarada);
        Variavel atribuida = busca(varAtribuida);
        if (declarada.getTipo() == atribuida.getTipo()) {
            return true;
        }
        return false;
    }

    public boolean checarInicializacao(String var){
        Variavel v = busca(var);
        if (v.getConteudoInt() != null) {
            return true;
        } else if(v.getConteudoFloat() != null){
            return true;
        } else if(v.getConteudoString() != null){
            return true;
        }
        return false;
    }

    public Object getConteudoVar(String var){
        Variavel v = busca(var);
        if (v.getConteudoInt() != null) {
            return v.getConteudoInt();
        } else if(v.getConteudoFloat() != null){
            return v.getConteudoFloat();
        }
        return v.getConteudoString();
    }

    public int getTipoConteudo(String var){
        Variavel v = busca(var);
        return v.getTipo();
    }

    public void setConteudo(String var, String conteudo, int tipoConteudo){
        Variavel v = busca(var);
        if (tipoConteudo == 0) {
            v.setConteudoInt(Integer.parseInt(conteudo));    
        } else if(tipoConteudo == 1){
            v.setConteudoFloat(Float.parseFloat(conteudo));
        } else{
            v.setConteudoString(conteudo);
        }
    }

    public String tipoScanner(int tipo){
        if(tipo == 0){
            return "nextInt();";
        }else if(tipo == 1){
            return "nextFloat();";
        }else{
            return "nextLine();";
        }
    }
}