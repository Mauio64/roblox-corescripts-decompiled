local SduiSharedUtilities = script:FindFirstAncestor("SduiSharedUtilities")
local SduiSharedUtilitiesParent = SduiSharedUtilities.Parent
local React = require(SduiSharedUtilitiesParent.React)

require(SduiSharedUtilities.SduiLoadTimer)

local function useComponentLifecycleTiming(p1, b1: boolean) -- line: 8
	-- upvalues: React (copy)
	React.useEffect(function() -- line: 10
		-- upvalues: p1 (copy)
		if p1 then
			p1.logComponentMounted()
		end
	end, { p1 })
	React.useEffect(function() -- line: 17
		-- upvalues: p1 (copy), b1 (copy)
		if p1 and b1 then
			p1.logComponentReady()
		end
	end, {
		p1,
		b1
	})
end

return useComponentLifecycleTiming
