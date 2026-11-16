local SduiSharedUtilities = script:FindFirstAncestor("SduiSharedUtilities")
local parent = SduiSharedUtilities.Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Loading = Foundation.Loading
local SduiFeatureErrorUi = require(SduiSharedUtilities.ui.SduiFeatureErrorUi)
require(SduiSharedUtilities.SduiIntegrationTypes)

local SharedFlags = require(parent.SharedFlags)

local FFlagSduiFeatureEntryPointTakesAbsoluteSizeHandler = SharedFlags.FFlagSduiFeatureEntryPointTakesAbsoluteSizeHandler

local function SduiFeatureEntryPointUi(props, ref)
	local createElement = React.createElement
	local size

	if props.Size then
		size = props.Size
	else
		size = UDim2.new(1, 0, 0, 0)
	end

	local automaticSize

	if props.AutomaticSize then
		automaticSize = props.AutomaticSize
	else
		automaticSize = Enum.AutomaticSize.Y
	end

	local v = {
		["Size"] = size,
		AutomaticSize = automaticSize,
		Position = props.Position,
		LayoutOrder = props.LayoutOrder,
		BorderSizePixel = 0,
		BackgroundTransparency = 1
	}

	local absoluteSize = React.Change.AbsoluteSize
	local v2

	if FFlagSduiFeatureEntryPointTakesAbsoluteSizeHandler then
		v2 = props.onAbsoluteSizeChange
	end

	v[absoluteSize] = v2

	v.ref = ref
	local content

	if props.uiStatus == "Loading" and props.shouldDisplayLoading then
		if props.loadingSlot then
			content = props.loadingSlot
		else
			content = React.createElement(Loading, {
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				testId = "sdui-feature-entry-point-loading"
			})
		end
	elseif props.uiStatus == "Error" and props.shouldDisplayError then
		if props.errorSlot then
			content = props.errorSlot
		else
			content = React.createElement(SduiFeatureErrorUi, { onRetry = props.onRetry })
		end
	elseif props.uiStatus == "Resolved" then
		content = props.contentSlot
	end

	return createElement("Frame", v, { Content = content })
end

return React.forwardRef(SduiFeatureEntryPointUi)
