package com.utm.md.orders.controller;

import com.utm.md.orders.service.items.ItemService;
import com.utm.md.orders.dto.ItemDto;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping(path = "/item")
@RequiredArgsConstructor
public class ItemController {
    private final ItemService itemService;

    @RequestMapping(
            path = "/",
            method = RequestMethod.POST
    )
    public ResponseEntity<String> createItem(@RequestBody ItemDto itemDto) {
        itemService.createItem(itemDto);
        return new ResponseEntity<>("Created", HttpStatus.CREATED);
    }

}