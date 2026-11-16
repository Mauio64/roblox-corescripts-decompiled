local TimeToInteractiveTracker = script:FindFirstAncestor("TimeToInteractiveTracker")
local Logger = require(TimeToInteractiveTracker.Logger)
local v = Logger:new(script.Name)

require(script.Parent.Parent.types)

local now = require(script.Parent.Parent.Parent.Utils.now)
local sendTTIStat = require(TimeToInteractiveTracker.Utils.sendTTIStat)
local mergeTTIEventMetadata = require(TimeToInteractiveTracker.Utils.mergeTTIEventMetadata)
local Util = require(TimeToInteractiveTracker.Utils.Util)
local getMemoryMb = require(TimeToInteractiveTracker.Utils.getMemoryMb)
local FFlagTTITrackerMemoryTracking = require(TimeToInteractiveTracker.Utils.FFlagTTITrackerMemoryTracking)

return function(callback)
	return function(statName: string, p)
		local deltaMs = nil
		local metaData = nil
		local milestones = nil
		local v2 = false
		local v3 = not p or p.cleanupAfterSend == nil or p.cleanupAfterSend
		local samplingRateOverride

		if p then
			samplingRateOverride = p.samplingRateOverride
		end

		callback(function(p2)
			local v4 = p2[statName]

			if v4 == nil then
				v:warning(`called before trackStart for eventName={statName}`)
				return p2
			end

			if v4.startTime == nil then
				v:warning(`called before trackStart for eventName={statName}`)
				return p2
			end

			local endTime = now()

			deltaMs = (endTime - v4.startTime) * 1000
			v2 = v4.sent ~= true

			if v2 then
				local startTime = v4.startTime
				local deltaMs2 = deltaMs
				metaData = mergeTTIEventMetadata(v4.metadata, {
					startTime = startTime,
					endTime = endTime,
					deltaMs = deltaMs2
				})

				if v4.milestones then
					milestones = v4.milestones
				end
			end

			local clone = table.clone(p2)

			if v2 and v3 then
				clone[statName] = nil
				return clone
			end

			local v5 = {
				startTime = v4.startTime,
				endTime = endTime,
				deltaMs = deltaMs,
				sent = true,
				metadata = table.clone(v4.metadata),
				milestones = 0
			}
			local milestones2

			if v4.milestones then
				milestones2 = Util.deepCloneMilestones(v4.milestones)
			end

			v5.milestones = milestones2
			clone[statName] = v5

			return clone
		end)

		if v2 and deltaMs ~= nil and metaData ~= nil then
			local v4

			if FFlagTTITrackerMemoryTracking then
				v4 = getMemoryMb()
			end

			local v5 = {
				statName = statName,
				deltaMs = deltaMs,
				metaData = metaData,
				samplingRateOverride = samplingRateOverride,
				milestones = milestones,
				totalMemoryMB = 0,
				luaHeapMB = 0
			}
			local totalMemoryMB

			if v4 then
				totalMemoryMB = v4.totalMemoryMB
			end

			v5.totalMemoryMB = totalMemoryMB
			local luaHeapMB

			if v4 then
				luaHeapMB = v4.luaHeapMB
			end

			v5.luaHeapMB = luaHeapMB
			sendTTIStat(v5)
		end
	end
end
