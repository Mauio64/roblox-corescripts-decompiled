local NotificationsOrchestrator = script:FindFirstAncestor("NotificationsOrchestrator")
require(NotificationsOrchestrator.Enums.SlotId)
require(NotificationsOrchestrator.Types)

local globalSlotConfig = {
	lifecycle = {
		frequency = { maxImpressions = 10, window = "session", cooldownSeconds = 60 },
		visibility = { delayMs = 0, autoDismissAfterMs = 0 }
	}
}

local slotConfigBySlotId = {}

return {
	GlobalSlotConfig = globalSlotConfig,
	SlotConfigBySlotId = slotConfigBySlotId,
	getSlotConfig = function(p)
		return slotConfigBySlotId[p] or globalSlotConfig
	end
}
