local ProfileShareLinks = script:FindFirstAncestor("ProfileShareLinks")
local parent = ProfileShareLinks.Parent
local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch

local Networking = require(ProfileShareLinks.Networking.Networking)

return function()
	local v = useDispatch()

	return (React.useCallback(function()
		return v(Networking.ShareLinksNetworking.GetOrGenerateLink.API({ linkType = "Profile" })):catch(function() end)
	end, { v }))
end
