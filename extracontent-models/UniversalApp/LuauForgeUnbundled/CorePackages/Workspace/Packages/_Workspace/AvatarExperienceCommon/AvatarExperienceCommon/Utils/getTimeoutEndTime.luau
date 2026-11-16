local function getTimeoutEndTime(p2, p3)
	local v5 = p2 or p3

	if v5 == "" then
		return nil
	end

	return v5
end

return getTimeoutEndTime
