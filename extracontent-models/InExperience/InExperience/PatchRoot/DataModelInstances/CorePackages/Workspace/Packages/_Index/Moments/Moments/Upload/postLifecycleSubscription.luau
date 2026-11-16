local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local NotificationService = game:GetService("NotificationService")

local MomentsCommon = require(parent.MomentsCommon)
local RealtimeDelivery = require(parent.RealtimeDelivery)
local SharedFlags = require(parent.SharedFlags)
local Signals = require(parent.Signals)
local MomentsGetMomentsUserStore = require(parent.DataHydration.MomentsGetMomentsUserStore)
local getLocalUserId = require(Moments.Utils.getLocalUserId)

local defineFastFlag = game:DefineFastFlag("MomentsPostReviewTelemetry", false)

local signal, v = Signals.createSignal({})

local function advanceWakeVersion(localUserId: number) -- 2 equivalent calls inferred from this helper
	local clone = table.clone(signal(false))
	clone[localUserId] = (clone[localUserId] or 0) + 1
	v(clone)
end

local set = {}

local v2 = nil
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

	local localUserId = getLocalUserId()

	if localUserId == nil then
		return
	end

	if defineFastFlag and data.isNewPost == true then
		local v3 = data.postAssetId .. ":" .. data.status

		if not set[v3] then
			set[v3] = true
			MomentsCommon.Analytics.reportMomentsCreationStep(
				"post_review",
				data.status == "Published" and "success" or "failed"
			)
		end
	end

	if SharedFlags.FFlagMomentsOptimisticProfilePending then
		advanceWakeVersion(localUserId) -- inferred equivalent call
	end

	if SharedFlags.FFlagMomentsRefreshProfileOnPostStatus then
		MomentsGetMomentsUserStore(false).invalidateUser(localUserId)
	end
end

local function onAppResumed()
	local localUserId = getLocalUserId()

	if localUserId ~= nil then
		advanceWakeVersion(localUserId) -- inferred equivalent call
	end
end

local PostLifecycleSubscription = {}

function PostLifecycleSubscription.subscribe(p, p2)
	if v2 ~= nil then
		return
	end

	v2 = (p or RealtimeDelivery.RobloxEventReceiver.new(NotificationService)):observeEvent(
		"MomentsPostLifecycleV1",
		onPostLifecycleEvent
	)

	if SharedFlags.FFlagMomentsOptimisticProfilePending then
		local result

		if p2 == nil then
			local success
			success, result = pcall(function()
				return game:GetService("AppLifecycleObserverService")
			end)

			if not success then
				result = nil
			end
		else
			result = p2
		end

		if result ~= nil then
			onUnhideConnection = result.OnUnhide:Connect(onAppResumed)
		end
	end
end

function PostLifecycleSubscription.unsubscribe()
	if v2 ~= nil then
		v2:disconnect()
		v2 = nil
	end

	if onUnhideConnection ~= nil then
		onUnhideConnection:Disconnect()
		onUnhideConnection = nil
	end
end

function PostLifecycleSubscription.getWakeVersion(p, p2: number)
	return signal(p)[p2] or 0
end

return PostLifecycleSubscription
