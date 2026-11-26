local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/dependencies")

local roduxUsers = dependencies.RoduxUsers
local convertActions = dependencies.convertActions
local llama = dependencies.llama
local usersActionAdaptor = dependencies.usersActionAdaptor
local usersOmniActionAdaptor = require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/installReducer/usersOmniActionAdaptor")

local v5 = { byUserId = {}, byUsername = {} }

local v6 = roduxUsers.installReducer()

return function(p2)
	return convertActions(v6, llama.Dictionary.join(usersActionAdaptor(roduxUsers), usersOmniActionAdaptor(p2)), v5)
end
