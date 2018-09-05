import java.sql.Connection;
import java.sql.Driver;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import oracle.jdbc.OracleDriver;

/**
 * Classe representant la base de donnee.
 * @author Bilal Itani & Mehdi Kadi
 */
public class Database {
	
	private Connection connexion;
	private Driver driverOracle;
	
	private final static String USERNAME = "INF3710-171-03" ;
	private final static String PASSWORD = "27H2EX";


	/**
	 * Methode permettant de se connecter au serveur qui
	 * heberge notre base de donnee.
	 */
	public void connect()
	{
		try {
			driverOracle = new OracleDriver();
			DriverManager.registerDriver(driverOracle);
			String serveur = "jdbc:oracle:thin:@ora-labos.labos.polymtl.ca:2001:LABOS";
			connexion = DriverManager.getConnection(serveur, USERNAME, PASSWORD);
			connexion.setAutoCommit(false);
		} catch (SQLException e) {
			System.err.println("UNHANDLED EXCEPTION CAUGHT WHILE CONNECTING TO DATABASE." + e.getMessage());
			e.printStackTrace();
		}
	}
	
	/**
	 * Methode permettant de se deconnecter de la base
	 * de donnee.
	 */
	public void disconnect()
	{
		try {
			if(connexion != null)
			{
				connexion.close();
			}
		} catch (SQLException e) {
			System.err.println("UNHANDLED EXCEPTION CAUGHT WHILE DISCONNECTING THE DATABASE." + e.getMessage());
			e.printStackTrace();
		}
	}

	
	/**
	 * ***** TACHE 11 *****
	 * Methode permettant d'ajouter un abonne a un membre.
	 * @param numM, represente l'identifiant d'un membre.
	 * @param numAbonne, represente l'identifiant d'un membre vue comme un abonne.
	 * @param debutAbonnement, represente la date de debut de l'abonnement. Cette derniere doit avoir la forme 'DD/MM/YYYY'
	 * @param finAbonnement, represente la date de fin d'abonnement. Cette derniere doit avoir la forme 'DD/MM/YYYY' si elle est specifie.
	 */
	public void addSubscriber(String numM, String numAbonne, String debutAbonnement, String finAbonnement)
	{
		/*
		 * ********** Methodologie adopte **********
		 * 
		 * L'idee ici est d'inserer dans la table abonne une entre. D'ou la necessite d'utiliser le insert into.
		 * Ici, il faut tenir compte de deux possibilite. Soit fin abonnement est specifier, ou non. En theorie, 
		 * addSubscriber devrait toujours etre utiliser avec finAbonnement = null ou vide, mais nous avons choisi
		 * de traiter le cas ou la fin de l'abonnement est specifier (ce qui peut etre aberrant dans la mesure ou
		 * si fin abonnement est specifier, on n'ajoute pas rellement un subscriber, mais nous avons choisi de le
		 * traite). Nous ne faisons pas cette meme demarche pour debutAbonnement car celui-ci a une contrainte
		 * de non nullite.
		 */
		StringBuilder querryInsertAbonne = new StringBuilder();
		querryInsertAbonne.append("insert into ABONNE values (" + numM + "," + numAbonne + "," + "to_date('" + debutAbonnement + "','DD/MM/YYYY'),");
		if(finAbonnement.equals("") || finAbonnement.equals("null") || finAbonnement == null)
		{
			querryInsertAbonne.append("null)");
		}
		else
		{
			querryInsertAbonne.append("to_date('"+ finAbonnement +"','DD/MM/YYYY'))");
		}
		executeUpdateQuery(querryInsertAbonne.toString());
	} 
	
	/**
	 * ***** TACHE 12 *****
	 * Methode permettant de rendre un profil prive.
	 * @param numM, represente l'identifiant d'un membre.
	 */
	public void setProfilPrivate(String numM)
	{
		/*
		 * ********** Methodologie adopte **********
		 * 
		 * L'idee ici est d'abord d'effectuer une recherche dans la base de donnee pour
		 * trouver le membre en question. Ensuite, avec le resultat obtenue, on verifie si
		 * son profile est public. Si ce dernier est public, alors nous executons une update
		 * statement pour mettre son profil a priver. Dans le cas contraire, nous n'effectuons
		 * rien, car le profil est deja privee.
		 * 
		 */
		StringBuilder querryMemberInfo = new StringBuilder();
		querryMemberInfo.append("select MEMBRE.* from MEMBRE where MEMBRE.numM = " + numM);
		ResultSet res = executeSelectQuery(querryMemberInfo.toString());
		Statement associatedStatement = null;
		try {
			if (res != null)
			{
				associatedStatement = res.getStatement();
				while(res.next())
				{
					String profilType = res.getString("typeprofil");
					if(profilType.toUpperCase().equals("P"))
					{
						StringBuilder querryModifyPrivateState = new StringBuilder();
						querryModifyPrivateState.append("update MEMBRE set MEMBRE.typeProfil = 'V' where MEMBRE.numM = " + numM);
						executeUpdateQuery(querryModifyPrivateState.toString());
					}
				}
			}
		} catch (SQLException e) {
			System.err.println("UNHANDLED EXCEPTION CAUGHT WHILE SETTING PROFILE PRIVATE. " + e.getMessage());
			disconnect();
			e.printStackTrace();
		} finally {
			closeStatement(associatedStatement);
			closeResultSet(res);
		}
		
	}
	
