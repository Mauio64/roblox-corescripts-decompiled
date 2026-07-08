local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local context = scriptParentParent.context
local dependencies = require(scriptParentParent.dependencies)
local React = dependencies.React
local UIBlox = dependencies.UIBlox
local NotificationContentFrame = require(scriptParent.NotificationContentFrame)
local useStyle = UIBlox.Core.Style.useStyle
local constants = require(scriptParentParent.constants)
local useNotificationCardData = require(context.useNotificationCardData)
local DefaultCardPadding = constants.Padding.DefaultCardPadding
local DefaultContentPadding = constants.DefaultContentPadding
local DefaultCardCornerRadius = constants.DefaultCardCornerRadius

return function(t1: {[any]: any}) -- line: 20
	-- upvalues: useNotificationCardData (copy), constants (copy), DefaultCardPadding (copy), useStyle (copy), React (copy), DefaultCardCornerRadius (copy), DefaultContentPadding (copy), NotificationContentFrame (copy)
	local v15 = useNotificationCardData()
	local cardSize = v15.cardSize
	local v17 = if not v15.cardTransparency then constants.CardTransparency.Default else v15.cardTransparency
	local v18 = if not cardSize or not cardSize.cardPadding then DefaultCardPadding else cardSize.cardPadding
	local v19 = useStyle()

	return React.createElement("Frame", {
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 0),
		BackgroundColor3 = v19.Theme.BackgroundUIDefault.Color,
		BackgroundTransparency = v17,
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = t1.layoutOrder
	}, {
		UICorner = React.createElement("UICorner", {
			CornerRadius = DefaultCardCornerRadius
		}),
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			Padding = UDim.new(0, DefaultContentPadding),
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center
		}),
		UIPadding = React.createElement("UIPadding", {
			PaddingBottom = UDim.new(0, v18),
			PaddingLeft = UDim.new(0, v18),
			PaddingRight = UDim.new(0, v18),
			PaddingTop = UDim.new(0, v18)
		}),
		NotificationContentFrame = React.createElement(NotificationContentFrame)
	})
end
