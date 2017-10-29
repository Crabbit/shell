describe "Runit: command line arguments"

before() {
    usage_result="Usage: runit [-c] [-f procfile|Procfile] [-e envfile|.env]"
    simple_procfile="test/fixtures/simple_procfile"
    simple_envfile="test/fixtures/simple_env_file"
    invalid_procfile="test/fixtures/invalid_procfile"
    invalid_envfile="test/fixtures/invalid_env_file"
}

it_displays_usage_with_error_args() {
    usage=$(bash runit -x | head -n1)
    test "${usage}" = "${usage_result}"
}

it_displays_usage_with_hyphen_and_h() {
    usage=$(bash runit -h | head -n1)
    test "${usage}" = "${usage_result}"
}

it_verifies_invalid_procfile_and_exit_with_err() {
    output=$(bash runit -c -f "${invalid_procfile}" -e "${simple_envfile}"; :)
    grep -q "invalid_char" <(echo ${output})
    grep -q "no_colon_command" <(echo "${output}")
    ! bash runit -c -f "${invalid_procfile}" -e "${simple_envfile}"
}

it_verifies_invalid_envfile_and_exit_with_err() {
    output=$(bash runit -c -f "${simple_procfile}" -e "${invalid_envfile}"; :)
    grep -q "invalid_char" <(echo "${output}") 
    grep -q "value_have_space" <(echo "${output}") 
    grep -q "no_equal_mark" <(echo "${output}") 
    ! bash runit -c -f "${simple_procfile}" -e "${invalid_envfile}"
}
