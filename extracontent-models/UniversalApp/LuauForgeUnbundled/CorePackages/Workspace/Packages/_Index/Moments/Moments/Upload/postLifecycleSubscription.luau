local NotificationService = game:GetService("NotificationService")

local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/MomentsCommon")
local RealtimeDelivery = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/RealtimeDelivery")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SharedFlags")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Signals")
local MomentsGetMomentsUserStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/DataHydration/MomentsGetMomentsUserStore")
local getLocalUserId = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Utils/getLocalUserId")

local defineFastFlag = game:DefineFastFlag("MomentsPostReviewTelemetry", false)

local signal, v5 = Signals.createSignal({})

local function advanceWakeVersion(p2)
	local clone = table.clone(signal(false))
	clone[p2] = (clone[p2] or 0) + 1
	v5(clone)
end

local set = {}

local v6 = nil
local onUnhideConnection = nil

local function onPostLifecycleEvent(data)
	if
		type(data) ~= "table"
		or data.type ~= "PostStatusChanged"
		or data.status ~= "Published" and data.status ~= "Rejected"
		or type(data.postAssetId) ~= "string"
		or data.postAssetId == ""
	then
		return
	end

	local v7 = getLocalUserId()

	if v7 == nil then
		return
	end

	if defineFastFlag and data.isNewPost == true then
		local v8 = data.postAssetId .. ":" .. data.status

		if not set[v8] then
			set[v8] = true
			MomentsCommon.Analytics.reportMomentsCreationStep(
				"post_review",
				data.status == "Published" and "success" or "failed"
			)
		end
	end

	if SharedFlags.FFlagMomentsOptimisticProfilePending then
		local clone = table.clone(signal(false))
		clone[v7] = (clone[v7] or 0) + 1
		v5(clone)
	end

	if SharedFlags.FFlagMomentsRefreshProfileOnPostStatus then
		MomentsGetMomentsUserStore(false).invalidateUser(v7)
	end
end

local function onAppResumed()
	local v7 = getLocalUserId()

	if v7 ~= nil then
		local clone = table.clone(signal(false))
		clone[v7] = (clone[v7] or 0) + 1
		v5(clone)
	end
end

return {
	subscribe = function(p2, p3)
		if v6 ~= nil then
			return
		end

		v6 = (p2 or RealtimeDelivery.RobloxEventReceiver.new(NotificationService)):observeEvent(
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
		if v6 ~= nil then
			v6:disconnect()
			v6 = nil
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
