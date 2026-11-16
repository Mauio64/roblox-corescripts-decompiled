local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppShortcutBar/React")
local ixpServiceWrapper = require("@game/CorePackages/Workspace/Packages/_Workspace/AppShortcutBar/IxpServiceWrapper").IXPServiceWrapper

local fStringEnableStickyShortcutBarOnAllPlatformsIxpLayer = require("@game/CorePackages/Workspace/Packages/_Index/AppShortcutBar/AppShortcutBar/Flags").FStringEnableStickyShortcutBarOnAllPlatformsIxpLayer

local v5 = false

local function useStickyShortcutBarExposureLogging(p2)
	React.useEffect(function()
		if not v5 and p2 then
			v5 = true
			ixpServiceWrapper:LogFlagLinkedUserLayerExposure(fStringEnableStickyShortcutBarOnAllPlatformsIxpLayer)
		end
	end, { p2 })
end

return useStickyShortcutBarExposureLogging
