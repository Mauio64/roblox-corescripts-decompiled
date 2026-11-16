local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")

local RequestType = require(PurchasePrompt.Enums.RequestType)

local defineFastString = game:DefineFastString("BlackbirdUpsellHiddenRequestTypes2", "")

local function trim(value: string) -- 1 equivalent call inferred from this helper
	return (value:gsub("^%s+", ""):gsub("%s+$", ""))
end

local function matchesHiddenRequestTypeList(p, value: string): boolean
	if p == nil or p == RequestType.None or value == "" then
		return false
	end

	local v = string.lower((tostring(p)))

	for k in string.gmatch(value, "[^,]+") do
		local v2 = string.lower(trim(k)) -- inferred equivalent call

		if v2 ~= "" and v == "requesttype." .. v2 then
			return true
		end
	end

	return false
end

return {
	isRequestTypeHiddenFromBlackbirdUpsell = function(p)
		return matchesHiddenRequestTypeList(p, defineFastString)
	end,
	matchesHiddenRequestTypeList = matchesHiddenRequestTypeList
}
