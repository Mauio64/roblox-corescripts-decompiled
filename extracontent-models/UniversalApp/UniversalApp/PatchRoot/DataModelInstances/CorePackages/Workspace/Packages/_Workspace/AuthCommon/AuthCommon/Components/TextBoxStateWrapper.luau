local Parent = script:FindFirstAncestor("AuthCommon").Parent
local Cryo = require(Parent.Cryo)
local UIBlox = require(Parent.UIBlox)
local Roact = require(Parent.Roact)
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local GetImageData = require(Parent.RobloxAppAssets).GetImageData
local withStyle = UIBlox.Style.withStyle
local v8 = Roact.Component:extend("TextBoxStateWrapper")

v8.defaultProps = {
	TextBoxLabelPadding = 12,
	InnerSidePadding = 0,
	IconSize = UDim2.new(1, 0, 1, 0)
}

function v8.init(p1) -- line: 24
	p1:setState({
		Focused = false,
		Hover = false
	})

	function p1.onMouseEnter() -- line: 30
		-- upvalues: p1 (copy)
		p1:setState({
			Hover = true
		})
	end
	function p1.onMouseLeave() -- line: 36
		-- upvalues: p1 (copy)
		p1:setState({
			Hover = false
		})
	end
	function p1.onFocused(...) -- line: 42
		-- upvalues: p1 (copy)
		p1:setState({
			Focused = true
		})

		if p1.props.ChildProps.onFocused then
			p1.props.ChildProps.onFocused(...)
		end
	end
	function p1.onFocusLost(...) -- line: 51
		-- upvalues: p1 (copy)
		p1:setState({
			Focused = false
		})

		if p1.props.ChildProps.onFocusLost then
			p1.props.ChildProps.onFocusLost(...)
		end
	end
end
function v8.render(p2) -- line: 61
	-- upvalues: withStyle (copy), Roact (copy), ImageSetLabel (copy), GetImageData (copy), Cryo (copy)
	local HelpComponent = p2.props.HelpComponent
	local ErrorText = p2.props.ErrorText
	local LabelText = p2.props.LabelText

	return withStyle(function(p3) -- line: 66
		-- upvalues: p2 (copy), Roact (copy), LabelText (copy), ImageSetLabel (copy), GetImageData (copy), Cryo (copy), ErrorText (copy), HelpComponent (copy)
		local UIDefaultColor = p3.Theme.UIDefault.Color
		local UIDefaultTransparency = p3.Theme.UIDefault.Transparency

		if p2.props.ErrorState then
			UIDefaultColor = p3.Theme.Alert.Color
			UIDefaultTransparency = p3.Theme.Alert.Transparency
		elseif p2.state.Focused then
			UIDefaultColor = p3.Theme.IconEmphasis.Color
			UIDefaultTransparency = p3.Theme.IconEmphasis.Transparency
		elseif p2.state.Hover then
			UIDefaultColor = p3.Theme.IconDefault.Color
			UIDefaultTransparency = p3.Theme.IconDefault.Transparency
		end

		return Roact.createElement("Frame", {
			AnchorPoint = p2.props.AnchorPoint,
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = p2.props.LayoutOrder,
			Position = p2.props.Position,
			Size = UDim2.fromScale(1, 0),
			[Roact.Change.AbsolutePosition] = p2.props.onPositionChangedCallback
		}, {
			ListLayout = Roact.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				Padding = UDim.new(0, p2.props.TextBoxLabelPadding)
			}),
			TextBoxLabel = LabelText and Roact.createElement("TextLabel", {
				BackgroundTransparency = 1,
				LayoutOrder = 1,
				TextWrapped = true,
				AutomaticSize = Enum.AutomaticSize.Y,
				Font = p3.Font.CaptionHeader.Font,
				Size = UDim2.fromScale(1, 0),
				Text = LabelText,
				TextColor3 = p3.Theme.TextEmphasis.Color,
				TextSize = p2.props.TextBoxLabelTextSize,
				TextTransparency = p3.Theme.TextEmphasis.Transparency,
				TextXAlignment = Enum.TextXAlignment.Left
			}),
			TextBox = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				LayoutOrder = 2,
				Size = p2.props.Size,
				[Roact.Ref] = p2.props.buttonRef
			}, {
				Border = Roact.createElement(ImageSetLabel, {
					ZIndex = 2,
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 1, 0),
					ScaleType = Enum.ScaleType.Slice,
					SliceCenter = Rect.new(9, 9, 9, 9),
					Image = GetImageData("LuaApp/buttons/buttonStroke") or "LuaApp/buttons/buttonStroke",
					ImageColor3 = UIDefaultColor,
					ImageTransparency = UIDefaultTransparency
				}),
				TextBox = Roact.createElement(p2.props.ChildClass, Cryo.Dictionary.join(p2.props.ChildProps, {
					Size = UDim2.new(1, 0, 1, 0),
					onMouseEnter = p2.onMouseEnter,
					onMouseLeave = p2.onMouseLeave,
					onFocused = p2.onFocused,
					onFocusLost = p2.onFocusLost
				})),
				IconWrapper = p2.props.Icon and Roact.createElement("Frame", {
					BackgroundTransparency = 1,
					ZIndex = 2,
					Size = UDim2.new(1, 0, 1, 0),
					Position = UDim2.new(1, -2, 0, 0),
					AnchorPoint = Vector2.new(1, 0)
				}, {
					AspectRatio = Roact.createElement("UIAspectRatioConstraint", {
						AspectRatio = 1
					}),
					Icon = Roact.createElement(ImageSetLabel, {
						BackgroundTransparency = 1,
						Size = p2.props.IconSize,
						Position = UDim2.new(0.5, 0, 0.5, 0),
						AnchorPoint = Vector2.new(0.5, 0.5),
						Image = p2.props.Icon,
						ImageColor3 = UIDefaultColor,
						ImageTransparency = UIDefaultTransparency
					})
				})
			}),
			ErrorText = ErrorText and Roact.createElement("TextLabel", {
				BackgroundTransparency = 1,
				LayoutOrder = 3,
				TextWrapped = true,
				AutomaticSize = Enum.AutomaticSize.Y,
				Font = p3.Font.CaptionBody.Font,
				Size = UDim2.fromScale(1, 0),
				Text = ErrorText,
				TextColor3 = p3.Theme.Alert.Color,
				TextSize = p3.Font.CaptionBody.RelativeSize * p3.Font.BaseSize,
				TextXAlignment = Enum.TextXAlignment.Left
			}, {
				Padding = p2.props.InnerSidePadding ~= 0 and Roact.createElement("UIPadding", {
					PaddingRight = UDim.new(0, p2.props.InnerSidePadding),
					PaddingLeft = UDim.new(0, p2.props.InnerSidePadding)
				})
			}),
			HelpComponentWrapper = not ErrorText and (HelpComponent and Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				LayoutOrder = 4,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.fromScale(1, 0)
			}, {
				Padding = p2.props.InnerSidePadding ~= 0 and Roact.createElement("UIPadding", {
					PaddingRight = UDim.new(0, p2.props.InnerSidePadding),
					PaddingLeft = UDim.new(0, p2.props.InnerSidePadding)
				}),
				HelpComponent = HelpComponent
			}))
		})
	end)
end

return v8
