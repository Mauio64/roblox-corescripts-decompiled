local set = {}

return function(p2, callback)
	if set[p2] then
		return
	end

	set[p2] = true
	callback()
end
