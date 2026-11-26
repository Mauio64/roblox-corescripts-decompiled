local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppShortcutBar/React")
local ixpServiceWrapper = require("@game/CorePackages/Workspace/Packages/_Workspace/AppShortcutBar/IxpServiceWrapper").IXPServiceWrapper
local logUnifyShortcutBarExposureLogged = require("@game/CorePackages/Workspace/Packages/_Index/AppShortcutBar/AppShortcutBar/Telemetry/logUnifyShortcutBarExposureLogged")

local fFlagEnableStickyShortcutBarOnAllPlatforms = require("@game/CorePackages/Workspace/Packages/_Workspace/AppShortcutBar/SharedFlags").FFlagEnableStickyShortcutBarOnAllPlatforms

local fStringEnableStickyShortcutBarOnAllPlatformsIxpLayer = require("@game/CorePackages/Workspace/Packages/_Index/AppShortcutBar/AppShortcutBar/Flags").FStringEnableStickyShortcutBarOnAllPlatformsIxpLayer
local fFlagUnifyShortcutBarExposureTelemetry = require("@game/CorePackages/Workspace/Packages/_Index/AppShortcutBar/AppShortcutBar/Flags").FFlagUnifyShortcutBarExposureTelemetry

local v5 = false

local function useStickyShortcutBarExposureLogging(p2)
	React.useEffect(function()
		if not v5 and p2 then
			v5 = true

			if fFlagUnifyShortcutBarExposureTelemetry then
				logUnifyShortcutBarExposureLogged(fFlagEnableStickyShortcutBarOnAllPlatforms)
			end

			ixpServiceWrapper:LogFlagLinkedUserLayerExposure(fStringEnableStickyShortcutBarOnAllPlatformsIxpLayer)
		end
	end, { p2 })
end

return useStickyShortcutBarExposureLogging
