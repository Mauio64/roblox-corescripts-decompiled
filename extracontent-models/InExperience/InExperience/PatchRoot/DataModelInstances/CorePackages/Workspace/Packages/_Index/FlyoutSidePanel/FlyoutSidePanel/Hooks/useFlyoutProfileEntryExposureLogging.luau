local FlyoutSidePanel = script:FindFirstAncestor("FlyoutSidePanel")
local parent = FlyoutSidePanel.Parent

local React = require(parent.React)
local Drawer = require(parent.Drawer)
local useDrawerVisible = Drawer.Hooks.useDrawerVisible
local FStringFlyoutProfileEntryIxpLayer = require(FlyoutSidePanel.Flags.FStringFlyoutProfileEntryIxpLayer)

local IXPService = game:GetService("IXPService")

local function useFlyoutProfileEntryExposureLogging(p)
	local v = useDrawerVisible()
	React.useEffect(function()
		if v then
			(p or IXPService):LogFlagLinkedUserLayerExposure(FStringFlyoutProfileEntryIxpLayer)
		end
	end, { v, p })
end

return useFlyoutProfileEntryExposureLogging
