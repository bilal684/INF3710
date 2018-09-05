package ca.polymtl.inf3710.tp6.jpa.domain;

import java.util.List;

import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.repository.query.Param;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;

@RepositoryRestResource(collectionResourceRel = "product", path = "product")
/*public interface ProductRepository extends JpaRepository<Product, Long>*/
public interface ProductRepository extends MongoRepository<Product, Long> {

    Product findById(@Param("id") String id);
    List<Product> findByLabel(@Param("label") String label);

}
