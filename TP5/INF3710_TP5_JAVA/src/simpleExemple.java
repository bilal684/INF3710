import java.net.UnknownHostException;
import java.util.Scanner;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import org.bson.Document;
import org.json.simple.*;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import com.mongodb.*;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.FindIterable;
import com.mongodb.client.MongoCollection;

public class simpleExemple {

	private final static String uri = "mongodb://mehdi_bilal:hajbilal95@ds139370.mlab.com:39370/inf3710db";

	
	private static MongoDatabase getDb()
	{
		MongoClientURI clientUri = new MongoClientURI(uri);
		@SuppressWarnings("resource")
		MongoClient client = new MongoClient(clientUri);
		MongoDatabase db = client.getDatabase("inf3710db");
		return db;
	}
	/**
	 * @param args
	 */
	public static void importJsonIntoCollection(String fichier, String dbname, String collname) {
		try {
			// Connexion à la base de donnée distante
			// Standard URI format:
			// mongodb://[dbuser:dbpassword@]host:port/dbname
			// mongodb://<dbuser>:<dbpassword>@ds139370.mlab.com:39370/inf3710db
			
			/*
			Ici, il suffit de remplir les bonnes valeurs dans URI. Nous avons choisi de mettre uri comme attribut final static
			et nous avons rempli les informations necessaire afin de pouvoir se connecter a la base de donnee. Les informations
			necessaires etaient disponibles sur le site de mlab. Nous avons uniquement creer un utilisateur et un mot de passe
			afin qu'un utilisateur puisse se connecter a la base de donnee.
			*/
			MongoClientURI clientUri = new MongoClientURI(uri);
			MongoClient client = new MongoClient(clientUri);
			MongoDatabase db = client.getDatabase(dbname);
			MongoCollection<Document> coll = db.getCollection(collname);
			JSONParser parser = new JSONParser();
			JSONArray jsonarray = null;
			// Récupéation des données du fichier JSON
			jsonarray = (JSONArray) parser.parse(new FileReader(fichier));
			// Parcours du tableau pour récupérer chacun des documents et
			// l'insérer dans la collection
			for (int i = 0; i < jsonarray.size(); i++) {
				Document doc = Document.parse(jsonarray.get(i).toString());
				coll.insertOne(doc);// Insertion dans la BD
			}
			client.close();
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} catch (ParseException e) {
			e.printStackTrace();
		} catch (NullPointerException e) {
			e.printStackTrace();
		}

	}
	
	public static void main(String[] args) throws UnknownHostException {
		// TODO Auto-generated method stub
		/*
		L'idee ici est d'appeler la fonction importJsonIntoCollection afin d'uploader le contenu de
		dblp.json dans notre base de donne mlab.
		*/
		importJsonIntoCollection("dblp.json", "inf3710db","dblpcollection");
	}
}
