package ca.polymtl.inf3710.tp6.jpa;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;

import ca.polymtl.inf3710.tp6.jpa.domain.Customer;
import ca.polymtl.inf3710.tp6.jpa.domain.CustomerRepository;
import ca.polymtl.inf3710.tp6.jpa.domain.Product;
import ca.polymtl.inf3710.tp6.jpa.domain.ProductRepository;

@SpringBootApplication
public class Application {

	private static final Logger log = LoggerFactory.getLogger(Application.class);

	public static void main(String[] args) {
		SpringApplication.run(Application.class);
	}

	@Bean
	public CommandLineRunner demo(CustomerRepository customerRepository, ProductRepository productRepository) {
		return (args) -> {
			log.info("Creating customers ....");
			Customer customer = customerRepository.save(new Customer("Jack", "Bauer"));
			
			customer = customerRepository.save(new Customer("Chloe", "O'Brian"));
			log.info("Customer {} - {} created.", customer.getId(), customer.getFirstName());

			customer = customerRepository.save(new Customer("Kim", "Bauer"));
			log.info("Customer {} - {} created.", customer.getId(), customer.getFirstName());
			
			customer = customerRepository.save(new Customer("David", "Palmer"));
			log.info("Customer {} - {} created.", customer.getId(), customer.getFirstName());

			customer = customerRepository.save(new Customer("Michelle", "Dessler"));
			log.info("Customer {} - {} created.", customer.getId(), customer.getFirstName());

			log.info("5 customers were created ....");

			// fetch all customers
			log.info("Customers found with findAll():");
			log.info("-------------------------------");
			for (Customer c : customerRepository.findAll()) {
				log.info(c.toString());
			}
			log.info("");

			// fetch an individual customer by ID
			customer = customerRepository.findOne(1L);
			log.info("Customer found with findOne(1L):");
			log.info("--------------------------------");
			log.info(customer.toString());
			log.info("");

			// fetch customers by last name
			log.info("Customer found with findByLastName('Bauer'):");
			log.info("--------------------------------------------");
			for (Customer bauer : customerRepository.findByLastName("Bauer")) {
				log.info(bauer.toString());
			}
			log.info("");
			
			Product product = productRepository.save(new Product("How to Use JPA","Book about JPA advanced features"));
			Product productfromQuery = productRepository.findById(product.getId());
			
			log.info("Saved Product and Retrived Product are {}.", product.equals(productfromQuery) ? "equals" : "differents");
		};
	}
}