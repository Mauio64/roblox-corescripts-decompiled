local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/React")
local SduiFeatureEntryPoint = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/SduiFeatureEntryPoint")

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
