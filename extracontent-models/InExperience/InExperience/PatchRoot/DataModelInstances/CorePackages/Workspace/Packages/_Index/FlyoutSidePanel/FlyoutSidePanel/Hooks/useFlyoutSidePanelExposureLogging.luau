local IXPService = game:GetService("IXPService")

local parent = script:FindFirstAncestor("FlyoutSidePanel").Parent

local React = require(parent.React)
local Drawer = require(parent.Drawer)
local useDrawerVisible = Drawer.Hooks.useDrawerVisible

local defineFastString = game:DefineFastString("FlyoutSidePanelIxpLayer", "Universality.MorePage.Exposure")

local function useFlyoutSidePanelExposureLogging(p)
	local v = useDrawerVisible()
	React.useEffect(function()
		if v and defineFastString ~= "" then
			local v2 = if p == nil then IXPService else p
			v2:LogFlagLinkedUserLayerExposure(defineFastString)
		end
	end, { v, p })
end

return useFlyoutSidePanelExposureLogging
