#include <stdio.h>
#include <string.h>

void decode16(char *hex, char *buf) {
  // assumes valid hex string
  size_t i = 0;
  while (*hex) {
    char hi = *hex++;
    char lo = *hex++;
    hi = hi + (hi >> 6) * 9 & 15;
    lo = lo + (lo >> 6) * 9 & 15;
    buf[i++] = hi << 4 | lo;
  }
  buf[i] = '\0';
}

void encode64(char *s, char *buf) {
  size_t i = 0;
  char tmp[4];
  while (*s) {
    tmp[0] = *s >> 2;
    tmp[1] = (*s & 3) << 4 | *(s+1) >> 4;
    tmp[2] = (*(s+1) & 15) << 2 | *(s+2) >> 6;
    tmp[3] = *(s+2) & 63;
    s += 3;
    for (int j = 0; j < 4; j++) {
      char x = tmp[j];
      if      (x < 26) buf[i++] = 65 + x;
      else if (x < 52) buf[i++] = 71 + x;
      else if (x < 62) buf[i++] = x - 4;
      else if (x < 63) buf[i++] = 43;
      else             buf[i++] = 47;
    }
  }
  buf[i] = '\0';
}

int main(void) {
  char *hex =
    "49276d206b696c6c696e6720796f757220627261696e206c"
    "696b65206120706f69736f6e6f7573206d757368726f6f6d";

  size_t len = strlen(hex);
  char txt[(len / 2) + 1];
  char b64[(len / 3) * 2 + 1];

  decode16(hex, txt);
  encode64(txt, b64);

  printf("Hex    : %s\n", hex);
  printf("Text   : %s\n", txt);
  printf("Base64 : %s\n", b64);
}
