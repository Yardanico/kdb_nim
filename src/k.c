#include <stddef.h>
#include "k.h"

void check_c_struct_offset() {
    printf("C-struct-offset:\n");
    printf("  m: %ld\n", offsetof(struct k0, m));
    printf("  a: %ld\n", offsetof(struct k0, a));
    printf("  t: %ld\n", offsetof(struct k0, t));
    printf("  u: %ld\n", offsetof(struct k0, u));
    printf("  r: %ld\n", offsetof(struct k0, r));
    printf("  k: %ld\n", offsetof(struct k0, k));
    printf("  n: %ld\n", offsetof(struct k0, n));
    printf("  g: %ld\n", offsetof(struct k0, G0));
}