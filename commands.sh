# Compile model
fstcompile --isymbols=syms.txt --osymbols=syms.txt sources/mm2mmm.txt | fstarcsort > compiled/trans.fst

# Draw model
fstdraw --isymbols=syms.txt --osymbols=syms.txtt compiled/trans.fst | dot -Tpdf > pdf/trans.pdf

# Compile input
fstcompile --isymbols=syms.txt --osymbols=syms.txt tests/mm2mmm_1.txt | fstarcsort > compiled/mm2mmm_test_1.fst

# Get output stdout
fstcompose compiled/mm2mmm_test_1.fst compiled/trans.fst | fstshortestpath | fstproject | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=syms.txt


# Paint output
fstcompose compiled/mm2mmm_test_1.fst compiled/trans.fst | fstshortestpath > compiled/test_result.fst
fstdraw --portrait --isymbols=syms.txt --osymbols=syms.txt compiled/test_result.fst | dot -Tpdf > pdf/test_result.fst.pdf
