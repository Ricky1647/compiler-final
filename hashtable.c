#include "hashtable.h"

unsigned int hash(const char *key) {
    unsigned long int value = 0;
    unsigned int i = 0;
    unsigned int key_len = strlen(key);
    for (; i < key_len; ++i) {
        value = value * 37 + key[i];
    }
    return value % TABLE_SIZE;
}

void create_table(struct HashTable *table) {
    // HashTable *table = (HashTable *)malloc(sizeof(HashTable));
    table->buckets = (Node **)malloc(TABLE_SIZE * sizeof(Node *));
    for (int i = 0; i < TABLE_SIZE; i++) {
        table->buckets[i] = NULL;
    }
    return;
}


void insert(HashTable *table, const char *key, int arrayLenth) {
    unsigned int bucket = hash(key);
    Node *new_node = (Node *)malloc(sizeof(Node));
    new_node->key = strdup(key);
    new_node->value = (DataContainer *)malloc(sizeof(DataContainer));
    new_node->value->name = strdup(key);
    if(arrayLenth > 0){
        new_node->value->dataType = 1;
        new_node->value->size = arrayLenth;
    }
    else{
        new_node->value->dataType = 0;
        new_node->value->size = 1;
    }
    new_node->next = table->buckets[bucket];
    table->buckets[bucket] = new_node;
}

DataContainer *search(HashTable *table, const char *key) {
    unsigned int bucket = hash(key);
    Node *node = table->buckets[bucket];
    while (node != NULL && strcmp(node->key, key) != 0) {
        node = node->next;
    }
    if (node == NULL) {
        printf("%s is not defined\n", key);

        exit(-1);
    }
    return node->value;
}

void delete(HashTable *table, const char *key) {
    unsigned int bucket = hash(key);
    Node *node = table->buckets[bucket];
    Node *prev = NULL;
    while (node != NULL && strcmp(node->key, key) != 0) {
        prev = node;
        node = node->next;
    }
    if (node == NULL) return;
    if (prev == NULL) {
        table->buckets[bucket] = node->next;
    } else {
        prev->next = node->next;
    }
    free(node->key);
    free(node->value);
    free(node);
    return;
}

void free_table(HashTable *table) {
    for (int i = 0; i < TABLE_SIZE; i++) {
        Node *node = table->buckets[i];
        while (node != NULL) {
            Node *next = node->next;
            free(node->key);
            free(node->value);
            free(node);
            node = next;
        }
    }
    free(table->buckets);
    free(table);
}
