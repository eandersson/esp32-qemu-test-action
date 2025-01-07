#!/usr/bin/env bash
set -e
CODE_PATH="$1"
. $IDF_PATH/export.sh
cd ${CODE_PATH}
cd build
esptool.py --chip esp32s3 merge_bin --fill-flash-size 16MB -o flash_image.bin @flash_args

/opt/qemu/bin/qemu-system-xtensa -machine esp32s3 -nographic -no-reboot -drive file=flash_image.bin,if=mtd,format=raw -m 4 -serial file:output.log
grep -q -E '[[:digit:]]+ Tests [[:digit:]]+ Failures [[:digit:]]+ Ignored' output.log && ruby /opt/Unity-*/auto/parse_output.rb -xml output.log || exit 1
mv report.xml /github/workspace
