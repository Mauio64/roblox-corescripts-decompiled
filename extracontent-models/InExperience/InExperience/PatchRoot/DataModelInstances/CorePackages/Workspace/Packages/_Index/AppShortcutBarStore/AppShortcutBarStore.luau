local GetShortcutBarStatusStore = require(script.GetShortcutBarStatusStore)
require(script.GetShortcutBarStatusStore.createShortcutBarStatusStore)

return {
	["jest.config"] = script["jest.config"],
	GetShortcutBarStatusStore = GetShortcutBarStatusStore
}
