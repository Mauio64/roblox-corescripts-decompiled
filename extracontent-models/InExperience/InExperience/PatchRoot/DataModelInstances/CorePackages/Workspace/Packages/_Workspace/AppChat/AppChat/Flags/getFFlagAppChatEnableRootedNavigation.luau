local parent = script:FindFirstAncestor("AppChat").Parent

local SharedFlags = require(parent.SharedFlags)
local FFlagExpChatEnableFriendsTab = SharedFlags.FFlagExpChatEnableFriendsTab

return function()
	return FFlagExpChatEnableFriendsTab
end