	/**
	 * ***** TACHE 13 *****
	 * Methode permettant d'imprimer le nom et le prenom des membres hyperactifs, soit ceux
	 * qui ont commente toutes les photos de leurs amis ou abonnes.
	 */
	public void printFirstNameLastNameOfHyperactiveMembers()
	{
		/*
		 * ********** Methodologie adopte **********
		 * 
		 * Ici, la tache 13 represente une division relationnelle. Pour effectuer cette division, il existe
		 * deux facons de faire. Nous avons choisi la deuxieme facon, soit celle de compter pour chaque membre
		 * le nombre de photo que ses amis/abonnes ont publier. Si ce nombre est egale au nombre de photo que le membre
		 * en question a commente, alors ce membre est un hyperactifs. Nous avons d'abord traite le cas des amis, puis le cas des
		 * abonnes. Apres avoir obtenus les deux ensembles, nous en faisons l'union pour repondre au requis qu'impose la tache 13.
		 * Attention, il ne faut pas oublier de verifier qu'un abonne est considere comme tel si et seulement si la date
		 * de fin d'abonnement est null.
		 * 
		 */
		StringBuilder querryGetHyperactiveMembers = new StringBuilder();
		querryGetHyperactiveMembers.append("with lesHyperActifs as "
				+ "(select distinct membre.numM from Membre inner join ami on membre.numM = ami.numM "
				+ "inner join photo on photo.numM = ami.numAmi group by membre.numM having count(photo.numM) = "
				+ "(select count(distinct commentaire.numPhoto) from commentaire where commentaire.numM = membre.numM group by commentaire.numM)"
				+ " union select distinct membre.numM from Membre inner join abonne on membre.numM = abonne.numM "
				+ "inner join photo on photo.numM = abonne.numAbonne where abonne.finAbonnement is null group by membre.numM having count(photo.numM) = "
				+ "(select count(distinct commentaire.numPhoto) from commentaire where commentaire.numM = membre.numM group by commentaire.numM)) "
				+ "select membre.nom, membre.prenom from membre where membre.numM in (select lesHyperActifs.* from lesHyperActifs)");
		ResultSet res = executeSelectQuery(querryGetHyperactiveMembers.toString());
		Statement associatedStatement = null;
		try
		{
			associatedStatement = res.getStatement();
			System.out.println("***** LIST OF HYPERACTIVE MEMBER(S) *****");
			while(res.next())
			{
				System.out.println("Last name : " + res.getString("nom") + "\t" + "First name : " + res.getString("prenom"));
			}
		} catch(SQLException e)
		{
			System.err.println("UNHANDLED EXCEPTION CAUGHT WHILE GETTING HYPERACTIVE MEMBER(S). " + e.getMessage());
			disconnect();
			e.printStackTrace();
		}
		finally
		{
			closeStatement(associatedStatement);
			closeResultSet(res);
		}
	}
	

