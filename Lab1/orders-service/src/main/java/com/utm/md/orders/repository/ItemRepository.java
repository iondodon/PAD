package com.utm.md.orders.repository;

import com.utm.md.orders.model.Item;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.UUID;

@ResponseBody
public interface ItemRepository extends JpaRepository<Item, UUID> {
}
