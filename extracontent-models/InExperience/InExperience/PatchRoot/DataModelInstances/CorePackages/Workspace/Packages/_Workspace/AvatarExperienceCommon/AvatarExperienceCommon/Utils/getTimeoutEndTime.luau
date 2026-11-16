local function getTimeoutEndTime(p: string?, p2: string?)
	local v = p or p2
	return if v ~= "" then v else nil
end

return getTimeoutEndTime
