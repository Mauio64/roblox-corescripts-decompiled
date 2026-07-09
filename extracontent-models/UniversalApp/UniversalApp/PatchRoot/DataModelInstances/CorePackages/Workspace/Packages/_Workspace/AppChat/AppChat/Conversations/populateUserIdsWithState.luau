local AppChat = script:FindFirstAncestor("AppChat")
local populateListFromIds = require(AppChat.SocialLibraries).populate.populateListFromIds
local getDeepValue = require(AppChat.Utils.getDeepValue)

return function(p1, p2) -- line: 12
	-- upvalues: getDeepValue (copy), populateListFromIds (copy)
	local v6 = getDeepValue(p1, "Users") or {}

	return populateListFromIds(p2, v6)
end
