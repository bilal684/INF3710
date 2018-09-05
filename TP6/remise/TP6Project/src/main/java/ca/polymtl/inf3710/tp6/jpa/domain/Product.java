package ca.polymtl.inf3710.tp6.jpa.domain;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

@Entity
public class Product {

    @Id
    @GeneratedValue(strategy=GenerationType.AUTO)
    private String id;
	private String label;
    private String description;
    private String Price;
    
	public Product(){}

    public Product(String label, String description) {
    	this.label = label;
    	this.description = description;
    }

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getLabel() {
		return label;
	}

	public void setLabel(String label) {
		this.label = label;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}
	
    public String getPrice() {
		return Price;
	}

	public void setPrice(String Price) {
		this.Price = Price;
	}

	
	public boolean equals(Object object) {
		if(object instanceof Product) {
			return this.getId().equals(((Product) object).getId());
		}
		else {
			return false;
		}
	}
}
