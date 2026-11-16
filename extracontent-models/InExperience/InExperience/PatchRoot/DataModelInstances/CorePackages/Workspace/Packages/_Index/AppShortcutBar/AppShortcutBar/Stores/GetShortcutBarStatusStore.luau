local parent = script:FindFirstAncestor("AppShortcutBar").Parent

local Signals = require(parent.Signals)
local createShortcutBarStatusStore = require(script.createShortcutBarStatusStore)

local SharedFlags = require(parent.SharedFlags)

if not SharedFlags.FFlagEnableStickyShortcutBarOnAllPlatforms then
	return Signals.createComputed(createShortcutBarStatusStore)
end

local AppShortcutBarStore = require(parent.AppShortcutBarStore)
return AppShortcutBarStore.GetShortcutBarStatusStore
