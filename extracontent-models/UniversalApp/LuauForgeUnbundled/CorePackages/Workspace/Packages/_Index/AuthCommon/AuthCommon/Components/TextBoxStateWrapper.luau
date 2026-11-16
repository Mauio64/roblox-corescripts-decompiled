local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Cryo")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/UIBlox")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Foundation")
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Roact")

local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local getImageData = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/RobloxAppAssets").GetImageData
local withStyle = UIBlox.Style.withStyle

local extended = Roact.Component:extend("TextBoxStateWrapper")

extended.defaultProps = {
	IconSize = UDim2.new(1, 0, 1, 0),
	TextBoxLabelPadding = 12,
	InnerSidePadding = 0
}

function extended:init()
	self:setState({ Focused = false, Hover = false })

	function self.onMouseEnter()
		self:setState({ Hover = true })
	end

	function self.onMouseLeave()
		self:setState({ Hover = false })
	end

	function self.onFocused(...)
		self:setState({ Focused = true })

		if self.props.ChildProps.onFocused then
			self.props.ChildProps.onFocused(...)
		end
	end

	function self.onFocusLost(...)
		self:setState({ Focused = false })

		if self.props.ChildProps.onFocusLost then
			self.props.ChildProps.onFocusLost(...)
		end
	end
end

function extended.render(data)
	local helpComponent = data.props.HelpComponent
	local errorText = data.props.ErrorText
	local labelText = data.props.LabelText

	return withStyle(function(props)
		local color = props.Theme.UIDefault.Color
		local transparency = props.Theme.UIDefault.Transparency

		if data.props.ErrorState then
			color = props.Theme.Alert.Color
			transparency = props.Theme.Alert.Transparency
		elseif data.state.Focused then
			color = props.Theme.IconEmphasis.Color
			transparency = props.Theme.IconEmphasis.Transparency
		elseif data.state.Hover then
			color = props.Theme.IconDefault.Color
			transparency = props.Theme.IconDefault.Transparency
		end

		local createElement = Roact.createElement
		local onPositionChangedCallbacksByAbsolutePosition = {
			AnchorPoint = data.props.AnchorPoint,
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = data.props.LayoutOrder,
			Position = data.props.Position,
			Size = UDim2.fromScale(1, 0),
			[Roact.Change.AbsolutePosition] = data.props.onPositionChangedCallback
		}
		local v6 = {
			ListLayout = Roact.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				Padding = UDim.new(0, data.props.TextBoxLabelPadding)
			}),
			TextBoxLabel = 0,
			TextBox = 0,
			ErrorText = 0,
			HelpComponentWrapper = 0
		}

		local v7 = labelText

		if v7 then
			local createElement2 = Roact.createElement
			local v9 = {
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				Font = 0,
				FontFace = 0,
				LayoutOrder = 1,
				Size = 0,
				Text = 0,
				TextColor3 = 0,
				TextSize = 0,
				TextTransparency = 0,
				TextWrapped = true,
				TextXAlignment = 0
			}

			local v10 = if not foundationFontFaceMigration then props.Font.CaptionHeader.Font else nil
			v9.Font = v10

			local v11 = if foundationFontFaceMigration then normalizeFontFace(props.Tokens.Typography.CaptionLarge.Font) else nil
			v9.FontFace = v11

			v9.Size = UDim2.fromScale(1, 0)
			v9.Text = labelText
			v9.TextColor3 = props.Theme.TextEmphasis.Color
			v9.TextSize = data.props.TextBoxLabelTextSize
			v9.TextTransparency = props.Theme.TextEmphasis.Transparency

			v9.TextXAlignment = Enum.TextXAlignment.Left
			v7 = createElement2("TextLabel", v9)
		end

		v6.TextBoxLabel = v7

		v6.TextBox = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = 2,
			Size = data.props.Size,
			[Roact.Ref] = data.props.buttonRef
		}, {
			Border = Roact.createElement(imageSetLabel, {
				Size = UDim2.new(1, 0, 1, 0),
				ZIndex = 2,
				BackgroundTransparency = 1,
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = Rect.new(9, 9, 9, 9),
				Image = getImageData("LuaApp/buttons/buttonStroke") or "LuaApp/buttons/buttonStroke",
				ImageColor3 = color,
				ImageTransparency = transparency
			}),
			TextBox = Roact.createElement(
				data.props.ChildClass,
				Cryo.Dictionary.join(data.props.ChildProps, {
					Size = UDim2.new(1, 0, 1, 0),
					onMouseEnter = data.onMouseEnter,
					onMouseLeave = data.onMouseLeave,
					onFocused = data.onFocused,
					onFocusLost = data.onFocusLost
				})
			),
			IconWrapper = data.props.Icon and Roact.createElement("Frame", {
				Size = UDim2.new(1, 0, 1, 0),
				Position = UDim2.new(1, -2, 0, 0),
				AnchorPoint = Vector2.new(1, 0),
				BackgroundTransparency = 1,
				ZIndex = 2
			}, {
				AspectRatio = Roact.createElement("UIAspectRatioConstraint", {
					AspectRatio = 1
				}),
				Icon = Roact.createElement(imageSetLabel, {
					Size = data.props.IconSize,
					Position = UDim2.new(0.5, 0, 0.5, 0),
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundTransparency = 1,
					Image = data.props.Icon,
					ImageColor3 = color,
					ImageTransparency = transparency
				})
			})
		})

		local v8 = errorText

		if v8 then
			local createElement3 = Roact.createElement
			local v10 = {
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				Font = 0,
				FontFace = 0,
				LayoutOrder = 3,
				Size = 0,
				Text = 0,
				TextColor3 = 0,
				TextSize = 0,
				TextWrapped = true,
				TextXAlignment = 0
			}

			local v11 = if not foundationFontFaceMigration then props.Font.CaptionBody.Font else nil
			v10.Font = v11

			local v12 = if foundationFontFaceMigration then normalizeFontFace(props.Tokens.Typography.BodySmall.Font) else nil
			v10.FontFace = v12

			v10.Size = UDim2.fromScale(1, 0)
			v10.Text = errorText
			v10.TextColor3 = props.Theme.Alert.Color
			v10.TextSize = props.Font.CaptionBody.RelativeSize * props.Font.BaseSize

			v10.TextXAlignment = Enum.TextXAlignment.Left
			v8 = createElement3("TextLabel", v10, {
				Padding = data.props.InnerSidePadding ~= 0 and Roact.createElement("UIPadding", {
					PaddingRight = UDim.new(0, data.props.InnerSidePadding),
					PaddingLeft = UDim.new(0, data.props.InnerSidePadding)
				})
			})
		end

		v6.ErrorText = v8

		local v9 = not errorText and helpComponent

		if v9 then
			v9 = Roact.createElement("Frame", {
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				LayoutOrder = 4,
				Size = UDim2.fromScale(1, 0)
			}, {
				Padding = data.props.InnerSidePadding ~= 0 and Roact.createElement("UIPadding", {
					PaddingRight = UDim.new(0, data.props.InnerSidePadding),
					PaddingLeft = UDim.new(0, data.props.InnerSidePadding)
				}),
				HelpComponent = helpComponent
			})
		end

		v6.HelpComponentWrapper = v9
		return createElement("Frame", onPositionChangedCallbacksByAbsolutePosition, v6)
	end)
end

return extended
