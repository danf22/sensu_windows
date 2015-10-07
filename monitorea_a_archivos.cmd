@echo off
WMIC DATAFILE WHERE "path='\\Program Files (x86)\\'" get size, Filename
