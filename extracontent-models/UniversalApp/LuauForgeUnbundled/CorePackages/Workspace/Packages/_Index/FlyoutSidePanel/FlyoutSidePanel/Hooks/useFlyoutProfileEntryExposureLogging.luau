local React = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/React")
local useDrawerVisible = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/Drawer").Hooks.useDrawerVisible
local FStringFlyoutProfileEntryIxpLayer = require("@game/CorePackages/Workspace/Packages/_Index/FlyoutSidePanel/FlyoutSidePanel/Flags/FStringFlyoutProfileEntryIxpLayer")

local IXPService = game:GetService("IXPService")

local function useFlyoutProfileEntryExposureLogging(p2)
	local v5 = useDrawerVisible()
	React.useEffect(function()
		if v5 then
			(p2 or IXPService):LogFlagLinkedUserLayerExposure(FStringFlyoutProfileEntryIxpLayer)
		end
	end, { v5, p2 })
end

return useFlyoutProfileEntryExposureLogging
