#!/bin/bash

echo "===================================="
echo " DSO-TAP Project Health Check"
echo "===================================="

echo ""
echo "[1] Current User"
whoami

echo ""
echo "[2] Current Directory"
pwd

echo ""
echo "[3] Current Branch"
git branch --show-current

echo ""
echo "[4] Git Status"
git status --short

echo ""
echo "[5] Latest Commit"
git log -1 --oneline

echo ""
echo "[6] Repository Files"
ls -lah

echo ""
echo "Health check completed successfully."