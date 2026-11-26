local AppStorageService = game:GetService("AppStorageService")
local HttpService = game:GetService("HttpService")

local analyticsService = require("@game/CorePackages/Workspace/Packages/_Index/StreamNotifications/StreamNotifications/analytics/analyticsService")
local dependencies = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/ToastNotification/dependencies")
local notificationSnoozedSignal = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/ToastNotification/Signals").NotificationSnoozedSignal
local module3 = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/ToastNotification/type")

local cryo = dependencies.Cryo
local localStorage = dependencies.LocalStorage
local notificationModalsManager = dependencies.NotificationModalsManager
local images = dependencies.UIBlox.App.ImageSet.Images

local localStorageKey = localStorage.Enums.LocalStorageKey

local class = {}

class.__index = class

function class:_batchNotificationAction(data, p2)
	local v5

	if type(data.notificationType) == "table" then
		v5 = data.notificationType
	else
		v5 = { data.notificationType }
	end

	for i, v6 in ipairs(v5) do
		if p2 == module3.SnoozeActionEnum.Mute then
			self.snoozedNotificationTypes[v6] = {
				durationMinutes = data.durationMinutes,
				snoozedTimestampMs = DateTime.now().UnixTimestampMillis
			}
		elseif p2 == module3.SnoozeActionEnum.Unmute and self.snoozedNotificationTypes[v6] then
			self.snoozedNotificationTypes[v6] = nil
		end
	end

	self:_updateAppStorage()

	local context = data.context or ""

	for i, v6 in ipairs(v5) do
		local v7 = {
			action_type = p2,
			duration_minutes = data.durationMinutes,
			notification_type = v6
		}

		self._eventStream.sendEventDeferred(context, "notificationSnoozedEvent", v7)

		notificationSnoozedSignal:fire({
			actionType = p2,
			context = data.context,
			durationMinutes = data.durationMinutes,
			notificationType = v6
		})
	end

	if data.modalMessage and data.modalMessage ~= "" then
		self:_showNotificationsModal(data.modalMessage)
	end
end

function class._isExpiredSnooze(p2): boolean
	return p2.durationMinutes ~= -1
		and (DateTime.now().UnixTimestampMillis - p2.snoozedTimestampMs) / 1000 >= p2.durationMinutes * 60
end

function class:_showNotificationsModal(p3)
	notificationModalsManager.SetUIBloxToast({
		iconImage = images["icons/common/notificationOn"],
		toastTitle = p3
	})
end

function class:_updateAppStorage()
	self._appStorageService:SetItem(
		localStorageKey.SnoozedNotificationTypesLocalStorageKey,
		HttpService:JSONEncode(self.snoozedNotificationTypes)
	)

	self._appStorageService:Flush()
end

function class:unmuteNotification(p2)
	self:_batchNotificationAction(p2, module3.SnoozeActionEnum.Unmute)
end

function class:snoozeNotification(p2)
	self:_batchNotificationAction(p2, module3.SnoozeActionEnum.Mute)
end

function class:isSnoozedNotificationType(p2): boolean
	if not self.snoozedNotificationTypes[p2] then
		return false
	end

	if not self._isExpiredSnooze(self.snoozedNotificationTypes[p2]) then
		return true
	end

	self.snoozedNotificationTypes = cryo.Dictionary.omit(self.snoozedNotificationTypes, p2)
	self:_updateAppStorage()
	return false
end

function class.new(p2)
	local v5 = {
		_appStorageService = p2,
		_eventStream = analyticsService.EventStream,
		snoozedNotificationTypes = {}
	}

	setmetatable(v5, class)

	local v6 = {}
	local v7 = {}
	local flag = false

	local success, result = pcall(function()
		return v5._appStorageService:GetItem(localStorageKey.SnoozedNotificationTypesLocalStorageKey)
	end)

	if success and result ~= "" then
		local success2, result2 = pcall(function()
			return HttpService:JSONDecode(result)
		end)

		if success2 then
			v6 = result2
		end
	end

	for k, v8 in pairs(v6) do
		if v5._isExpiredSnooze(v8) then
			flag = true
		else
			v7[k] = v8
		end
	end

	v5.snoozedNotificationTypes = v7

	if flag then
		v5:_updateAppStorage()
	end

	return v5
end

class.default = class.new(AppStorageService)
return class
