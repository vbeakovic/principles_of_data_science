# a one dimensional array (vector)
x <- c(3, 6, 8)


# Summation
x <- c(1, 2, 3, 4, 5)
sum(x)

s <- unique(c(1, 2, 2, 3, 2, 1, 2, 2, 3, 2))
s

# magnitude of a set
length(s)

# sets intersection
user1 <- c("Target", "Banana Republic", "Old Navy")
user2 <- c("Banana Republic", "Gap", "Kohl's")
intersect(user1, user2)
length(intersect(user1, user2))

# sets union
union(user1, user2)
length(union(user1, user2))

# jaccard measure
length(intersect(user1, user2)) / length(union(user1, user2))

jaccard <- function(user1, user2) {
        stores_in_common <- intersect(user1, user2)
        stores_all_together <- union(user1, user2)
        length(stores_in_common) / length(stores_all_together)
}
jaccard(user1 = user1, user2 = user2)

