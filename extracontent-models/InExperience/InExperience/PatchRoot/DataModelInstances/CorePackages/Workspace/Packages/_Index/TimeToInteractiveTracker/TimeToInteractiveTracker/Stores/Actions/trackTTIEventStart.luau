local Parent = script:FindFirstAncestor("TimeToInteractiveTracker").Parent
local FFlagAXTTIEnableColdWarmDetection = require(Parent.SharedFlags).FFlagAXTTIEnableColdWarmDetection

require(script.Parent.Parent.types)

local now = require(script.Parent.Parent.Parent.Utils.now)

return function(p1) -- line: 16
	-- upvalues: now (copy), FFlagAXTTIEnableColdWarmDetection (copy)
	local t1 = {}

	return function(s1: string, b1: boolean?) -- line: 22
		-- upvalues: p1 (copy), now (copy), FFlagAXTTIEnableColdWarmDetection (copy), t1 (copy)
		p1(function(p2) -- line: 23
			-- upvalues: s1 (copy), now (copy), FFlagAXTTIEnableColdWarmDetection (copy), b1 (copy), t1 (copy)
			local v9 = p2[s1]
			local v10 = now()
			local v11 = table.clone(p2)

			v11[s1] = {
				endTime = nil,
				deltaMs = nil,
				sent = nil,
				startTime = v10,
				metadata = if v9 == nil then {} else table.clone(v9.metadata)
			}

			if FFlagAXTTIEnableColdWarmDetection and b1 then
				v11[s1].metadata.coldStart = not t1[s1]
				t1[s1] = true
			end

			return v11
		end)
	end
end
