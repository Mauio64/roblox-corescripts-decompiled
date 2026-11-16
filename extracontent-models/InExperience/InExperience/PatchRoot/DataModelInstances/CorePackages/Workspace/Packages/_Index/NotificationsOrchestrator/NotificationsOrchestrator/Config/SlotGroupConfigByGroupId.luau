local NotificationsOrchestrator = script:FindFirstAncestor("NotificationsOrchestrator")
require(NotificationsOrchestrator.Enums.SlotGroup)
require(NotificationsOrchestrator.Types)

local globalSlotGroupConfig = {
	frequency = { maxImpressions = 10, window = "session", cooldownSeconds = 60 },
	capacity = 1
}

local slotGroupConfigByGroupId = {}

return {
	GlobalSlotGroupConfig = globalSlotGroupConfig,
	SlotGroupConfigByGroupId = slotGroupConfigByGroupId,
	getSlotGroupConfig = function(p)
		return slotGroupConfigByGroupId[p] or globalSlotGroupConfig
	end
}
