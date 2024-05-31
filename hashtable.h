#ifndef HASHTABLE_H
#define HASHTABLE_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define TABLE_SIZE 100

typedef struct Node {
    char *key;
    char *value;
    struct Node *next;
} Node;

typedef struct HashTable {
    Node **buckets;
} HashTable;

unsigned int hash(const char *key);
void create_table(struct HashTable *table);
void insert(HashTable *table, const char *key, const char *value);
char *search(HashTable *table, const char *key);
void delete(HashTable *table, const char *key);
void free_table(HashTable *table);



// int main() {
//     HashTable *table = create_table();
//     insert(table, "name", "Alice");
//     insert(table, "age", "25");
//     insert(table, "city", "Wonderland");

//     printf("name: %s\n", search(table, "name"));
//     printf("age: %s\n", search(table, "age"));
//     printf("city: %s\n", search(table, "city"));

//     delete(table, "age");

//     if (search(table, "age") == NULL) {
//         printf("age not found\n");
//     }

//     free_table(table);

//     return 0;
// }
#endif