local StreamNotifications = script:FindFirstAncestor("StreamNotifications")
local StreamNotificationsParent = StreamNotifications.Parent
local constants = require(StreamNotifications.constants)
local React = require(StreamNotificationsParent.React)
local useLocalization = require(StreamNotificationsParent.Localization).Hooks.useLocalization
local useStyle = require(StreamNotificationsParent.UIBlox).Core.Style.useStyle

return function() -- line: 11
	-- upvalues: useStyle (copy), useLocalization (copy), constants (copy), React (copy)
	local v7 = useStyle()
	local Font = v7.Font
	local Header1Font = Font.Header1.Font
	local BaseSize = Font.BaseSize
	local v11 = useLocalization({
		emptyText = constants.Text.EmptyKey
	})

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.XY,
		Position = UDim2.new(0.5, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0.5, 0.5)
	}, {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, constants.DefaultPadding)
		}),
		React.createElement("TextLabel", {
			LayoutOrder = 2,
			BackgroundTransparency = 1,
			Text = v11 and v11.emptyText,
			Font = Header1Font,
			TextSize = BaseSize,
			TextColor3 = v7.Theme.TextDefault.Color,
			Size = UDim2.new(1, 0, 0, constants.EmptyNotifications.LabelHeight)
		})
	})
end
