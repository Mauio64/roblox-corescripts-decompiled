local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local RequestType = require(PurchasePrompt.Enums.RequestType)
local v3 = game:DefineFastString("BlackbirdUpsellHiddenRequestTypes2", "")

local function trim(s1: string) -- line: 17
	return (s1:gsub("^%s+", ""):gsub("%s+$", ""))
end
local function matchesHiddenRequestTypeList(p1, s2: string) -- line: 24
	-- upvalues: RequestType (copy)
	if p1 == nil or p1 == RequestType.None then
		return false
	end

	if s2 == "" then
		return false
	end

	local v9 = string.lower((tostring(p1)))

	for match in string.gmatch(s2, "[^,]+") do
		local v11 = string.lower((match:gsub("^%s+", ""):gsub("%s+$", "")))

		if v11 ~= "" and v9 == "requesttype." .. v11 then
			return true
		end
	end

	return false
end

return {
	isRequestTypeHiddenFromBlackbirdUpsell = function(p2) -- line: 45
		-- upvalues: matchesHiddenRequestTypeList (copy), v3 (copy)
		return (matchesHiddenRequestTypeList(p2, v3))
	end,
	matchesHiddenRequestTypeList = matchesHiddenRequestTypeList
}
