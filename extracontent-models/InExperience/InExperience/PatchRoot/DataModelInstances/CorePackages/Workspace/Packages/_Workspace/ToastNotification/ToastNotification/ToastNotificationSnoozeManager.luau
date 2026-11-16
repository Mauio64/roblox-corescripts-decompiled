local AppStorageService = game:GetService("AppStorageService")
local HttpService = game:GetService("HttpService")

local parent = script.Parent

local analyticsService = require(parent.analytics.analyticsService)
local dependencies = require(parent.dependencies)
local Signals = require(parent.Signals)
local NotificationSnoozedSignal = Signals.NotificationSnoozedSignal
local kind = require(parent.type)

local cryo = dependencies.Cryo
local localStorage = dependencies.LocalStorage
local notificationModalsManager = dependencies.NotificationModalsManager
local images = dependencies.UIBlox.App.ImageSet.Images

local localStorageKey = localStorage.Enums.LocalStorageKey

local ToastNotificationSnoozeManager = {}

ToastNotificationSnoozeManager.__index = ToastNotificationSnoozeManager

function ToastNotificationSnoozeManager:_batchNotificationAction(data, p: string)
	local v

	if type(data.notificationType) == "table" then
		v = data.notificationType
	else
		v = { data.notificationType }
	end

	for _, v2 in ipairs(v) do
		if p == kind.SnoozeActionEnum.Mute then
			self.snoozedNotificationTypes[v2] = {
				durationMinutes = data.durationMinutes,
				snoozedTimestampMs = DateTime.now().UnixTimestampMillis
			}
		elseif p == kind.SnoozeActionEnum.Unmute and self.snoozedNotificationTypes[v2] then
			self.snoozedNotificationTypes[v2] = nil
		end
	end

	self:_updateAppStorage()

	local context = data.context or ""

	for _, v2 in ipairs(v) do
		local v3 = {
			action_type = p,
			duration_minutes = data.durationMinutes,
			notification_type = v2
		}

		self._eventStream.sendEventDeferred(context, "notificationSnoozedEvent", v3)

		NotificationSnoozedSignal:fire({
			actionType = p,
			context = data.context,
			durationMinutes = data.durationMinutes,
			notificationType = v2
		})
	end

	if data.modalMessage and data.modalMessage ~= "" then
		self:_showNotificationsModal(data.modalMessage)
	end
end

function ToastNotificationSnoozeManager._isExpiredSnooze(p): boolean
	return p.durationMinutes ~= -1
		and (DateTime.now().UnixTimestampMillis - p.snoozedTimestampMs) / 1000 >= p.durationMinutes * 60
end

function ToastNotificationSnoozeManager:_showNotificationsModal(toastTitle: string)
	notificationModalsManager.SetUIBloxToast({
		iconImage = images["icons/common/notificationOn"],
		toastTitle = toastTitle
	})
end

function ToastNotificationSnoozeManager:_updateAppStorage()
	self._appStorageService:SetItem(
		localStorageKey.SnoozedNotificationTypesLocalStorageKey,
		HttpService:JSONEncode(self.snoozedNotificationTypes)
	)

	self._appStorageService:Flush()
end

function ToastNotificationSnoozeManager:unmuteNotification(p)
	self:_batchNotificationAction(p, kind.SnoozeActionEnum.Unmute)
end

function ToastNotificationSnoozeManager:snoozeNotification(p)
	self:_batchNotificationAction(p, kind.SnoozeActionEnum.Mute)
end

function ToastNotificationSnoozeManager:isSnoozedNotificationType(p: string): boolean
	if not self.snoozedNotificationTypes[p] then
		return false
	end

	if not self._isExpiredSnooze(self.snoozedNotificationTypes[p]) then
		return true
	end

	self.snoozedNotificationTypes = cryo.Dictionary.omit(self.snoozedNotificationTypes, p)
	self:_updateAppStorage()
	return false
end

function ToastNotificationSnoozeManager.new(appStorageService)
	local v = {
		_appStorageService = appStorageService,
		_eventStream = analyticsService.EventStream,
		snoozedNotificationTypes = {}
	}

	setmetatable(v, ToastNotificationSnoozeManager)

	local v2 = {}
	local snoozedNotificationTypes = {}
	local flag = false

	local success, result = pcall(function()
		return v._appStorageService:GetItem(localStorageKey.SnoozedNotificationTypesLocalStorageKey)
	end)

	if success and result ~= "" then
		local success2, result2 = pcall(function()
			return HttpService:JSONDecode(result)
		end)

		if success2 then
			v2 = result2
		end
	end

	for k, v3 in pairs(v2) do
		if v._isExpiredSnooze(v3) then
			flag = true
		else
			snoozedNotificationTypes[k] = v3
		end
	end

	v.snoozedNotificationTypes = snoozedNotificationTypes

	if flag then
		v:_updateAppStorage()
	end

	return v
end

ToastNotificationSnoozeManager.default = ToastNotificationSnoozeManager.new(AppStorageService)
return ToastNotificationSnoozeManager
