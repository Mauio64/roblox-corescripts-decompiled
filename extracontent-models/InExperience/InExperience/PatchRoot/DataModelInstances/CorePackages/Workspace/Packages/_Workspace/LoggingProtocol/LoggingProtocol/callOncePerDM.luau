local set = {}

return function(p: string, callback)
	if set[p] then
		return
	end

	set[p] = true
	callback()
end
