local module = require("@game/CorePackages/Workspace/Packages/_Index/AppShortcutBar/AppShortcutBar/Components/AppShortcutBarContainer")
local module2 = require("@game/CorePackages/Workspace/Packages/_Index/AppShortcutBar/AppShortcutBar/Components/AppShortcutBarStatusListener")
local AppShortcut = require("@game/CorePackages/Workspace/Packages/_Index/AppShortcutBar/AppShortcutBar/Components/AppShortcut")
local module4 = require("@game/CorePackages/Workspace/Packages/_Index/AppShortcutBar/AppShortcutBar/Components/StickyShortcutBarExposureLogger")

local module5 = require("@game/CorePackages/Workspace/Packages/_Index/AppShortcutBar/AppShortcutBar/Hooks/AppShortcutBarContext")
local module6 = require("@game/CorePackages/Workspace/Packages/_Index/AppShortcutBar/AppShortcutBar/Hooks")
local module7 = require("@game/CorePackages/Workspace/Packages/_Index/AppShortcutBar/AppShortcutBar/Stores/GetShortcutBarStatusStore")

return {
	AppShortcutBarContainer = module,
	AppShortcutBarStatusListener = module2,
	StickyShortcutBarExposureLogger = module4,
	IconWithHoldAnimation = AppShortcut.IconWithHoldAnimation,
	AppShortcutBarContext = module5,
	Hooks = module6,
	GetShortcutBarStatusStore = module7
}
