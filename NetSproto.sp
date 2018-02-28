.package {
	type 0 : integer
	session 1 : integer
}

set 1 {
	request {
		key 0 : string
		value 1 : string
	}
}

get 2 {
	request { 
		key 0 : string
	}
	response {
		value 0 : string
	}
}

quit 3 {}