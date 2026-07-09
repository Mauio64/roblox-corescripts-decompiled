local SduiSharedUtilities = script:FindFirstAncestor("SduiSharedUtilities")
local SduiSharedUtilitiesParent = SduiSharedUtilities.Parent
local React = require(SduiSharedUtilitiesParent.React)
local Loading = require(SduiSharedUtilitiesParent.Foundation).Loading
local SduiFeatureErrorUi = require(SduiSharedUtilities.ui.SduiFeatureErrorUi)

require(SduiSharedUtilities.SduiIntegrationTypes)

local FFlagSduiFeatureEntryPointTakesAbsoluteSizeHandler = require(SduiSharedUtilitiesParent.SharedFlags).FFlagSduiFeatureEntryPointTakesAbsoluteSizeHandler

local function SduiFeatureEntryPointUi(t1: {[any]: any}, p1) -- line: 33
	-- upvalues: React (copy), FFlagSduiFeatureEntryPointTakesAbsoluteSizeHandler (copy), Loading (copy), SduiFeatureErrorUi (copy)
	return React.createElement("Frame", {
		Size = if not t1.Size then UDim2.new(1, 0, 0, 0) else t1.Size,
		AutomaticSize = if not t1.AutomaticSize then Enum.AutomaticSize.Y else t1.AutomaticSize,
		Position = t1.Position,
		LayoutOrder = t1.LayoutOrder,
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		[React.Change.AbsoluteSize] = if not FFlagSduiFeatureEntryPointTakesAbsoluteSizeHandler then nil else t1.onAbsoluteSizeChange,
		ref = p1
	}, {
		Content = if t1.uiStatus ~= "Loading" or not t1.shouldDisplayLoading then if t1.uiStatus ~= "Error" or not t1.shouldDisplayError then if t1.uiStatus ~= "Resolved" then nil else t1.contentSlot else if not t1.errorSlot then React.createElement(SduiFeatureErrorUi, {
			onRetry = t1.onRetry
		}) else t1.errorSlot else if not t1.loadingSlot then React.createElement(Loading, {
			testId = "sdui-feature-entry-point-loading",
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5)
		}) else t1.loadingSlot
	})
end

return React.forwardRef(SduiFeatureEntryPointUi)
