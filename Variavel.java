public class Variavel {
    private String nome;
    private int tipo;
    private int escopo;
    private int tipoConteudo;
    private String conteudoString;
    private Integer conteudoInt;
    private Float conteudoFloat;

    public Variavel(String nome, int tipo, int escopo) {
        this.nome = nome;
        this.tipo = tipo;
        this.escopo = escopo;
    }

    public Variavel() {
    }

    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public int getTipo() {
        return tipo;
    }

    public void setTipo(int tipo) {
        this.tipo = tipo;
    }

    public int getEscopo() {
        return escopo;
    }

    public void setEscopo(int escopo) {
        this.escopo = escopo;
    }
    
    public String getConteudoString(){
        return conteudoString;
    }

    public void setConteudoString(String conteudo){
        this.conteudoString = conteudo;
    }

    public Integer getConteudoInt(){
        return conteudoInt;
    }

    public void setConteudoInt(int conteudo){
        this.conteudoInt = conteudo;
    }

    public Float getConteudoFloat(){
        return conteudoFloat;
    }

    public void setConteudoFloat(float conteudo){
        this.conteudoFloat = conteudo;
    }

    public void imprime(){
        System.out.println("Nome: "+nome+"\nTipo: "+tipo+"\nEscopo: "+escopo+"\nConteudo String: "+conteudoString+"\nConteudo Int: "+conteudoInt+"\nConteudo Float: "+conteudoFloat);
    }
}