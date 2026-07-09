local TimeToInteractiveTracker = script:FindFirstAncestor("TimeToInteractiveTracker")
local TimeToInteractiveTrackerParent = TimeToInteractiveTracker.Parent
local v3 = require(TimeToInteractiveTracker.Logger):new(script.Name)
local FFlagLuaAppPerfTrackerUseLogger = require(TimeToInteractiveTrackerParent.SharedFlags).FFlagLuaAppPerfTrackerUseLogger

require(script.Parent.Parent.types)

local mergeTTIEventMetadata = require(script.Parent.Parent.Parent.Utils.mergeTTIEventMetadata)

return function(p1) -- line: 17
	-- upvalues: FFlagLuaAppPerfTrackerUseLogger (copy), v3 (copy), mergeTTIEventMetadata (copy)
	return function(s1: string, p2) -- line: 18
		-- upvalues: p1 (copy), FFlagLuaAppPerfTrackerUseLogger (copy), v3 (copy), mergeTTIEventMetadata (copy)
		p1(function(p3) -- line: 19
			-- upvalues: s1 (copy), FFlagLuaAppPerfTrackerUseLogger (copy), v3 (copy), mergeTTIEventMetadata (copy), p2 (copy)
			local v10 = p3[s1]

			if v10 == nil then
				if FFlagLuaAppPerfTrackerUseLogger then
					v3:warning(`called before trackStart for eventName={ s1 }`)

					return p3
				end

				warn(`TimeToInteractiveTracker.updateMetadata called before trackStart for eventName={ s1 }`)

				return p3
			end

			local v11 = table.clone(p3)
			local v12 = table.clone(v10)

			v12.metadata = mergeTTIEventMetadata(v10.metadata, p2)
			v11[s1] = v12

			return v11
		end)
	end
end
