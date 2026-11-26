local RequestType = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/RequestType")

local defineFastString = game:DefineFastString("BlackbirdUpsellHiddenRequestTypes2", "")

local function trim(value)
	return (value:gsub("^%s+", ""):gsub("%s+$", ""))
end

local function matchesHiddenRequestTypeList(p2, value): boolean
	if p2 == nil or p2 == RequestType.None or value == "" then
		return false
	end

	local v5 = string.lower((tostring(p2)))

	for k in string.gmatch(value, "[^,]+") do
		local v6 = string.lower((k:gsub("^%s+", ""):gsub("%s+$", "")))

		if v6 ~= "" and v5 == "requesttype." .. v6 then
			return true
		end
	end

	return false
end

return {
	isRequestTypeHiddenFromBlackbirdUpsell = function(p2)
		return matchesHiddenRequestTypeList(p2, defineFastString)
	end,
	matchesHiddenRequestTypeList = matchesHiddenRequestTypeList
}
