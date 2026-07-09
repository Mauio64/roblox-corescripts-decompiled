local Parent = script:FindFirstAncestor("ExpChat").Parent
local FFlagAEGIS2UseGuacToShowEnabledMessage = require(Parent.SharedFlags).FFlagAEGIS2UseGuacToShowEnabledMessage
local UniversalAppPolicy = nil

if FFlagAEGIS2UseGuacToShowEnabledMessage then
	UniversalAppPolicy = require(Parent.UniversalAppPolicy)
end

return function() -- line: 12
	-- upvalues: FFlagAEGIS2UseGuacToShowEnabledMessage (copy), UniversalAppPolicy (ref)
	if not FFlagAEGIS2UseGuacToShowEnabledMessage then
		return false
	end

	return UniversalAppPolicy.getAppFeaturePolicies().getInCommsRegionBubble()
end
