local NotificationsOrchestrator = script:FindFirstAncestor("NotificationsOrchestrator")
local SlotId = require(NotificationsOrchestrator.Enums.SlotId)
local SlotGroup = require(NotificationsOrchestrator.Enums.SlotGroup)

return {
	[SlotId.EducationTooltipOnHamburger] = SlotGroup.PopUps,
	[SlotId.EducationTooltipOnShopIcon] = SlotGroup.PopUps
}
