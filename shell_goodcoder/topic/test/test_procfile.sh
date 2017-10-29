describe "Runit: procfile"

it_runs_simple_processes() {
    output=$(bash runit -f 'test/fixtures/simple_procfile'; :)
    echo "${output}" | grep -q "Hello"
}

it_passes_environment_variables_to_processes() {
    output=$(FOO=bar bash runit -f 'test/fixtures/procfile_with_env'; :)
    grep -q "FOO = bar" <(echo "${output}")
}

it_ignores_comments_in_proc_file() {
    output=$(bash runit -f 'test/fixtures/procfile_with_comments'; :)
    line0=$(echo "${output}" | wc -l)
    line1=$(echo "${output}" | grep "abc" | wc -l)
    line2=$(echo "${output}" | grep "def" | wc -l)
    line3=$(echo "${output}" | grep "ghi" | wc -l)
    test ${line0} -eq 2 -a ${line1} -eq 0 -a ${line2} -eq 0 -a ${line3} -eq 2 
}

