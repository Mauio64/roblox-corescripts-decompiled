return function(p)
	return {
		["metadata"] = p.fromString("accountinformation:metadata"),
		phone = p.fromString("accountinformation:phone")
	}
end
