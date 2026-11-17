local TimeToInteractiveTracker = script:FindFirstAncestor("TimeToInteractiveTracker")

require(TimeToInteractiveTracker.Stores.types)

local now = require(TimeToInteractiveTracker.Utils.now)
local sendTTIStat = require(TimeToInteractiveTracker.Utils.sendTTIStat)
local buildTTIStatArgs = require(TimeToInteractiveTracker.Utils.buildTTIStatArgs)
local frameSignal = require(TimeToInteractiveTracker.Utils.frameSignal)
local getAppLifecycleObserverService = require(TimeToInteractiveTracker.Utils.getAppLifecycleObserverService)
local logTTIDiscard = require(TimeToInteractiveTracker.Utils.logTTIDiscard)
local FFlagTTITrackerDropEventsOnAppHide = require(TimeToInteractiveTracker.Utils.FFlagTTITrackerDropEventsOnAppHide)

local FIntTTIFirstFrameMaxWaitMs = require(TimeToInteractiveTracker.Utils.FIntTTIFirstFrameMaxWaitMs)
local v = FIntTTIFirstFrameMaxWaitMs / 1000

local function sendTTIStatAtFirstFrame(p, callback)
	local v2 = now()
	local onHideConnection = nil
	local connection = frameSignal.once(function()
		local endTime = now()

		if onHideConnection then
			onHideConnection:Disconnect()
		end

		if v < endTime - v2 then
			logTTIDiscard(p.statName, "lateFrame")
			return
		end

		local ttiStatArgs = buildTTIStatArgs(p, endTime)

		if callback then
			callback(function(p2)
				local v3 = p2[p.statName]

				if v3 == nil or v3.startTime ~= p.startTime or not v3.sent then
					return p2
				end

				local clone = table.clone(v3)
				clone.endTime = endTime
				clone.deltaMs = ttiStatArgs.deltaMs
				local clone2 = table.clone(p2)
				clone2[p.statName] = clone
				return clone2
			end)
		end

		sendTTIStat(ttiStatArgs)
	end)

	local v3 = FFlagTTITrackerDropEventsOnAppHide and getAppLifecycleObserverService()

	if v3 then
		onHideConnection = v3.OnHide:Once(function()
			connection:Disconnect()
			logTTIDiscard(p.statName, "backgrounded")
		end)
	end
end

return sendTTIStatAtFirstFrame
