require(script.Types)
local SlotId = require(script.Enums.SlotId)
local SlotGroup = require(script.Enums.SlotGroup)
local SlotGroupBySlotId = require(script.Config.SlotGroupBySlotId)
local SlotGroupConfigByGroupId = require(script.Config.SlotGroupConfigByGroupId)
local SlotConfigBySlotId = require(script.Config.SlotConfigBySlotId)
local GetNotificationsStore = require(script.Stores.GetNotificationsStore)

return {
	SlotId = SlotId,
	SlotGroup = SlotGroup,
	SlotGroupBySlotId = SlotGroupBySlotId,
	GlobalSlotGroupConfig = SlotGroupConfigByGroupId.GlobalSlotGroupConfig,
	SlotGroupConfigByGroupId = SlotGroupConfigByGroupId.SlotGroupConfigByGroupId,
	getSlotGroupConfig = SlotGroupConfigByGroupId.getSlotGroupConfig,
	GlobalSlotConfig = SlotConfigBySlotId.GlobalSlotConfig,
	SlotConfigBySlotId = SlotConfigBySlotId.SlotConfigBySlotId,
	getSlotConfig = SlotConfigBySlotId.getSlotConfig,
	GetNotificationsStore = GetNotificationsStore,
	submit = function(p)
		return GetNotificationsStore(false).submit(p)
	end,
	revoke = function(p)
		GetNotificationsStore(false).revoke(p)
	end,
	report = function(p, p2, p3)
		GetNotificationsStore(false).report(p, p2, p3)
	end,
	getActiveForSlot = function(p)
		return GetNotificationsStore(false).getActiveForSlot(p)
	end,
	["jest.config"] = script["jest.config"]
}
