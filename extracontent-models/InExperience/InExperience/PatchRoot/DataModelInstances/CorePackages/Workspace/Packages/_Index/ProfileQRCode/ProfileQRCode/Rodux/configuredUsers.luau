local parent = script:FindFirstAncestor("ProfileQRCode").Parent
local SocialReducerAdaptors = require(parent.SocialReducerAdaptors)
local convertActions = SocialReducerAdaptors.convertActions
local SocialReducerAdaptors2 = require(parent.SocialReducerAdaptors)
local usersActionAdaptor = SocialReducerAdaptors2.usersActionAdaptor
local RoduxUsers = require(script.Parent.RoduxUsers)

local v = { byUserId = {}, byUsername = {} }

local v2 = RoduxUsers.installReducer()

return function()
	return convertActions(v2, usersActionAdaptor(RoduxUsers), v)
end
