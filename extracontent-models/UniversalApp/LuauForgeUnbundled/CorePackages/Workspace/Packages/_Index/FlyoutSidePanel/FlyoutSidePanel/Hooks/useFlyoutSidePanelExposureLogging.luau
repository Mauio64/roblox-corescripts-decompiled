local IXPService = game:GetService("IXPService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/React")
local useDrawerVisible = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/Drawer").Hooks.useDrawerVisible

local defineFastString = game:DefineFastString("FlyoutSidePanelIxpLayer", "Universality.MorePage.Exposure")

local function useFlyoutSidePanelExposureLogging(p2)
	local v5 = useDrawerVisible()
	React.useEffect(function()
		if v5 and defineFastString ~= "" then
			local v6 = if p2 == nil then IXPService else p2
			v6:LogFlagLinkedUserLayerExposure(defineFastString)
		end
	end, { v5, p2 })
end

return useFlyoutSidePanelExposureLogging
