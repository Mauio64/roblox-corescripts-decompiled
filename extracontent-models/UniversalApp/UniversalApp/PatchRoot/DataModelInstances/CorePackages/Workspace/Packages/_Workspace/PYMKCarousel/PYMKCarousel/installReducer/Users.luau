local PYMKCarousel = script:FindFirstAncestor("PYMKCarousel")
local dependencies = require(PYMKCarousel.dependencies)
local RoduxUsers = dependencies.RoduxUsers
local convertActions = dependencies.convertActions
local llama = dependencies.llama
local usersActionAdaptor = dependencies.usersActionAdaptor
local usersOmniActionAdaptor = require(script.Parent.usersOmniActionAdaptor)
local t1 = {
	byUserId = {},
	byUsername = {}
}
local v9 = RoduxUsers.installReducer()

return function(p1) -- line: 21
	-- upvalues: convertActions (copy), v9 (copy), llama (copy), usersActionAdaptor (copy), RoduxUsers (copy), usersOmniActionAdaptor (copy), t1 (copy)
	return convertActions(v9, llama.Dictionary.join(usersActionAdaptor(RoduxUsers), usersOmniActionAdaptor(p1)), t1)
end
