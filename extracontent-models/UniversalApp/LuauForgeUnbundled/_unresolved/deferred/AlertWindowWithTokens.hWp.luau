local CorePackages = game:GetService("CorePackages")

local module = require("@luauforge/bundled/ego")
local React = require(CorePackages.Packages.React)
local module2 = require("@luauforge/deferred/fFU")
local module3 = require("@luauforge/bundled/egZ")

local FitChildren = require("@game/CorePackages/Workspace/Packages/_Index/PeekView/PeekView/FitChildren")

local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local FitFrame = require(CorePackages.Packages.FitFrame)
local fitTextLabel = FitFrame.FitTextLabel
local button = Foundation.Button
local buttonVariant = Foundation.Enums.ButtonVariant
local buttonSize = Foundation.Enums.ButtonSize
local useTokens = Foundation.Hooks.useTokens

local module5 = require("@luauforge/bundled/fGg")

local extended = module.PureComponent:extend("AlertWindow")

extended.defaultProps = {
	titleTextSize = 25,
	messageTextAlignment = Enum.TextXAlignment.Center
}

function extended.render(p2)
	local tokens = p2.props.tokens
	local containerWidth = p2.props.containerWidth
	local titleText = p2.props.titleText
	local titleTextSize = p2.props.titleTextSize
	local titleFont = p2.props.titleFont
	local messageText = p2.props.messageText
	local messageFont = p2.props.messageFont
	local confirmButtonText = p2.props.confirmButtonText
	local cancelButtonText = p2.props.cancelButtonText
	local onConfirm = p2.props.onConfirm
	local isConfirming = p2.props.isConfirming
	local hasCancelButton = p2.props.hasCancelButton
	local onCancel = p2.props.onCancel
	local messageTextAlignment = p2.props.messageTextAlignment

	local v5 = math.min(containerWidth - 20 - 20, 400)

	local v6 = v5 - 20 - 20
	local v7 = if hasCancelButton then (v6 - 10) / 2 or v6 else v6

	local textHeight = module2.GetTextHeight(messageText, messageFont, 20, v6)

	local function fn(p3)
		local createElement = module.createElement
		local fitFrame = FitChildren.FitFrame
		local v8 = {
			Size = UDim2.new(0, v5, 0, 0),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = tokens.Color.Surface.Surface_300.Color3,
			BorderSizePixel = 0,
			Active = true,
			fitAxis = FitChildren.FitAxis.Height
		}
		local v9 = {
			Layout = module.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			Padding = module.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, 20),
				PaddingRight = UDim.new(0, 20),
				PaddingBottom = UDim.new(0, 20)
			}),
			Title = module.createElement(
				FitChildren.FitFrame,
				{
					Size = UDim2.new(1, 0, 0, 0),
					BackgroundTransparency = 1,
					LayoutOrder = 1,
					fitAxis = FitChildren.FitAxis.Height
				},
				{
					Layout = module.createElement("UIListLayout", {
						SortOrder = Enum.SortOrder.LayoutOrder,
						FillDirection = Enum.FillDirection.Vertical,
						HorizontalAlignment = Enum.HorizontalAlignment.Center
					}),
					PaddingTop = module.createElement("Frame", {
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 0, 11),
						LayoutOrder = 1
					}),
					Title = module.createElement(fitTextLabel, {
						Size = UDim2.new(1, 0, 0, 28),
						Position = UDim2.new(0, 0, 0, 11),
						BackgroundTransparency = 1,
						Text = titleText,
						Font = normalizeFontFace(titleFont),
						TextSize = titleTextSize,
						TextColor3 = tokens.Color.Content.Emphasis.Color3,
						TextXAlignment = Enum.TextXAlignment.Center,
						TextWrapped = true,
						LayoutOrder = 2,
						width = UDim.new(1, 0)
					}),
					PaddingBottom = module.createElement("Frame", {
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 0, 11),
						LayoutOrder = 3
					})
				}
			),
			Divider = module.createElement("Frame", {
				Size = UDim2.new(1, 0, 0, 1),
				BackgroundColor3 = tokens.Color.Stroke.Default.Color3,
				BorderSizePixel = 0,
				LayoutOrder = 2
			}),
			Message = module.createElement("Frame", {
				Size = UDim2.new(1, 0, 0, 86 + textHeight),
				BackgroundTransparency = 1,
				LayoutOrder = 3
			}, {
				Message = module.createElement("TextLabel", {
					Size = UDim2.new(1, 0, 0, textHeight),
					Position = UDim2.new(0, 0, 0, 40),
					BackgroundTransparency = 1,
					Text = messageText,
					Font = messageFont,
					TextSize = 20,
					TextColor3 = tokens.Color.Content.Default.Color3,
					TextXAlignment = messageTextAlignment,
					TextWrapped = true
				})
			}),
			Buttons = 0
		}

		local createElement2 = module.createElement
		local v11 = {
			Size = UDim2.new(1, 0, 0, 36),
			BackgroundTransparency = 1,
			LayoutOrder = 4
		}

		local v12 = {
			Layout = module.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 10)
			}),
			CancelButton = 0,
			ConfirmButton = 0
		}

		local v13 = hasCancelButton

		if v13 then
			local createElement3 = module.createElement

			local v16 = if module5 then buttonVariant.Standard else buttonVariant.Subtle
			v13 = createElement3(button, {
				variant = v16,
				size = buttonSize.Medium,
				width = UDim.new(0, v7),
				text = p3.cancelText,
				LayoutOrder = 1,
				onActivated = onCancel
			})
		end

		v12.CancelButton = v13

		v12.ConfirmButton = module.createElement(button, {
			variant = buttonVariant.SubEmphasis,
			size = buttonSize.Medium,
			width = UDim.new(0, v7),
			text = isConfirming and "" or confirmButtonText,
			LayoutOrder = 2,
			onActivated = isConfirming and function() end or onConfirm,
			isLoading = isConfirming
		})
		v9.Buttons = createElement2("Frame", v11, v12)
		return createElement(fitFrame, v8, v9)
	end

	if cancelButtonText then
		return fn({ cancelText = cancelButtonText })
	end

	return module3({ cancelText = "Feature.GamePage.LabelCancelField" })(fn)
end

local function AlertWindowWithTokens(p2)
	local v5 = useTokens()
	local clone = table.clone(p2)
	clone.tokens = v5
	return React.createElement(extended, clone)
end

return AlertWindowWithTokens
