local ProfileShareLinks = script:FindFirstAncestor("ProfileShareLinks")
local ProfileShareLinksParent = ProfileShareLinks.Parent
local Rodux = require(ProfileShareLinksParent.Rodux)
local configuredRoduxNetworking = require(ProfileShareLinks.Networking.configuredRoduxNetworking)
local ProfileShareLinksReducer = require(script.Parent.ProfileShareLinksReducer)

return function() -- line: 8
	-- upvalues: Rodux (copy), ProfileShareLinksReducer (copy), configuredRoduxNetworking (copy)
	return Rodux.combineReducers({
		ProfileShareLinks = ProfileShareLinksReducer,
		NetworkingStatus = configuredRoduxNetworking.installReducer()
	})
end
