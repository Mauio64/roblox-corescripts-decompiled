local TimeToInteractiveTracker = script:FindFirstAncestor("TimeToInteractiveTracker")
local parent = TimeToInteractiveTracker.Parent
local Logger = require(TimeToInteractiveTracker.Logger)
local v = Logger:new(script.Name)

require(script.Parent.Parent.types)

local now = require(script.Parent.Parent.Parent.Utils.now)
local sendTTIStat = require(TimeToInteractiveTracker.Utils.sendTTIStat)
local sendTTIStatAtFirstFrame = require(TimeToInteractiveTracker.Utils.sendTTIStatAtFirstFrame)
local buildTTIStatArgs = require(TimeToInteractiveTracker.Utils.buildTTIStatArgs)
local Util = require(TimeToInteractiveTracker.Utils.Util)
local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppNavTTIMeasurementV2 = SharedFlags.FFlagLuaAppNavTTIMeasurementV2

return function(callback, p)
	local function endEvent(statName: string, p2, flag: boolean) -- 2 equivalent calls inferred from this helper
		local v2 = nil
		local v3 = nil
		local v4 = false
		local v5 = not p2 or p2.cleanupAfterSend == nil or p2.cleanupAfterSend
		local samplingRateOverride

		if p2 then
			samplingRateOverride = p2.samplingRateOverride
		else
			samplingRateOverride = nil
		end

		callback(function(p3)
			local v6 = p3[statName]

			if v6 == nil then
				if FFlagLuaAppNavTTIMeasurementV2 and p and p[statName] then
					return p3
				end

				v:warning(`called before trackStart for eventName={statName}`)
				return p3
			else
				if v6.startTime == nil then
					v:warning(`called before trackStart for eventName={statName}`)
					return p3
				end

				local endTime = now()

				local deltaMs = (endTime - v6.startTime) * 1000
				v4 = v6.sent ~= true

				if v4 then
					v2 = endTime
					v3 = {
						statName = statName,
						startTime = v6.startTime,
						metaData = v6.metadata,
						milestones = v6.milestones,
						samplingRateOverride = samplingRateOverride
					}
				end

				local clone = table.clone(p3)

				if v4 and v5 then
					clone[statName] = nil
					return clone
				end

				local v7 = {
					startTime = v6.startTime,
					endTime = endTime,
					deltaMs = deltaMs,
					sent = true,
					metadata = table.clone(v6.metadata),
					milestones = 0
				}
				local milestones

				if v6.milestones then
					milestones = Util.deepCloneMilestones(v6.milestones)
				end

				v7.milestones = milestones
				clone[statName] = v7

				return clone
			end
		end)

		if v3 == nil or v2 == nil then
			return
		end

		if not flag then
			sendTTIStat(buildTTIStatArgs(v3, v2))
			return
		end

		local v6 = v3
		local v7

		if not v5 then
			v7 = callback
		end

		sendTTIStatAtFirstFrame(v6, v7)
	end

	local function trackEnd(statName: string, p2)
		endEvent(statName, p2, false) -- inferred equivalent call
	end

	local function trackEndAtNextFrame(statName: string, p2)
		endEvent(statName, p2, true) -- inferred equivalent call
	end

	return trackEnd, trackEndAtNextFrame
end
