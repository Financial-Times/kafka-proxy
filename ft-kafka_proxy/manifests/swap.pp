class swap::create_swap {

	swap_file::files { 'swapfile':
		ensure       => present,
		swapfile     => '/mnt/swap.1',
		swapfilesize => '1024 MB',
		add_mount    => true
	}

}
