#!/bin/bash

model=mm2mmm

mkdir -p compiled images

# Compile model
echo "Compiling: sources/$model.txt"
fstcompile --isymbols=syms.txt --osymbols=syms.txt sources/$model.txt | fstarcsort > compiled/$model.fst

# Compile tests
for i in tests/$model*.txt; do
	echo "Compiling: $i"    
    fstcompile --isymbols=syms.txt --acceptor $i | fstarcsort > compiled/test_$(basename $i ".txt").fst
done


# Run the tests
for i in compiled/test_$model*.fst; do
	echo "Testing: $i"    
    # fstcompose $i compiled/$model.fst | fstshortestpath > compiled/result_$(basename $i ".fst").fst
    fstproject  --project_output=true  compiled/result_$(basename $i ".fst").fst | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt
done

for i in compiled/result_test_$model*.fst; do
	echo "Creating image: images/$(basename $i '.fst').png"
    fstdraw --portrait --isymbols=syms.txt --osymbols=syms.txt $i | dot -Tpng > images/$(basename $i '.fst').png
done

# echo "Testing the transducer 'converter' with the input 'tests/numeroR.txt' (stdout)"
# fstcompose compiled/numeroR.fst compiled/converter.fst | fstshortestpath | fstproject | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt
# fstcompose compiled/numeroR.fst compiled/converter.fst | fstshortestpath | fstproject --project_output=true | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt

# fstproject  --type=output compiled/result_test_mm2mmm_1.fst | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt


# fstproject result_test_mm2mmm_1.fst | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt
