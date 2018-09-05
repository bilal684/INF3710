public class EntryPoint {
	
	public static void main(String[] args)
	{
		Database database = new Database(); 
		try
		{
			database.connect();
			/*
			 * ***** ATTENTION *****
			 * ON ASSUME QUE LA BASE DE DONNEE EST POPULER CORRECTEMENT LORS DE L'UTILISATION
			 * DES METHODES MENTIONNEES CI-BAS.
			 */
			
			//TACHE 11
			//On peut utiliser la methode addSubscriber() de la facon suivante : 
			//database.addSubscriber("201701", "201702", "03/05/2008", "null");
			
			//TACHE 12
			//On peut utiliser la methode setProfilPrivate de la facon suivante :
			//database.setProfilPrivate("201703");
			
			
			//TACHE 13
			//On peut utiliser la methode printFirstNameLastNameOfHyperactiveMembers() de la facon suivante :
			//database.printFirstNameLastNameOfHyperactiveMembers();
			
			//TACHE 14
			//On peut utiliser la methode printFirstNameLastNameOfMostPopularMember() de la facon suivante :
			//database.printFirstNameLastNameOfMostPopularMember();
			
		} catch (Exception e) {
			System.out.println("UNHANDLED EXCEPTION CAUGHT WHILE EXECUTING ENTRY POINT. " + e.getMessage());
			e.printStackTrace();
		} finally {
			database.disconnect();
		}
	}

}
