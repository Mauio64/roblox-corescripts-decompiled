local parent = script:FindFirstAncestor("AppShortcutBar").Parent

local ExperimentLayers = require(parent.ExperimentLayers)
local AppUserLayers = ExperimentLayers.AppUserLayers

return {
	FFlagEnableStickyShortcutBarOnAllPlatformsIxpEnabled = game:DefineFastFlag(
		"EnableStickyShortcutBarOnAllPlatformsIxpEnabled",
		false
	),
	FStringEnableStickyShortcutBarOnAllPlatformsIxpLayer = game:DefineFastString(
		"EnableStickyShortcutBarOnAllPlatformsIxpLayer",
		AppUserLayers.UnifyShortcutBarExposureLayer
	),
	FFlagStickyShortcutBarTvRemoteWithGamepad = game:DefineFastFlag("StickyShortcutBarTvRemoteWithGamepad", false),
	FFlagShortcutBarPlatformGamepadIcons = game:DefineFastFlag("ShortcutBarPlatformGamepadIcons", false),
	FFlagUnifyShortcutBarExposureTelemetry = game:DefineFastFlag("UnifyShortcutBarExposureTelemetry", false)
}
