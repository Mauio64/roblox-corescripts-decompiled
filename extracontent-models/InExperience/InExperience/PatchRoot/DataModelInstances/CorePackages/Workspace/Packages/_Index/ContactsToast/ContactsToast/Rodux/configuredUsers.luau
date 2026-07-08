local Parent = script:FindFirstAncestor("ContactsToast").Parent
local convertActions = require(Parent.SocialReducerAdaptors).convertActions
local usersActionAdaptor = require(Parent.SocialReducerAdaptors).usersActionAdaptor
local RoduxUsers = require(script.Parent.RoduxUsers)
local t1 = {
	byUserId = {},
	byUsername = {}
}
local v6 = RoduxUsers.installReducer()

return function() -- line: 14
	-- upvalues: convertActions (copy), v6 (copy), usersActionAdaptor (copy), RoduxUsers (copy), t1 (copy)
	return convertActions(v6, usersActionAdaptor(RoduxUsers), t1)
end
