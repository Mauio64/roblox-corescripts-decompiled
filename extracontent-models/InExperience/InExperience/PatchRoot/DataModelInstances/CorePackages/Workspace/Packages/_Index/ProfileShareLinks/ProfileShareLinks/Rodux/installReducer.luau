local ProfileShareLinks = script:FindFirstAncestor("ProfileShareLinks")
local parent = ProfileShareLinks.Parent
local Rodux = require(parent.Rodux)

local configuredRoduxNetworking = require(ProfileShareLinks.Networking.configuredRoduxNetworking)
local ProfileShareLinksReducer = require(script.Parent.ProfileShareLinksReducer)

return function()
	return Rodux.combineReducers({
		ProfileShareLinks = ProfileShareLinksReducer,
		NetworkingStatus = configuredRoduxNetworking.installReducer()
	})
end
