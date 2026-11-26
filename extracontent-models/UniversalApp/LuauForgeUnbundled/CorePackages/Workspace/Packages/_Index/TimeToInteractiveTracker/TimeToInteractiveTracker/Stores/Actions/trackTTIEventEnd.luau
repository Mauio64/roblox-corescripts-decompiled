local v5 = require("@game/CorePackages/Workspace/Packages/_Index/TimeToInteractiveTracker/TimeToInteractiveTracker/Logger"):new("trackTTIEventEnd")

require("@game/CorePackages/Workspace/Packages/_Index/TimeToInteractiveTracker/TimeToInteractiveTracker/Stores/types")

local now = require("@game/CorePackages/Workspace/Packages/_Index/TimeToInteractiveTracker/TimeToInteractiveTracker/Utils/now")
local sendTTIStat = require("@game/CorePackages/Workspace/Packages/_Index/TimeToInteractiveTracker/TimeToInteractiveTracker/Utils/sendTTIStat")
local sendTTIStatAtFirstFrame = require("@game/CorePackages/Workspace/Packages/_Index/TimeToInteractiveTracker/TimeToInteractiveTracker/Utils/sendTTIStatAtFirstFrame")
local buildTTIStatArgs = require("@game/CorePackages/Workspace/Packages/_Index/TimeToInteractiveTracker/TimeToInteractiveTracker/Utils/buildTTIStatArgs")
local Util = require("@game/CorePackages/Workspace/Packages/_Index/TimeToInteractiveTracker/TimeToInteractiveTracker/Utils/Util")
local fFlagLuaAppNavTTIMeasurementV2 = require("@game/CorePackages/Workspace/Packages/_Workspace/TimeToInteractiveTracker/SharedFlags").FFlagLuaAppNavTTIMeasurementV2

return function(callback, p2)
	local function endEvent(p3, p4, p5)
		local v6 = nil
		local v7 = nil
		local v8 = false
		local v9 = not p4 or p4.cleanupAfterSend == nil or p4.cleanupAfterSend

		local samplingRateOverride = if p4 then p4.samplingRateOverride else nil

		callback(function(p6)
			local v10 = p6[p3]

			if v10 == nil then
				if fFlagLuaAppNavTTIMeasurementV2 and p2 and p2[p3] then
					return p6
				end

				v5:warning(`called before trackStart for eventName={p3}`)
				return p6
			else
				if v10.startTime == nil then
					v5:warning(`called before trackStart for eventName={p3}`)
					return p6
				end

				local v11 = now()

				local v12 = (v11 - v10.startTime) * 1000
				v8 = v10.sent ~= true

				if v8 then
					v6 = v11
					v7 = {
						statName = p3,
						startTime = v10.startTime,
						metaData = v10.metadata,
						milestones = v10.milestones,
						samplingRateOverride = samplingRateOverride
					}
				end

				local clone = table.clone(p6)

				if v8 and v9 then
					clone[p3] = nil
					return clone
				end

				local v14 = {
					startTime = v10.startTime,
					endTime = v11,
					deltaMs = v12,
					sent = true,
					metadata = table.clone(v10.metadata),
					milestones = 0
				}
				local v15 = if v10.milestones then Util.deepCloneMilestones(v10.milestones) else nil
				v14.milestones = v15
				clone[p3] = v14

				return clone
			end
		end)

		if v7 == nil or v6 == nil then
			return
		end

		if not p5 then
			sendTTIStat(buildTTIStatArgs(v7, v6))
			return
		end

		sendTTIStatAtFirstFrame(v7, if not v9 then callback else nil)
	end

	local function trackEnd(p3, p4)
		local v6 = nil
		local v7 = nil
		local v8 = false
		local v9 = not p4 or p4.cleanupAfterSend == nil or p4.cleanupAfterSend

		local samplingRateOverride = if p4 then p4.samplingRateOverride else nil

		callback(function(p5)
			local v10 = p5[p3]

			if v10 == nil then
				if fFlagLuaAppNavTTIMeasurementV2 and p2 and p2[p3] then
					return p5
				end

				v5:warning(`called before trackStart for eventName={p3}`)
				return p5
			else
				if v10.startTime == nil then
					v5:warning(`called before trackStart for eventName={p3}`)
					return p5
				end

				local v11 = now()

				local v12 = (v11 - v10.startTime) * 1000
				v8 = v10.sent ~= true

				if v8 then
					v6 = v11
					v7 = {
						statName = p3,
						startTime = v10.startTime,
						metaData = v10.metadata,
						milestones = v10.milestones,
						samplingRateOverride = samplingRateOverride
					}
				end

				local clone = table.clone(p5)

				if v8 and v9 then
					clone[p3] = nil
					return clone
				end

				local v14 = {
					startTime = v10.startTime,
					endTime = v11,
					deltaMs = v12,
					sent = true,
					metadata = table.clone(v10.metadata),
					milestones = 0
				}
				local v15 = if v10.milestones then Util.deepCloneMilestones(v10.milestones) else nil
				v14.milestones = v15
				clone[p3] = v14

				return clone
			end
		end)

		if v7 == nil or v6 == nil then
			return
		end

		sendTTIStat(buildTTIStatArgs(v7, v6))
	end

	local function trackEndAtNextFrame(p3, p4)
		local v6 = nil
		local v7 = nil
		local v8 = false
		local v9 = not p4 or p4.cleanupAfterSend == nil or p4.cleanupAfterSend

		local samplingRateOverride = if p4 then p4.samplingRateOverride else nil

		callback(function(p5)
			local v10 = p5[p3]

			if v10 == nil then
				if fFlagLuaAppNavTTIMeasurementV2 and p2 and p2[p3] then
					return p5
				end

				v5:warning(`called before trackStart for eventName={p3}`)
				return p5
			else
				if v10.startTime == nil then
					v5:warning(`called before trackStart for eventName={p3}`)
					return p5
				end

				local v11 = now()

				local v12 = (v11 - v10.startTime) * 1000
				v8 = v10.sent ~= true

				if v8 then
					v6 = v11
					v7 = {
						statName = p3,
						startTime = v10.startTime,
						metaData = v10.metadata,
						milestones = v10.milestones,
						samplingRateOverride = samplingRateOverride
					}
				end

				local clone = table.clone(p5)

				if v8 and v9 then
					clone[p3] = nil
					return clone
				end

				local v14 = {
					startTime = v10.startTime,
					endTime = v11,
					deltaMs = v12,
					sent = true,
					metadata = table.clone(v10.metadata),
					milestones = 0
				}
				local v15 = if v10.milestones then Util.deepCloneMilestones(v10.milestones) else nil
				v14.milestones = v15
				clone[p3] = v14

				return clone
			end
		end)

		if v7 == nil or v6 == nil then
			return
		end

		sendTTIStatAtFirstFrame(v7, if not v9 then callback else nil)
	end

	return trackEnd, trackEndAtNextFrame
end
