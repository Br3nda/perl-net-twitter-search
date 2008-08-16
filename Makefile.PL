# Load the Module::Install bundled in ./inc/
use inc::Module::Install;

# Define metadata
name            'Net-Twitter-Search';
all_from        'lib/Net/Twitter/Search.pm';

# Specific dependencies
requires        'Net::Twitter'              => 0;
#build_requires  'Test::More'        => '0.42';
#recommends      'Your::OtherModule' => '0.01';

#no_index        'directory'         => 'demos';

#install_script  'bin/myscript';

auto_install;
WriteAll;
