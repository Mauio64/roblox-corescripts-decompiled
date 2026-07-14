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
	-- upvalues: FFlagLuaAppPerfTrackerUseLogger (copy), v3 (copy), now (copy), mergeTTIEventMetadata (copy), Util (copy), FFlagTTITrackerMemoryTracking (copy), getMemoryMb (copy), sendTTIStat (copy)
	return function(s1: string, p2) -- line: 25
		-- upvalues: p1 (copy), FFlagLuaAppPerfTrackerUseLogger (copy), v3 (copy), now (copy), mergeTTIEventMetadata (copy), Util (copy), FFlagTTITrackerMemoryTracking (copy), getMemoryMb (copy), sendTTIStat (copy)
		local u14 = nil
		local u15 = nil
		local milestones = nil
		local u17 = false
		local v18 = not p2 or (p2.cleanupAfterSend == nil or p2.cleanupAfterSend)
		local v19 = if not p2 then nil else p2.samplingRateOverride

		p1(function(p3) -- line: 35
			-- upvalues: s1 (copy), FFlagLuaAppPerfTrackerUseLogger (copy), v3 (copy), now (copy), u14 (ref), u17 (ref), u15 (ref), mergeTTIEventMetadata (copy), milestones (ref), v18 (copy), Util (copy)
			local v22 = p3[s1]

			if v22 == nil then
				if FFlagLuaAppPerfTrackerUseLogger then
					v3:warning(`called before trackStart for eventName={ s1 }`)

					return p3
				end

				warn(`TimeToInteractiveTracker.trackEnd called before trackStart for eventName={ s1 }`)

				return p3
			end

			if v22.startTime == nil then
				if FFlagLuaAppPerfTrackerUseLogger then
					v3:warning(`called before trackStart for eventName={ s1 }`)

					return p3
				end

				warn(`TimeToInteractiveTracker.trackEnd called before trackStart for eventName={ s1 }`)

				return p3
			end

			local v23 = now()

			u14 = (v23 - v22.startTime) * 1000
			u17 = v22.sent ~= true

			if u17 then
				local startTime = v22.startTime
				local v25 = u14

				u15 = mergeTTIEventMetadata(v22.metadata, {
					startTime = startTime,
					endTime = v23,
					deltaMs = v25
				})

				if v22.milestones then
					milestones = v22.milestones
				end
			end

			local v26 = table.clone(p3)

			if u17 and v18 then
				v26[s1] = nil

				return v26
			end

			v26[s1] = {
				sent = true,
				startTime = v22.startTime,
				endTime = v23,
				deltaMs = u14,
				metadata = table.clone(v22.metadata),
				milestones = if not v22.milestones then nil else Util.deepCloneMilestones(v22.milestones)
			}

			return v26
		end)

		if u17 and (u14 ~= nil and u15 ~= nil) then
			local v20 = if not FFlagTTITrackerMemoryTracking then nil else getMemoryMb()

			sendTTIStat({
				statName = s1,
				deltaMs = u14,
				metaData = u15,
				samplingRateOverride = v19,
				milestones = milestones,
				totalMemoryMB = if not v20 then nil else v20.totalMemoryMB,
				luaHeapMB = if not v20 then nil else v20.luaHeapMB
			})
		end
	end
end
