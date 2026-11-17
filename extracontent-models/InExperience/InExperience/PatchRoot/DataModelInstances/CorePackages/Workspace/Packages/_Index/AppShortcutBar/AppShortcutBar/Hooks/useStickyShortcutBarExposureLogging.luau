local AppShortcutBar = script:FindFirstAncestor("AppShortcutBar")
local parent = AppShortcutBar.Parent

local React = require(parent.React)
local IxpServiceWrapper = require(parent.IxpServiceWrapper)
local IXPServiceWrapper = IxpServiceWrapper.IXPServiceWrapper
local logUnifyShortcutBarExposureLogged = require(AppShortcutBar.Telemetry.logUnifyShortcutBarExposureLogged)

local SharedFlags = require(parent.SharedFlags)
local FFlagEnableStickyShortcutBarOnAllPlatforms = SharedFlags.FFlagEnableStickyShortcutBarOnAllPlatforms

local Flags = require(AppShortcutBar.Flags)
local FStringEnableStickyShortcutBarOnAllPlatformsIxpLayer = Flags.FStringEnableStickyShortcutBarOnAllPlatformsIxpLayer
local Flags2 = require(AppShortcutBar.Flags)
local FFlagUnifyShortcutBarExposureTelemetry = Flags2.FFlagUnifyShortcutBarExposureTelemetry

local v = false

local function useStickyShortcutBarExposureLogging(flag: boolean)
	React.useEffect(function()
		if not v and flag then
			v = true

			if FFlagUnifyShortcutBarExposureTelemetry then
				logUnifyShortcutBarExposureLogged(FFlagEnableStickyShortcutBarOnAllPlatforms)
			end

			IXPServiceWrapper:LogFlagLinkedUserLayerExposure(FStringEnableStickyShortcutBarOnAllPlatformsIxpLayer)
		end
	end, { flag })
end

return useStickyShortcutBarExposureLogging
