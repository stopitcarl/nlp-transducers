#!/bin/bash

shopt -s nullglob  # To prevent failures if there's no tests in a dir.

mkdir -p compiled images

rm compiled/**;
rm images/**;

models=( "copy" "d2dd" "d2dddd" "date2year" "leap" "mm2mmm" "R2A" "skip" "A2R" "birthR2A" "birthA2T" "birthT2R" "birthR2L")
to_test=( "birthR2A" "birthA2T" "birthT2R" "birthR2L" )

containsElement () {
  local e match="$1"
  shift
  for e; do [[ "$e" == "$match" ]] && return 0; done
  return 1
}

# Compile tests
for m in ${models[@]}; do	
    # model=R2A
    model=$m
    # Compile model
    echo "Compiling model: sources/$model.txt"
    
    if test -f "sources/$model.txt"; then
        fstcompile --isymbols=syms.txt --osymbols=syms.txt sources/$model.txt | fstarcsort > compiled/$model.fst
    elif [ "$model" = "A2R" ]; then
        fstinvert compiled/R2A.fst compiled/A2R.fst
    elif [ "$model" = "birthR2A" ]; then
        fstcompose compiled/R2A.fst compiled/d2dd.fst compiled/R2A2dd.fst
        fstcompose compiled/R2A.fst compiled/d2dddd.fst compiled/R2A2dddd.fst       
       
        fstconcat compiled/R2A2dd.fst compiled/copy.fst compiled/$model.fst        
        fstconcat compiled/$model.fst compiled/R2A2dd.fst compiled/$model.fst
        fstconcat compiled/$model.fst compiled/copy.fst compiled/$model.fst
        fstconcat compiled/$model.fst compiled/R2A2dddd.fst compiled/$model.fst
    elif [ "$model" = "birthA2T" ]; then
        fstconcat compiled/copy.fst compiled/copy.fst compiled/$model.fst        
        fstconcat compiled/$model.fst compiled/copy.fst compiled/$model.fst  
        fstconcat compiled/$model.fst compiled/mm2mmm.fst compiled/$model.fst
        fstconcat compiled/$model.fst compiled/copy.fst compiled/$model.fst        
        fstconcat compiled/$model.fst compiled/copy.fst compiled/$model.fst        
        fstconcat compiled/$model.fst compiled/copy.fst compiled/$model.fst        
        fstconcat compiled/$model.fst compiled/copy.fst compiled/$model.fst        
        fstconcat compiled/$model.fst compiled/copy.fst compiled/$model.fst  
    elif [ "$model" = "birthT2R" ]; then           
        fstinvert compiled/birthA2T.fst compiled/birthT2A.fst        
        fstinvert compiled/birthR2A.fst compiled/birthA2R.fst        
        fstcompose compiled/birthT2A.fst compiled/birthA2R.fst compiled/$model.fst

    elif [ "$model" = "birthR2L" ]; then        
        fstcompose compiled/birthR2A.fst compiled/date2year.fst compiled/$model.fst
        fstcompose compiled/$model.fst compiled/leap.fst compiled/$model.fst
    fi
    
    # echo "Imaging model: images/$model.png"
    fstdraw --portrait --isymbols=syms.txt --osymbols=syms.txt compiled/$model.fst | dot -Tpng -Gdpi=300 > images/$model.png

    # Compile tests (only for certain models)
    if containsElement ${model} "${to_test[@]}"; then        
        
        for i in tests/*$model.txt; do
        	# echo "Compiling: $i"                
            fstcompile --isymbols=syms.txt --acceptor $i | fstarcsort > compiled/$(basename $i ".txt")-test.fst
        done

        # Run the tests
        for i in compiled/*$model-test.fst; do
        	echo "Testing: $i"    
            fstcompose $i compiled/$model.fst | fstshortestpath > compiled/result_$(basename $i ".fst").fst
            fstproject --project_output=true compiled/result_$(basename $i ".fst").fst | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt
        done

        for i in compiled/result_test_$model*.fst; do
        	# echo "Creating image: images/$(basename $i '.fst').png"
            fstdraw --portrait --isymbols=syms.txt --osymbols=syms.txt $i | dot -Tpng > images/$(basename $i '.fst').png
        done
    fi
    printf "\n\n########################################\n"    
done
    # echo "Testing the transducer 'converter' with the input 'tests/numeroR.txt' (stdout)"
    # fstcompose compiled/numeroR.fst compiled/converter.fst | fstshortestpath | fstproject | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt
    # fstcompose compiled/numeroR.fst compiled/converter.fst | fstshortestpath | fstproject --project_output=true | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt

    # fstproject  --type=output compiled/result_test_mm2mmm_1.fst | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt


    # fstproject result_test_mm2mmm_1.fst | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt
