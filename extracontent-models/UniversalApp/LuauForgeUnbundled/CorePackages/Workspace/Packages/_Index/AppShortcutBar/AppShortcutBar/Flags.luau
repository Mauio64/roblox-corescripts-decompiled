local appUserLayers = require("@game/CorePackages/Workspace/Packages/_Workspace/AppShortcutBar/ExperimentLayers").AppUserLayers

return {
	FFlagEnableStickyShortcutBarOnAllPlatformsIxpEnabled = game:DefineFastFlag(
		"EnableStickyShortcutBarOnAllPlatformsIxpEnabled",
		false
	),
	FStringEnableStickyShortcutBarOnAllPlatformsIxpLayer = game:DefineFastString(
		"EnableStickyShortcutBarOnAllPlatformsIxpLayer",
		appUserLayers.UnifyShortcutBarExposureLayer
	),
	FFlagStickyShortcutBarTvRemoteWithGamepad = game:DefineFastFlag(
		"StickyShortcutBarTvRemoteWithGamepad",
		false
	),
	FFlagShortcutBarPlatformGamepadIcons = game:DefineFastFlag("ShortcutBarPlatformGamepadIcons", false)
}
