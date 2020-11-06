package com.utm.md.orders.repository;

import com.utm.md.orders.model.Ordeer;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.UUID;

@Repository
public interface OrderRepository extends JpaRepository<Ordeer, UUID> {
}
