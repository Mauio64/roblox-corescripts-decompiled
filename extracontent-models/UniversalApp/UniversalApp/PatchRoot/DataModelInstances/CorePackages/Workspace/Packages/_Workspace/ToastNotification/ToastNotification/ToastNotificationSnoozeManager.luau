local AppStorageService = game:GetService("AppStorageService")
local HttpService = game:GetService("HttpService")
local scriptParent = script.Parent
local analyticsService = require(scriptParent.analytics.analyticsService)
local dependencies = require(scriptParent.dependencies)
local NotificationSnoozedSignal = require(scriptParent.Signals).NotificationSnoozedSignal
local type2 = require(scriptParent.type)
local Cryo = dependencies.Cryo
local LocalStorage = dependencies.LocalStorage
local NotificationModalsManager = dependencies.NotificationModalsManager
local Images = dependencies.UIBlox.App.ImageSet.Images
local LocalStorageKey = LocalStorage.Enums.LocalStorageKey
local t1 = {}

t1.__index = t1

function t1._batchNotificationAction(t2: {[any]: any}, t3: {[any]: any}, s1: string) -- line: 31
	-- upvalues: type2 (copy), NotificationSnoozedSignal (copy)
	local v17 = if type(t3.notificationType) ~= "table" then { t3.notificationType } else t3.notificationType

	for _, v in ipairs(v17) do
		if s1 == type2.SnoozeActionEnum.Mute then
			t2.snoozedNotificationTypes[v] = {
				durationMinutes = t3.durationMinutes,
				snoozedTimestampMs = DateTime.now().UnixTimestampMillis
			}
		elseif s1 == type2.SnoozeActionEnum.Unmute and t2.snoozedNotificationTypes[v] then
			t2.snoozedNotificationTypes[v] = nil
		end
	end

	t2:_updateAppStorage()

	local v20 = t3.context or ""

	for _, v in ipairs(v17) do
		local t4 = {
			action_type = s1,
			duration_minutes = t3.durationMinutes,
			notification_type = v
		}

		t2._eventStream.sendEventDeferred(v20, "notificationSnoozedEvent", t4)
		NotificationSnoozedSignal:fire({
			actionType = s1,
			context = t3.context,
			durationMinutes = t3.durationMinutes,
			notificationType = v
		})
	end

	if t3.modalMessage and t3.modalMessage ~= "" then
		t2:_showNotificationsModal(t3.modalMessage)
	end
end
function t1._isExpiredSnooze(t5: {[any]: any}) -- line: 90
	if t5.durationMinutes ~= -1 and (DateTime.now().UnixTimestampMillis - t5.snoozedTimestampMs) / 1000 >= t5.durationMinutes * 60 then
		return true
	end

	return false
end
function t1._showNotificationsModal(_: {[any]: any}, s2: string) -- line: 104
	-- upvalues: NotificationModalsManager (copy), Images (copy)
	NotificationModalsManager.SetUIBloxToast({
		iconImage = Images["icons/common/notificationOn"],
		toastTitle = s2
	})
end
function t1._updateAppStorage(p1) -- line: 121
	-- upvalues: LocalStorageKey (copy), HttpService (copy)
	p1._appStorageService:SetItem(LocalStorageKey.SnoozedNotificationTypesLocalStorageKey, HttpService:JSONEncode(p1.snoozedNotificationTypes))
	p1._appStorageService:Flush()
end
function t1.unmuteNotification(t7: {[any]: any}, t8: {[any]: any}) -- line: 138
	-- upvalues: type2 (copy)
	t7:_batchNotificationAction(t8, type2.SnoozeActionEnum.Unmute)
end
function t1.snoozeNotification(t9: {[any]: any}, t10: {[any]: any}) -- line: 156
	-- upvalues: type2 (copy)
	t9:_batchNotificationAction(t10, type2.SnoozeActionEnum.Mute)
end
function t1.isSnoozedNotificationType(t11: {[any]: any}, s3: string) -- line: 173
	-- upvalues: Cryo (copy)
	if t11.snoozedNotificationTypes[s3] then
		if t11._isExpiredSnooze(t11.snoozedNotificationTypes[s3]) then
			t11.snoozedNotificationTypes = Cryo.Dictionary.omit(t11.snoozedNotificationTypes, s3)
			t11:_updateAppStorage()

			return false
		end

		return true
	end

	return false
end
function t1.new(p2) -- line: 191
	-- upvalues: analyticsService (copy), t1 (copy), LocalStorageKey (copy), HttpService (copy)
	local t12 = {
		_appStorageService = p2,
		_eventStream = analyticsService.EventStream,
		snoozedNotificationTypes = {}
	}

	setmetatable(t12, t1)

	local t13 = {}
	local t14 = {}
	local v38 = false
	local ok, result = pcall(function() -- line: 204
		-- upvalues: t12 (copy), LocalStorageKey (copy)
		return t12._appStorageService:GetItem(LocalStorageKey.SnoozedNotificationTypesLocalStorageKey)
	end)

	if ok and result ~= "" then
		local ok2, result2 = pcall(function() -- line: 209
			-- upvalues: HttpService (copy), result (copy)
			return HttpService:JSONDecode(result)
		end)

		if ok2 then
			t13 = result2
		end
	end

	for k, v in pairs(t13) do
		if t12._isExpiredSnooze(v) then
			v38 = true
		else
			t14[k] = v
		end
	end

	t12.snoozedNotificationTypes = t14

	if v38 then
		t12:_updateAppStorage()
	end

	return t12
end

t1.default = t1.new(AppStorageService)

return t1
