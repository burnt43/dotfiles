alias fuzzy_dev="ruby3 && cd ~/git_clones/fuzzy-search"
alias fuzzy_compile="fuzzy_dev && cd ./c && ./configure && make"
alias fuzzy_main_run="fuzzy_dev && cd ./c && sed -i '1s/MYSQL_PLUGIN_MODE [0-9]/MYSQL_PLUGIN_MODE 0/' ./src/kens_big_file.cpp && g++ ./src/kens_big_file.cpp -o a.out && ./a.out"
alias fuzzy_restore="fuzzy_dev && cd ./c && sed -i '1s/MYSQL_PLUGIN_MODE [0-9]/MYSQL_PLUGIN_MODE 1/' ./src/kens_big_file.cpp"
