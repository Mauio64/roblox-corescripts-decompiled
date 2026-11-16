return function(p2): boolean
	if p2 == nil or tostring(p2) == "" then
		return true
	end

	local v5 = tonumber(p2)
	return v5 ~= nil and v5 <= 0
end
