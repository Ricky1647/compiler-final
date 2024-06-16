make release
echo "-------------------test case1----------------------"
./custom_compiler < testdata.txt
echo "-------------------test case2----------------------"
./custom_compiler < testdata_err.txt
make clean