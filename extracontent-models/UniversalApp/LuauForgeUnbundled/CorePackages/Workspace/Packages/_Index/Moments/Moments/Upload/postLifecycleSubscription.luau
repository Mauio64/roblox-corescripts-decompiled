local NotificationService = game:GetService("NotificationService")

local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/MomentsCommon")
local RealtimeDelivery = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/RealtimeDelivery")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SharedFlags")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Signals")
local MomentsGetMomentsUserStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/DataHydration/MomentsGetMomentsUserStore")
local getLocalUserId = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Utils/getLocalUserId")

local defineFastFlag = game:DefineFastFlag("MomentsPostReviewTelemetry", false)

local v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Loggers").Logger:new("Moments.Upload")

local signal, v6 = Signals.createSignal({})

local function advanceWakeVersion(p2)
	local clone = table.clone(signal(false))
	clone[p2] = (clone[p2] or 0) + 1
	v6(clone)
end

local set = {}

local v7 = nil
local onUnhideConnection = nil

local function onPostLifecycleEvent(data)
	if SharedFlags.FFlagMomentsPostFeedback and type(data) == "table" then
		v5:debug(
			"event=post_lifecycle_event type={} status={} isNewPost={} postAssetId={}",
			tostring(data.type),
			tostring(data.status),
			tostring(data.isNewPost),
			(tostring(data.postAssetId))
		)
	end

	if
		type(data) ~= "table"
		or data.type ~= "PostStatusChanged"
		or data.status ~= "Published" and data.status ~= "Rejected"
		or type(data.postAssetId) ~= "string"
		or data.postAssetId == ""
	then
		return
	end

	local v8 = getLocalUserId()

	if v8 == nil then
		return
	end

	if defineFastFlag and data.isNewPost == true then
		local v9 = data.postAssetId .. ":" .. data.status

		if not set[v9] then
			set[v9] = true
			MomentsCommon.Analytics.reportMomentsCreationStep(
				"post_review",
				data.status == "Published" and "success" or "failed"
			)
		end
	end

	if SharedFlags.FFlagMomentsOptimisticProfilePending then
		local clone = table.clone(signal(false))
		clone[v8] = (clone[v8] or 0) + 1
		v6(clone)
	end

	if SharedFlags.FFlagMomentsRefreshProfileOnPostStatus then
		MomentsGetMomentsUserStore(false).invalidateUser(v8)
	end
end

local function onAppResumed()
	local v8 = getLocalUserId()

	if v8 ~= nil then
		local clone = table.clone(signal(false))
		clone[v8] = (clone[v8] or 0) + 1
		v6(clone)
	end
end

return {
	subscribe = function(p2, p3)
		if v7 ~= nil then
			return
		end

		v7 = (p2 or RealtimeDelivery.RobloxEventReceiver.new(NotificationService)):observeEvent(
			"MomentsPostLifecycleV1",
			onPostLifecycleEvent
		)

		if SharedFlags.FFlagMomentsOptimisticProfilePending then
			local result

			if p3 == nil then
				local success
				success, result = pcall(function()
					return game:GetService("AppLifecycleObserverService")
				end)

				if not success then
					result = nil
				end
			else
				result = p3
			end

			if result ~= nil then
				onUnhideConnection = result.OnUnhide:Connect(onAppResumed)
			end
		end
	end,
	unsubscribe = function()
		if v7 ~= nil then
			v7:disconnect()
			v7 = nil
		end

		if onUnhideConnection ~= nil then
			onUnhideConnection:Disconnect()
			onUnhideConnection = nil
		end
	end,
	getWakeVersion = function(p2, p3)
		return signal(p2)[p3] or 0
	end
}
