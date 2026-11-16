local defineFastString = game:DefineFastString("PriceChangedSubscriptionMembershipCheckProductTypes", "")

local function shouldCheckSubscriptionMembershipForProductType(p: string?): boolean
	if p == nil or defineFastString == "" then
		return false
	end

	for k in string.gmatch(defineFastString, "[^,]+") do
		local v = k:gsub("^%s+", ""):gsub("%s+$", "")

		if v ~= "" and v == p then
			return true
		end
	end

	return false
end

return shouldCheckSubscriptionMembershipForProductType
