local TimeToInteractiveTracker = script:FindFirstAncestor("TimeToInteractiveTracker")
local TimeToInteractiveTrackerParent = TimeToInteractiveTracker.Parent
local v3 = require(TimeToInteractiveTracker.Logger):new(script.Name)
local FFlagLuaAppPerfTrackerUseLogger = require(TimeToInteractiveTrackerParent.SharedFlags).FFlagLuaAppPerfTrackerUseLogger
local FFlagDebugTimeToInteractiveTracker = require(TimeToInteractiveTracker.Utils.FFlagDebugTimeToInteractiveTracker)
local FFlagTimeToInteractiveTrackerWarningsRequireDebug = require(TimeToInteractiveTracker.Utils.FFlagTimeToInteractiveTrackerWarningsRequireDebug)

require(script.Parent.Parent.types)

local now = require(TimeToInteractiveTracker.Utils.now)
local Util = require(TimeToInteractiveTracker.Utils.Util)

return function(p1, p2) -- line: 23
	-- upvalues: now (copy), FFlagLuaAppPerfTrackerUseLogger (copy), FFlagTimeToInteractiveTrackerWarningsRequireDebug (copy), FFlagDebugTimeToInteractiveTracker (copy), v3 (copy), Util (copy)
	return function(s1: string, p3, s2: string) -- line: 24
		-- upvalues: now (copy), p1 (copy), FFlagLuaAppPerfTrackerUseLogger (copy), FFlagTimeToInteractiveTrackerWarningsRequireDebug (copy), FFlagDebugTimeToInteractiveTracker (copy), v3 (copy), p2 (copy), Util (copy)
		local v14 = now()
		local v15 = p1(false)[s1]

		if not v15 or not v15.startTime then
			if FFlagLuaAppPerfTrackerUseLogger then
				if not FFlagTimeToInteractiveTrackerWarningsRequireDebug then
					v3:warning(`called before trackStart for eventName={ s1 }`)

					return
				end

				if FFlagDebugTimeToInteractiveTracker then
					v3:warning(`called before trackStart for eventName={ s1 }`)

					return
				end
			elseif FFlagTimeToInteractiveTrackerWarningsRequireDebug then
				if FFlagDebugTimeToInteractiveTracker then
					warn(`TimeToInteractiveTracker.trackRequest called before trackStart for eventName={ s1 }`)

					return
				end
			else
				warn(`TimeToInteractiveTracker.trackRequest called before trackStart for eventName={ s1 }`)
			end

			return
		end

		local v16 = (v14 - v15.startTime) * 1000
		local t1 = {
			name = s2,
			timestamp = v14,
			deltaMs = v16
		}

		p2(function(p4) -- line: 57
			-- upvalues: s1 (copy), Util (copy), p3 (copy), FFlagLuaAppPerfTrackerUseLogger (copy), FFlagTimeToInteractiveTrackerWarningsRequireDebug (copy), FFlagDebugTimeToInteractiveTracker (copy), v3 (copy), t1 (copy)
			local v19 = p4[s1]

			if not v19 or not v19.milestones then
				return p4
			end

			local v20 = Util.findLastMilestoneIndex(v19.milestones, p3)

			if not v20 then
				if FFlagLuaAppPerfTrackerUseLogger then
					if not FFlagTimeToInteractiveTrackerWarningsRequireDebug then
						v3:warning(`no milestone "{ p3 }" found for eventName={ s1 }`)

						return p4
					end

					if FFlagDebugTimeToInteractiveTracker then
						v3:warning(`no milestone "{ p3 }" found for eventName={ s1 }`)

						return p4
					end
				elseif FFlagTimeToInteractiveTrackerWarningsRequireDebug then
					if FFlagDebugTimeToInteractiveTracker then
						warn(`TimeToInteractiveTracker.trackRequest: no milestone "{ p3 }" found for eventName={ s1 }`)

						return p4
					end
				else
					warn(`TimeToInteractiveTracker.trackRequest: no milestone "{ p3 }" found for eventName={ s1 }`)
				end

				return p4
			end

			local v21 = table.clone(p4)
			local v22 = table.clone(v19)
			local v23 = table.clone(v19.milestones)
			local v24 = table.clone(v23[v20])
			local v25 = if not v24.requests then {} else table.clone(v24.requests)

			table.insert(v25, t1)
			v24.requests = v25
			v23[v20] = v24
			v22.milestones = v23
			v21[s1] = v22

			return v21
		end)
	end
end
