local ProfileShareLinks = script:FindFirstAncestor("ProfileShareLinks")
local ProfileShareLinksParent = ProfileShareLinks.Parent
local Rodux = require(ProfileShareLinksParent.Rodux)
local Networking = require(ProfileShareLinks.Networking.Networking)

return Rodux.createReducer({}, {
	[Networking.ShareLinksNetworking.GetOrGenerateLink.Succeeded.name] = function(_, p2) -- line: 10
		return p2.responseBody
	end
})
