package com.techcommerce.auth;

public record UserPrincipal(
        Long id,
        String email,
        String fullName,
        String role,
        Long storeId
) {
    public static UserPrincipal from(User user) {
        return new UserPrincipal(
                user.getId(),
                user.getEmail(),
                user.getFullName(),
                user.getRole(),
                user.getStoreId()
        );
    }
}
