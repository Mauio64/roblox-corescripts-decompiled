local populateUserWithState = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Users/populateUserWithState")
local Logger = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatDetails/Logger")

return function(p2, items, p3)
	local users = p2.Users

	local result = {}

	for k, item in pairs(items) do
		local user = users[item]
		local v5 = if p3 then p3[k] else nil

		if user then
			local v6 = populateUserWithState(p2, user, v5)
			result[user.id] = v6
		else
			Logger:warning("user is required in selectChatUserEntryModelList")
		end
	end

	return result
end
