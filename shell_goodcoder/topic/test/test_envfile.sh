describe "Runit: envfile"

it_ignores_comments_in_env_file() {
    output=$(bash runit -f 'test/fixtures/procfile_with_invalid_env' \
                        -e 'test/fixtures/env_file_with_comments'; :)
    echo "${output}" | grep -q "42 does not contain: bar"
}

it_assigns_a_default_port_number() {
    output=$(bash runit -f 'test/fixtures/procfile_with_port_number'; :)
    echo "${output}" | grep -q "8080"
}

it_allows_overriding_the_port_number() {
    output=$(bash runit -f 'test/fixtures/procfile_with_port_number' \
                        -e 'test/fixtures/env_file_with_port_number'; :)
    echo "${output}" | grep -q "8900"
}

it_can_increase_port_number() {
    output=$(bash runit -f 'test/fixtures/procfile_with_2_ports'; :)
    echo "${output}" | grep -q "8080"
    echo "${output}" | grep -q "8081"
    echo "${output}" | grep -v -q "8082"
}
