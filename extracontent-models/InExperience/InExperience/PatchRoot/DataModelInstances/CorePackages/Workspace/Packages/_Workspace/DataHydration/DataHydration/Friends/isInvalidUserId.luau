return function(p): boolean
	if p == nil or tostring(p) == "" then
		return true
	end

	local v = tonumber(p)
	return v ~= nil and v <= 0
end
