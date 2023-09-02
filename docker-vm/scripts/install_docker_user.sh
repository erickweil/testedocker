#!/bin/bash

# Adiciona ao grupo docker, se existir
usermod -aG docker $USERNAME || true