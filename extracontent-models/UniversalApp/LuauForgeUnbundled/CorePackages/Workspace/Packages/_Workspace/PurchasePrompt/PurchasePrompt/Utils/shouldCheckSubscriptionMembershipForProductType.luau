local defineFastString = game:DefineFastString("PriceChangedSubscriptionMembershipCheckProductTypes", "")

local function shouldCheckSubscriptionMembershipForProductType(p2): boolean
	if p2 == nil or defineFastString == "" then
		return false
	end

	for k in string.gmatch(defineFastString, "[^,]+") do
		local v5 = k:gsub("^%s+", ""):gsub("%s+$", "")

		if v5 ~= "" and v5 == p2 then
			return true
		end
	end

	return false
end

return shouldCheckSubscriptionMembershipForProductType
