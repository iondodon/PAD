package com.utm.md.orders.controller;

import com.utm.md.orders.service.items.ItemService;
import com.utm.md.orders.dto.ItemDto;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Collection;
import java.util.UUID;

@RestController
@Slf4j
@RequestMapping(path = "/item")
@RequiredArgsConstructor
public class ItemController {
    private final ItemService itemService;

    @RequestMapping(
            path = "",
            method = RequestMethod.POST
    )
    public ResponseEntity<String> createItem(@RequestBody ItemDto itemDto) {
        itemService.createItem(itemDto);
        log.info("Creating Item " + itemDto);
        return new ResponseEntity<>("Created", HttpStatus.CREATED);
    }

    @RequestMapping(
            path = "",
            method = RequestMethod.GET
    )
    public ResponseEntity<Collection<ItemDto>> allItems() {
        log.info("Get all items");
        Collection<ItemDto> items = itemService.getAllItems();
        return new ResponseEntity<>(items, HttpStatus.OK);
    }

    @RequestMapping(
            path = "{itemID}",
            method = RequestMethod.DELETE
    )
    public ResponseEntity<ItemDto> deleteItem(@PathVariable("itemID") UUID itemID) {
        log.info("Delete item: " + itemID);
        ItemDto deletedItem = itemService.deleteItem(itemID);
        return new ResponseEntity<>(deletedItem, HttpStatus.OK);
    }
}