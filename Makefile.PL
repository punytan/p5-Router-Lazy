use inc::Module::Install;
name 'Router-Lazy';
all_from 'lib/Router/Lazy.pm';

# requires '';

tests 't/*.t';
author_tests 'xt';

test_requires 'Test::More';
auto_set_repository;
auto_include;
WriteAll;