	/**
	 * ***** Tache 14 *****
	 * Methode permettant d'imprimer le nom et le prenom des membres les plus populaires,
	 * soit les membres ayant le plus grand nombre d'amis.
	 */
	public void printFirstNameLastNameOfMostPopularMember()
	{
		
		/*
		 * ********** Methodologie adopte **********
		 * 
		 * Ici, il suffit de compter le nombre d'ami qu'a un membre (dans la table ami), il est necessaire d'effectuer
		 * un group by ami.numM afin d'avoir le decompte des amis qu'a un membre en particulier. Nous prenons ensuite
		 * l'identifiant du membre ayant le plus grand nombre d'ami (avec la fonction max()).
		 */
		
		StringBuilder querryGetMostPopularMembers = new StringBuilder();
		querryGetMostPopularMembers.append("with mbreEtNmbreAmi as (select AMI.numM, count(AMI.numAmi) as nombreAmi from AMI group by AMI.numM), "
				+ "lesPlusPopulaires as (select mbreEtNmbreAmi.numM from mbreEtNmbreAmi where mbreEtNmbreAmi.nombreAmi = (select max(mbreEtNmbreAmi.nombreAmi) from mbreEtNmbreAmi)) "
				+ "select MEMBRE.nom, MEMBRE.prenom from MEMBRE where MEMBRE.numM in (select lesPlusPopulaires.* from lesPlusPopulaires)");
		
		ResultSet res = executeSelectQuery(querryGetMostPopularMembers.toString());
		Statement associatedStatement = null;
		try {
			associatedStatement = res.getStatement();
			System.out.println("***** LIST OF MOST POPULAR MEMBER(S) *****");
			while(res.next())
			{
				System.out.println("Last name : " + res.getString("nom") + "\t" + "First name : " + res.getString("prenom"));
			}
		} catch (SQLException e) {
			System.err.println("UNHANDLED EXCEPTION CAUGHT WHILE GETTING MOST POPULAR MEMBER(S)" + e.getMessage());
			disconnect();
			e.printStackTrace();
		} finally {
			closeStatement(associatedStatement);
			closeResultSet(res);
		}
	}
	
	
	/**
	 * Methode permettant d'executer un commit sur la base de donnee.
	 */
	private void commit()
	{
		try {
			if (connexion != null)
			{
				connexion.commit();
			}
		} catch (SQLException e) {
			System.err.println("UNHANDLED EXCEPTION IN COMMIT.");
			disconnect();
			e.printStackTrace();
		}
	}
	
	/**
	 * Methode permettant d'executer un rollback sur la base de donnee.
	 */
	private void rollback()
	{
		try {
			if (connexion != null)
			{
				connexion.rollback();
			}
		} catch (SQLException e) {
			System.err.println("UNHANDLED EXCEPTION IN ROLLBACK.");
			disconnect();
			e.printStackTrace();
		}
	}
	
	
	/**
	 * Methode permettant d'executer une query de type select.
	 * @param querrySelect String contenant la querry a executer.
	 * @return resultat de la querry select.
	 */
	private ResultSet executeSelectQuery(String querrySelect)
	{
		Statement stmt = getStatement();
		ResultSet dReturn = null;
		try {
			dReturn = stmt.executeQuery(querrySelect);
		} catch (SQLException e) {
			System.err.println("UNHANDLED EXCEPTION CAUGHT WHILE EXECUTING SELECT QUERRY." + e.getMessage());
			disconnect();
			e.printStackTrace();
		}
		return dReturn;
	}
	
	/**
	 * Methode permettant d'executer une querry de type update.
	 * @param querryUpdate
	 * @return either (1) the row count for SQL Data Manipulation Language (DML) statements or 
	 * (2) 0 for SQL statements that return nothing
	 */
	private Integer executeUpdateQuery(String querryUpdate)
	{
		Integer res = -1;
		Statement stmt = getStatement();
		try {
			res = stmt.executeUpdate(querryUpdate);
			commit();
		} catch (SQLException e) {
			rollback();
			disconnect();
			System.err.println("UNHANDLED EXCEPTION CAUGHT WHILE EXECUTING UPDATE QUERRY." + e.getMessage());
			e.printStackTrace();
		} finally {
			closeStatement(stmt);
		}
		return res;
	}
	
	
	/**
	 * Methode permettant de creer un statement.
	 * @return dStatement le statement creer.
	 */
	public Statement getStatement() {
		Statement dStatement = null;
		try {
			dStatement = connexion.createStatement();
		} catch (SQLException e) {
			System.err.println("UNHANDLED EXCEPTION CAUGHT WHILE CREATING STATEMENT. " + e.getMessage());
			e.printStackTrace();
		}
		return dStatement;
	}

	/**
	 * Methode permettant de fermer un statement.
	 * @param dStatement le statement a fermer
	 */
	public void closeStatement(Statement dStatement) {
		try {
		   if(dStatement != null) {
			   dStatement.close();
		   }
		}
		catch(SQLException se) {
			System.err.println("UNHANDLED EXCEPTION CAUGHT WHILE CLOSING STATEMENT. " + se.getMessage());
			se.printStackTrace();
		}
	}
	
	/**
	 * Methode permettant de fermer un result set.
	 * @param dResultSet le statement a fermer
	 */
	public void closeResultSet(ResultSet dResultSet) {
		try {
		   if(dResultSet != null) {
			   dResultSet.close();
		   }
		}
		catch(SQLException se) {
			System.err.println("UNHANDLED EXCEPTION CAUGHT WHILE CLOSING RESULTSET. " + se.getMessage());
			se.printStackTrace();
		}
	}
}
