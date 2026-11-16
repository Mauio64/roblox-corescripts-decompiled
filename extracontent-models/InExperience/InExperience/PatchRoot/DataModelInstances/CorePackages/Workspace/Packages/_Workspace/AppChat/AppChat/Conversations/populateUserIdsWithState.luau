local AppChat = script:FindFirstAncestor("AppChat")

local SocialLibraries = require(AppChat.SocialLibraries)
local populateListFromIds = SocialLibraries.populate.populateListFromIds
local getDeepValue = require(AppChat.Utils.getDeepValue)

return function(p, p2)
	return populateListFromIds(p2, getDeepValue(p, "Users") or {})
end
