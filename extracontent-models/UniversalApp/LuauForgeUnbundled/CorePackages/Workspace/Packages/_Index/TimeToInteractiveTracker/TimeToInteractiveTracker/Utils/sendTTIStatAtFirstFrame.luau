require("@game/CorePackages/Workspace/Packages/_Index/TimeToInteractiveTracker/TimeToInteractiveTracker/Stores/types")

local now = require("@game/CorePackages/Workspace/Packages/_Index/TimeToInteractiveTracker/TimeToInteractiveTracker/Utils/now")
local sendTTIStat = require("@game/CorePackages/Workspace/Packages/_Index/TimeToInteractiveTracker/TimeToInteractiveTracker/Utils/sendTTIStat")
local buildTTIStatArgs = require("@game/CorePackages/Workspace/Packages/_Index/TimeToInteractiveTracker/TimeToInteractiveTracker/Utils/buildTTIStatArgs")
local frameSignal = require("@game/CorePackages/Workspace/Packages/_Index/TimeToInteractiveTracker/TimeToInteractiveTracker/Utils/frameSignal")
local getAppLifecycleObserverService = require("@game/CorePackages/Workspace/Packages/_Index/TimeToInteractiveTracker/TimeToInteractiveTracker/Utils/getAppLifecycleObserverService")
local logTTIDiscard = require("@game/CorePackages/Workspace/Packages/_Index/TimeToInteractiveTracker/TimeToInteractiveTracker/Utils/logTTIDiscard")
local FFlagTTITrackerDropEventsOnAppHide = require("@game/CorePackages/Workspace/Packages/_Index/TimeToInteractiveTracker/TimeToInteractiveTracker/Utils/FFlagTTITrackerDropEventsOnAppHide")

local v5 = require("@game/CorePackages/Workspace/Packages/_Index/TimeToInteractiveTracker/TimeToInteractiveTracker/Utils/FIntTTIFirstFrameMaxWaitMs") / 1000

local function sendTTIStatAtFirstFrame(p2, callback)
	local v6 = now()
	local onHideConnection = nil
	local connection = frameSignal.once(function()
		local v7 = now()

		if onHideConnection then
			onHideConnection:Disconnect()
		end

		if v5 < v7 - v6 then
			logTTIDiscard(p2.statName, "lateFrame")
			return
		end

		local v9 = buildTTIStatArgs(p2, v7)

		if callback then
			callback(function(p3)
				local v10 = p3[p2.statName]

				if v10 == nil or v10.startTime ~= p2.startTime or not v10.sent then
					return p3
				end

				local clone = table.clone(v10)
				clone.endTime = v7
				clone.deltaMs = v9.deltaMs
				local clone2 = table.clone(p3)
				clone2[p2.statName] = clone
				return clone2
			end)
		end

		sendTTIStat(v9)
	end)

	local v7 = FFlagTTITrackerDropEventsOnAppHide and getAppLifecycleObserverService()

	if v7 then
		onHideConnection = v7.OnHide:Once(function()
			connection:Disconnect()
			logTTIDiscard(p2.statName, "backgrounded")
		end)
	end
end

return sendTTIStatAtFirstFrame
