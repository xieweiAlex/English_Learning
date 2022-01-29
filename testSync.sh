#!/usr/bin/env bats

@test "addition using bc" {
  result="$(echo 2+2 | bc)"
  [ "$result" -eq 4 ]
}

@test "addition using dc" {
  result="$(echo 2 2+p | dc)"
  [ "$result" -eq 4 ]
}

@test "Testing words search" {

  PATTERN="\*{2,}[a-zA-Z]+.*-{1,3}(\s{0,5} | \n )$"
  file_path="./words/2021/words-April.md"
  content=$(ag "$PATTERN" -G "$file_path" --group --nonumbers --nofilename | sed '/^[[:space:]]*$/d')

  echo "something"
}
