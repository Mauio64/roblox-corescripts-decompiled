local TimeToInteractiveTracker = script:FindFirstAncestor("TimeToInteractiveTracker")
local TimeToInteractiveTrackerParent = TimeToInteractiveTracker.Parent
local v3 = require(TimeToInteractiveTracker.Logger):new(script.Name)
local FFlagLuaAppPerfTrackerUseLogger = require(TimeToInteractiveTrackerParent.SharedFlags).FFlagLuaAppPerfTrackerUseLogger

require(script.Parent.Parent.types)

local now = require(script.Parent.Parent.Parent.Utils.now)
local sendTTIStat = require(TimeToInteractiveTracker.Utils.sendTTIStat)
local mergeTTIEventMetadata = require(TimeToInteractiveTracker.Utils.mergeTTIEventMetadata)
local Util = require(TimeToInteractiveTracker.Utils.Util)
local getMemoryMb = require(TimeToInteractiveTracker.Utils.getMemoryMb)
local FFlagTTITrackerMemoryTracking = require(TimeToInteractiveTracker.Utils.FFlagTTITrackerMemoryTracking)

return function(p1) -- line: 24
	-- upvalues: FFlagLuaAppPerfTrackerUseLogger (copy), v3 (copy), now (copy), FFlagTTITrackerMemoryTracking (copy), mergeTTIEventMetadata (copy), Util (copy), getMemoryMb (copy), sendTTIStat (copy)
	return function(s1: string, p2) -- line: 25
		-- upvalues: p1 (copy), FFlagLuaAppPerfTrackerUseLogger (copy), v3 (copy), now (copy), FFlagTTITrackerMemoryTracking (copy), mergeTTIEventMetadata (copy), Util (copy), getMemoryMb (copy), sendTTIStat (copy)
		local u14 = nil
		local u15 = nil
		local milestones = nil
		local u17 = false
		local u18 = false
		local v19 = not p2 or (p2.cleanupAfterSend == nil or p2.cleanupAfterSend)
		local v20 = if not p2 then nil else p2.samplingRateOverride

		p1(function(p3) -- line: 36
			-- upvalues: s1 (copy), FFlagLuaAppPerfTrackerUseLogger (copy), v3 (copy), now (copy), u14 (ref), u17 (ref), u18 (ref), FFlagTTITrackerMemoryTracking (copy), u15 (ref), mergeTTIEventMetadata (copy), milestones (ref), v19 (copy), Util (copy)
			local v23 = p3[s1]

			if v23 == nil then
				if FFlagLuaAppPerfTrackerUseLogger then
					v3:warning(`called before trackStart for eventName={ s1 }`)

					return p3
				end

				warn(`TimeToInteractiveTracker.trackEnd called before trackStart for eventName={ s1 }`)

				return p3
			end

			if v23.startTime == nil then
				if FFlagLuaAppPerfTrackerUseLogger then
					v3:warning(`called before trackStart for eventName={ s1 }`)

					return p3
				end

				warn(`TimeToInteractiveTracker.trackEnd called before trackStart for eventName={ s1 }`)

				return p3
			end

			local v24 = now()

			u14 = (v24 - v23.startTime) * 1000
			u17 = v23.sent ~= true
			u18 = FFlagTTITrackerMemoryTracking and v23.trackMemory == true

			if u17 then
				local startTime = v23.startTime
				local v26 = u14

				u15 = mergeTTIEventMetadata(v23.metadata, {
					startTime = startTime,
					endTime = v24,
					deltaMs = v26
				})

				if v23.milestones then
					milestones = v23.milestones
				end
			end

			local v27 = table.clone(p3)

			if u17 and v19 then
				v27[s1] = nil

				return v27
			end

			v27[s1] = {
				sent = true,
				startTime = v23.startTime,
				endTime = v24,
				deltaMs = u14,
				trackMemory = if not FFlagTTITrackerMemoryTracking then nil else v23.trackMemory,
				metadata = table.clone(v23.metadata),
				milestones = if not v23.milestones then nil else Util.deepCloneMilestones(v23.milestones)
			}

			return v27
		end)

		if u17 and (u14 ~= nil and u15 ~= nil) then
			local v21 = if not u18 then nil else getMemoryMb()

			sendTTIStat({
				statName = s1,
				deltaMs = u14,
				metaData = u15,
				samplingRateOverride = v20,
				milestones = milestones,
				totalMemoryMB = if not v21 then nil else v21.totalMemoryMB,
				luaHeapMB = if not v21 then nil else v21.luaHeapMB
			})
		end
	end
end
