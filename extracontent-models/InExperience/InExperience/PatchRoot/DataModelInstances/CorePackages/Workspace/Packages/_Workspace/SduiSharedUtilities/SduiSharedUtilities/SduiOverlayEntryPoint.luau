local SduiSharedUtilities = script:FindFirstAncestor("SduiSharedUtilities")
local parent = SduiSharedUtilities.Parent
local React = require(parent.React)
local SduiFeatureEntryPoint = require(SduiSharedUtilities.SduiFeatureEntryPoint)

local function SduiOverlayEntryPoint(props)
	return React.createElement(SduiFeatureEntryPoint, {
		configKey = props.configKey,
		identifier = props.identifier,
		appPage = props.appPage or "Unknown",
		shouldDisplayLoading = false,
		shouldDisplayError = false
	})
end

return SduiOverlayEntryPoint
