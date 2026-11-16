return function(p): boolean
	return if type(p) == "userdata" and p.rawValue then true else false
end
