local v1 = game:DefineFastString("PriceChangedSubscriptionMembershipCheckProductTypes", "")

local function shouldCheckSubscriptionMembershipForProductType(s1: string?) -- line: 9
	-- upvalues: v1 (copy)
	if s1 == nil or v1 == "" then
		return false
	end

	for match in string.gmatch(v1, "[^,]+") do
		local v5 = match:gsub("^%s+", ""):gsub("%s+$", "")

		if v5 ~= "" and v5 == s1 then
			return true
		end
	end

	return false
end

return shouldCheckSubscriptionMembershipForProductType
