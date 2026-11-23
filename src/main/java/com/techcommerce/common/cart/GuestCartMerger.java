package com.techcommerce.common.cart;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public interface GuestCartMerger {

    void mergeGuestCart(Long userId, Long selectedStoreId, HttpServletRequest request, HttpServletResponse response);
}
