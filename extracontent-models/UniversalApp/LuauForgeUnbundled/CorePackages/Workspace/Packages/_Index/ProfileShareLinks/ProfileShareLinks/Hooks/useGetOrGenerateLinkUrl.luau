local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileShareLinks/React")
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileShareLinks/RoactUtils").Hooks.RoactRodux.useDispatch

local Networking = require("@game/CorePackages/Workspace/Packages/_Index/ProfileShareLinks/ProfileShareLinks/Networking/Networking")

return function()
	local v5 = useDispatch()

	return (React.useCallback(function()
		return v5(Networking.ShareLinksNetworking.GetOrGenerateLink.API({
			linkType = "Profile"
		})):catch(function() end)
	end, { v5 }))
end
