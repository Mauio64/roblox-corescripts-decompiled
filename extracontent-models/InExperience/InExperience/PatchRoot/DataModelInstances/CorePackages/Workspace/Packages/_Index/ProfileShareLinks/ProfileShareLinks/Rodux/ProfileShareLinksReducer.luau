local ProfileShareLinks = script:FindFirstAncestor("ProfileShareLinks")
local parent = ProfileShareLinks.Parent
local Rodux = require(parent.Rodux)

local Networking = require(ProfileShareLinks.Networking.Networking)

return Rodux.createReducer({}, {
	[Networking.ShareLinksNetworking.GetOrGenerateLink.Succeeded.name] = function(_, p)
		return p.responseBody
	end
})
