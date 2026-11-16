local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/React")
local loading = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/Foundation").Loading
local SduiFeatureErrorUi = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/ui/SduiFeatureErrorUi")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/SduiIntegrationTypes")

local fFlagSduiFeatureEntryPointTakesAbsoluteSizeHandler = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SharedFlags").FFlagSduiFeatureEntryPointTakesAbsoluteSizeHandler

local function SduiFeatureEntryPointUi(props, ref)
	local createElement = React.createElement
	local v7 = if props.Size then props.Size else UDim2.new(1, 0, 0, 0)
	local v8 = if props.AutomaticSize then props.AutomaticSize else Enum.AutomaticSize.Y
	local v6 = {
		["Size"] = v7,
		AutomaticSize = v8,
		Position = props.Position,
		LayoutOrder = props.LayoutOrder,
		BorderSizePixel = 0,
		BackgroundTransparency = 1
	}

	local absoluteSize = React.Change.AbsoluteSize
	local v9 = if fFlagSduiFeatureEntryPointTakesAbsoluteSizeHandler then props.onAbsoluteSizeChange else nil
	v6[absoluteSize] = v9

	v6.ref = ref
	local v11

	if props.uiStatus == "Loading" and props.shouldDisplayLoading then
		if props.loadingSlot then
			v11 = props.loadingSlot
		else
			v11 = React.createElement(loading, {
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				testId = "sdui-feature-entry-point-loading"
			})
		end
	elseif props.uiStatus == "Error" and props.shouldDisplayError then
		if props.errorSlot then
			v11 = props.errorSlot
		else
			v11 = React.createElement(SduiFeatureErrorUi, { onRetry = props.onRetry })
		end
	elseif props.uiStatus == "Resolved" then
		v11 = props.contentSlot
	end

	return createElement("Frame", v6, { Content = v11 })
end

return React.forwardRef(SduiFeatureEntryPointUi)
