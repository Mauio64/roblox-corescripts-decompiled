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

local Loggers = require(parent.Loggers)
local v = Loggers.Logger:new("Moments.Upload")

local signal, v2 = Signals.createSignal({})

local function advanceWakeVersion(localUserId: number) -- 2 equivalent calls inferred from this helper
	local clone = table.clone(signal(false))
	clone[localUserId] = (clone[localUserId] or 0) + 1
	v2(clone)
end

local set = {}

local v3 = nil
local onUnhideConnection = nil

local function onPostLifecycleEvent(data)
	if SharedFlags.FFlagMomentsPostFeedback and type(data) == "table" then
		v:debug(
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

	local localUserId = getLocalUserId()

	if localUserId == nil then
		return
	end

	if defineFastFlag and data.isNewPost == true then
		local v4 = data.postAssetId .. ":" .. data.status

		if not set[v4] then
			set[v4] = true
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
	if v3 ~= nil then
		return
	end

	v3 = (p or RealtimeDelivery.RobloxEventReceiver.new(NotificationService)):observeEvent(
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
	if v3 ~= nil then
		v3:disconnect()
		v3 = nil
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
