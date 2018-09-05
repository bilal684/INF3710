package ca.polymtl.inf3710.tp6.jpa.domain;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.repository.PagingAndSortingRepository;
import org.springframework.data.repository.query.Param;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;

@RepositoryRestResource(collectionResourceRel = "customer", path = "customer")
public interface CustomerRepository extends JpaRepository<Customer, Long>, PagingAndSortingRepository<Customer, Long> {

    List<Customer> findByLastName(@Param("name") String lastName);

}
