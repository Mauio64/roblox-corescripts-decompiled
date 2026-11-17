return function(p: number)
	local v = p + 1
	return if v >= 9007199254740992 then 0 else v
end
