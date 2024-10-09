#!/bin/sh

ORIGINAL_PATH="/home/roberto/"
NEW_PATH="$HOME/"

find . -type f -exec sed -i "s,$ORIGINAL_PATH,$NEW_PATH,g" {} \;
