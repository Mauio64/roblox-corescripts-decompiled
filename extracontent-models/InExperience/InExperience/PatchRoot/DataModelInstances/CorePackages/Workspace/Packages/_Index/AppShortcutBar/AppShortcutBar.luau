local AppShortcutBarContainer = require(script.Components.AppShortcutBarContainer)
local AppShortcutBarStatusListener = require(script.Components.AppShortcutBarStatusListener)
local AppShortcut = require(script.Components.AppShortcut)
local StickyShortcutBarExposureLogger = require(script.Components.StickyShortcutBarExposureLogger)

local AppShortcutBarContext = require(script.Hooks.AppShortcutBarContext)
local Hooks = require(script.Hooks)
local GetShortcutBarStatusStore = require(script.Stores.GetShortcutBarStatusStore)

return {
	AppShortcutBarContainer = AppShortcutBarContainer,
	AppShortcutBarStatusListener = AppShortcutBarStatusListener,
	StickyShortcutBarExposureLogger = StickyShortcutBarExposureLogger,
	IconWithHoldAnimation = AppShortcut.IconWithHoldAnimation,
	AppShortcutBarContext = AppShortcutBarContext,
	Hooks = Hooks,
	GetShortcutBarStatusStore = GetShortcutBarStatusStore,
	["jest.config"] = script["jest.config"]
}
