local PYMKCarousel = script:FindFirstAncestor("PYMKCarousel")
local dependencies = require(PYMKCarousel.dependencies)

local roduxUsers = dependencies.RoduxUsers
local convertActions = dependencies.convertActions
local llama = dependencies.llama
local usersActionAdaptor = dependencies.usersActionAdaptor
local usersOmniActionAdaptor = require(script.Parent.usersOmniActionAdaptor)

local v = { byUserId = {}, byUsername = {} }

local v2 = roduxUsers.installReducer()

local function fn(p) -- 1 equivalent call inferred from this helper
	return llama.Dictionary.join(usersActionAdaptor(roduxUsers), usersOmniActionAdaptor(p))
end

return function(p)
	return convertActions(v2, fn(p), v) -- inferred equivalent call
end
