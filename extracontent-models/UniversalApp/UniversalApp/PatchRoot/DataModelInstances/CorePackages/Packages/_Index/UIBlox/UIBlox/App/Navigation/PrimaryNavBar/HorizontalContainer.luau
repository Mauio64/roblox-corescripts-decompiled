local ParentParent = script.Parent.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Roact = require(ParentParentParent.Roact)
local Object = require(ParentParentParent.LuauPolyfill).Object
local useStyle = require(ParentParent.Core.Style.useStyle)
local Constants = require(script.Parent.Constants)

require(script.Parent.Types)

return function(p1, t1: {[any]: any}) -- line: 22
	-- upvalues: useStyle (copy), Roact (copy), Constants (copy), Object (copy)
	local v9 = useStyle()

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		LayoutOrder = 1,
		Size = if not p1.size then UDim2.new(1, 0, 1, 0) else p1.size,
		AutomaticSize = p1.automaticSize
	}, {
		RoundedBackgroundWithTopAlignedToContent = if not p1.showRoundedBackground then nil else Roact.createElement("Frame", {
			ZIndex = 1,
			Size = p1.roundedBackgroundSize or UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = p1.roundedBackgroundTransparency or 1,
			BackgroundColor3 = p1.roundedBackgroundColor or v9.Theme.BackgroundUIDefault.Color,
			Position = p1.roundedBackgroundPosition or UDim2.fromOffset(0, 0)
		}, {
			Corner = Roact.createElement("UICorner", {
				CornerRadius = UDim.new(0.5, 0)
			})
		}),
		Overlay = if not p1.showOverlay then nil else Roact.createElement("Frame", {
			ZIndex = 3,
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = v9.Theme.BackgroundUIDefault.Color,
			BackgroundTransparency = Constants.ICON_TAB_PRESSED_TRANSPARENCY
		}, {
			Corner = Roact.createElement("UICorner", {
				CornerRadius = UDim.new(0.5, 0)
			})
		}),
		Content = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			ZIndex = 2,
			Size = if not p1.size then UDim2.new(1, 0, 1, 0) else p1.size,
			AutomaticSize = p1.automaticSize
		}, Object.assign({}, {
			Layout = Roact.createElement("UIListLayout", Object.assign({}, {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, p1.spacing or 0)
			})),
			Padding = if not p1.padding then nil else Roact.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, p1.padding.left or 0),
				PaddingRight = UDim.new(0, p1.padding.right or 0),
				PaddingTop = UDim.new(0, p1.padding.top or 0),
				PaddingBottom = UDim.new(0, p1.padding.bottom or 0)
			})
		}, t1))
	})
end
