local convertActions = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileQRCode/SocialReducerAdaptors").convertActions
local usersActionAdaptor = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileQRCode/SocialReducerAdaptors").usersActionAdaptor
local RoduxUsers = require("@game/CorePackages/Workspace/Packages/_Index/ProfileQRCode/ProfileQRCode/Rodux/RoduxUsers")

local v5 = { byUserId = {}, byUsername = {} }

local v6 = RoduxUsers.installReducer()

return function()
	return convertActions(v6, usersActionAdaptor(RoduxUsers), v5)
end
