#!/bin/bash


shopt -s nullglob  # To prevent failures if there's no tests in a dir.
mkdir -p compiled images

rm compiled/*
rm images/*

# Compile tests
for m in sources/$model*.txt; do	
    # model=R2A
    model=$(basename $m ".txt")
    # Compile model
    echo "Compiling model: sources/$model.txt"
    fstcompile --isymbols=syms.txt --osymbols=syms.txt sources/$model.txt | fstarcsort > compiled/$model.fst
    # echo "Imaging model: images/$model.png"
    fstdraw --portrait --isymbols=syms.txt --osymbols=syms.txt compiled/$model.fst | dot -Tpng > images/$model.png

    # Compile tests    
    for i in tests/$model\_*.txt; do
    	# echo "Compiling: $i"    
        fstcompile --isymbols=syms.txt --acceptor $i | fstarcsort > compiled/test_$(basename $i ".txt").fst
    done


    # Run the tests
    for i in compiled/test_$model*.fst; do
    	echo "Testing: $i"    
        fstcompose $i compiled/$model.fst | fstshortestpath > compiled/result_$(basename $i ".fst").fst
        fstproject --project_output=true compiled/result_$(basename $i ".fst").fst | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt
    done

    for i in compiled/result_test_$model*.fst; do
    	# echo "Creating image: images/$(basename $i '.fst').png"
        fstdraw --portrait --isymbols=syms.txt --osymbols=syms.txt $i | dot -Tpng > images/$(basename $i '.fst').png
    done
    printf "\n\n########################################\n"    
done
    # echo "Testing the transducer 'converter' with the input 'tests/numeroR.txt' (stdout)"
    # fstcompose compiled/numeroR.fst compiled/converter.fst | fstshortestpath | fstproject | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt
    # fstcompose compiled/numeroR.fst compiled/converter.fst | fstshortestpath | fstproject --project_output=true | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt

    # fstproject  --type=output compiled/result_test_mm2mmm_1.fst | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt


    # fstproject result_test_mm2mmm_1.fst | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt
