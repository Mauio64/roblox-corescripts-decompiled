local parent = script:FindFirstAncestor("ExpChat").Parent

local SharedFlags = require(parent.SharedFlags)
local FFlagAEGIS2UseGuacToShowEnabledMessage = SharedFlags.FFlagAEGIS2UseGuacToShowEnabledMessage
local UniversalAppPolicy

if FFlagAEGIS2UseGuacToShowEnabledMessage then
	UniversalAppPolicy = require(parent.UniversalAppPolicy)
else
	UniversalAppPolicy = nil
end

return function()
	if FFlagAEGIS2UseGuacToShowEnabledMessage then
		return UniversalAppPolicy.getAppFeaturePolicies().getInCommsRegionBubble()
	end

	return false
end
