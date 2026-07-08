local scriptParent = script.Parent
local ParentParent = scriptParent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local ParentParentParentParent = ParentParentParent.Parent
local Cryo = require(ParentParentParentParent.Cryo)
local Roact = require(ParentParentParentParent.Roact)
local t = require(ParentParentParentParent.t)
local ToastIcon = require(scriptParent.ToastIcon)
local ToastText = require(scriptParent.ToastText)
local Button = require(ParentParent.Button.Button)
local ButtonType = require(ParentParent.Button.Enum.ButtonType)
local StandardButtonSize = require(ParentParentParent.Core.Button.Enum.StandardButtonSize)
local v13 = Roact.PureComponent:extend("ToastFrame")

v13.validateProps = t.strictInterface({
	anchorPoint = t.optional(t.Vector2),
	buttonProps = t.optional(t.strictInterface({
		buttonDimensions = t.Vector2,
		buttonText = t.string,
		onActivated = t.callback
	})),
	iconProps = t.optional(ToastIcon.validateProps),
	iconChildren = t.optional(t.table),
	isCompact = t.optional(t.boolean),
	layoutOrder = t.optional(t.integer),
	padding = t.numberMin(0),
	position = t.optional(t.UDim2),
	size = t.UDim2,
	subtitleTextProps = t.optional(ToastText.validateProps),
	textFrameSize = t.UDim2,
	titleTextProps = ToastText.validateProps,
	buttonType = t.optional(ButtonType.isEnumValue)
})
v13.defaultProps = {
	padding = 0,
	size = UDim2.new(1, 0, 1, 0),
	textFrameSize = UDim2.new(1, 0, 1, 0)
}

local function renderToastIcon(p1, p2) -- line: 47
	-- upvalues: Roact (copy), ToastIcon (copy), Cryo (copy)
	if p1 then
		if type(p1.Image) == "function" then
			return p1:Image()
		end

		return Roact.createElement(ToastIcon, Cryo.Dictionary.join(p1, {
			LayoutOrder = 1
		}), p2)
	end

	return nil
end

function v13.render(p3) -- line: 64
	-- upvalues: ButtonType (copy), Roact (copy), renderToastIcon (copy), ToastText (copy), Cryo (copy), Button (copy), StandardButtonSize (copy)
	local buttonProps = p3.props.buttonProps
	local v19 = buttonProps and buttonProps.buttonText
	local v20 = buttonProps and buttonProps.buttonDimensions.Y
	local v21 = buttonProps and buttonProps.buttonDimensions.X
	local v22 = nil

	if buttonProps then
		v22 = buttonProps.buttonType or ButtonType.PrimarySystem
	end

	local isCompact = p3.props.isCompact
	local iconProps = p3.props.iconProps
	local v25 = buttonProps and buttonProps.onActivated
	local padding = p3.props.padding
	local subtitleTextProps = p3.props.subtitleTextProps
	local v28 = if subtitleTextProps then if not isCompact then Enum.VerticalAlignment.Center else Enum.VerticalAlignment.Top else Enum.VerticalAlignment.Center

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		AnchorPoint = p3.props.anchorPoint,
		LayoutOrder = p3.props.layoutOrder,
		Position = p3.props.position,
		Size = p3.props.size
	}, {
		UIListLayout = Roact.createElement("UIListLayout", {
			FillDirection = if not isCompact then Enum.FillDirection.Horizontal else Enum.FillDirection.Vertical,
			Padding = UDim.new(0, padding),
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = if not isCompact then Enum.HorizontalAlignment.Left else Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center
		}),
		UIPadding = padding > 0 and Roact.createElement("UIPadding", {
			PaddingBottom = UDim.new(0, padding),
			PaddingLeft = UDim.new(0, padding),
			PaddingRight = UDim.new(0, padding),
			PaddingTop = UDim.new(0, padding)
		}),
		ToastMessageFrame = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ClipsDescendants = false,
			LayoutOrder = 1,
			AnchorPoint = p3.props.anchorPoint,
			Position = p3.props.position,
			Size = if buttonProps then if not isCompact then UDim2.new(1, -v21, 1, 0) else UDim2.new(1, 0, 1, -v20) else p3.props.size
		}, {
			UIListLayout = Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				Padding = UDim.new(0, padding),
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = v28 or if not isCompact then Enum.VerticalAlignment.Center else Enum.VerticalAlignment.Top
			}),
			ToastIcon = renderToastIcon(iconProps, p3.props.iconChildren),
			ToastTextFrame = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 2,
				Size = p3.props.textFrameSize
			}, {
				UIListLayout = Roact.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					SortOrder = Enum.SortOrder.LayoutOrder
				}),
				ToastTitle = Roact.createElement(ToastText, Cryo.Dictionary.join(p3.props.titleTextProps, {
					LayoutOrder = 1
				})),
				ToastSubtitle = subtitleTextProps and Roact.createElement(ToastText, Cryo.Dictionary.join(subtitleTextProps, {
					LayoutOrder = 2
				}))
			})
		}),
		ToastButton = buttonProps and Roact.createElement(Button, {
			layoutOrder = 2,
			buttonType = v22,
			fitContent = not isCompact,
			maxWidth = if isCompact then nil else buttonProps.buttonDimensions.X,
			onActivated = v25,
			standardSize = StandardButtonSize.Small,
			text = v19
		})
	})
end

return v13
