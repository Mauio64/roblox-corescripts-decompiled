local SduiSharedUtilities = script:FindFirstAncestor("SduiSharedUtilities")
local SduiSharedUtilitiesParent = SduiSharedUtilities.Parent
local React = require(SduiSharedUtilitiesParent.React)
local SduiFeatureEntryPoint = require(SduiSharedUtilities.SduiFeatureEntryPoint)

local function SduiOverlayEntryPoint(t1: {[any]: any}) -- line: 12
	-- upvalues: React (copy), SduiFeatureEntryPoint (copy)
	return React.createElement(SduiFeatureEntryPoint, {
		shouldDisplayLoading = false,
		shouldDisplayError = false,
		configKey = t1.configKey,
		identifier = t1.identifier,
		appPage = t1.appPage or "Unknown"
	})
end

return SduiOverlayEntryPoint
