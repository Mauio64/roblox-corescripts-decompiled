local SduiSharedUtilities = script:FindFirstAncestor("SduiSharedUtilities")
local parent = SduiSharedUtilities.Parent
local React = require(parent.React)
require(SduiSharedUtilities.SduiLoadTimer)

local function useComponentLifecycleTiming(p, flag: boolean)
	React.useEffect(function()
		if p then
			p.logComponentMounted()
		end
	end, { p })

	React.useEffect(function()
		if p and flag then
			p.logComponentReady()
		end
	end, { p, flag })
end

return useComponentLifecycleTiming
