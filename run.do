
vlog \
-permissive \
-f compile_files.f

vsim \
-voptargs=+acc \
work.SA_tb_8

run -all
