local AppShortcutBar = script:FindFirstAncestor("AppShortcutBar")
local parent = AppShortcutBar.Parent

local React = require(parent.React)
local IxpServiceWrapper = require(parent.IxpServiceWrapper)
local IXPServiceWrapper = IxpServiceWrapper.IXPServiceWrapper

local Flags = require(AppShortcutBar.Flags)
local FStringEnableStickyShortcutBarOnAllPlatformsIxpLayer = Flags.FStringEnableStickyShortcutBarOnAllPlatformsIxpLayer

local v = false

local function useStickyShortcutBarExposureLogging(flag: boolean)
	React.useEffect(function()
		if not v and flag then
			v = true
			IXPServiceWrapper:LogFlagLinkedUserLayerExposure(FStringEnableStickyShortcutBarOnAllPlatformsIxpLayer)
		end
	end, { flag })
end

return useStickyShortcutBarExposureLogging
