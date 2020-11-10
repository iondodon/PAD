package com.utm.md.orders.service.orders;

import com.utm.md.orders.dto.OrdeerDto;

import java.util.Collection;
import java.util.UUID;

public interface OrderService {
    void createOrder(OrdeerDto ordeerDto);
    Collection<OrdeerDto> getAllOrders();
    OrdeerDto deleteOrder(UUID orderID);
}
