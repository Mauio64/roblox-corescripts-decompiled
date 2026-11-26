return function(items)
	local v5

	if items == nil or items == "" or items == -1 then
		v5 = true
	else
		v5 = typeof(items) == "table" and next(items) == nil
	end

	return v5
end
