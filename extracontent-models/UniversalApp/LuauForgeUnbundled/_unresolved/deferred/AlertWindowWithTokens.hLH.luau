local CorePackages = game:GetService("CorePackages")

local module = require("@luauforge/bundled/ecR")
local React = require(CorePackages.Packages.React)
local module2 = require("@luauforge/bundled/fpF")
local module3 = require("@luauforge/bundled/edC")

local FitChildren = require("@game/CorePackages/Workspace/Packages/_Index/PeekView/PeekView/FitChildren")

local Foundation = require(CorePackages.Packages.Foundation)
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local v5

if foundationFontFaceMigration then
	local FitFrame = require(CorePackages.Packages.FitFrame)
	v5 = FitFrame.FitTextLabel
else
	v5 = require("@luauforge/bundled/fpE")
end

local button = Foundation.Button
local buttonVariant = Foundation.Enums.ButtonVariant
local buttonSize = Foundation.Enums.ButtonSize
local useTokens = Foundation.Hooks.useTokens

local module5 = require("@luauforge/bundled/fyp")

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

	local v6 = math.min(containerWidth - 20 - 20, 400)

	local v7 = v6 - 20 - 20
	local v8 = if hasCancelButton then (v7 - 10) / 2 or v7 else v7

	local textHeight = module2.GetTextHeight(messageText, messageFont, 20, v7)

	local function fn(p3)
		local createElement = module.createElement
		local fitFrame = FitChildren.FitFrame
		local v9 = {
			Size = UDim2.new(0, v6, 0, 0),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = tokens.Color.Surface.Surface_300.Color3,
			BorderSizePixel = 0,
			Active = true,
			fitAxis = FitChildren.FitAxis.Height
		}
		local children = {
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
			Title = 0,
			Divider = 0,
			Message = 0,
			Buttons = 0
		}

		local createElement2 = module.createElement
		local fitFrame2 = FitChildren.FitFrame
		local v10 = {
			Size = UDim2.new(1, 0, 0, 0),
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			fitAxis = FitChildren.FitAxis.Height
		}
		local children2 = {
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
			Title = 0,
			PaddingBottom = 0
		}

		local createElement3 = module.createElement
		local v12 = {
			Size = UDim2.new(1, 0, 0, 28),
			Position = UDim2.new(0, 0, 0, 11),
			BackgroundTransparency = 1,
			Text = titleText,
			Font = 0,
			TextSize = 0,
			TextColor3 = 0,
			TextXAlignment = 0,
			TextWrapped = true,
			LayoutOrder = 2,
			fitAxis = 0,
			width = 0
		}

		local v13 = if foundationFontFaceMigration then normalizeFontFace(titleFont) else titleFont
		v12.Font = v13
		v12.TextSize = titleTextSize
		v12.TextColor3 = tokens.Color.Content.Emphasis.Color3
		v12.TextXAlignment = Enum.TextXAlignment.Center

		local v14 = if not foundationFontFaceMigration then FitChildren.FitAxis.Height else nil
		v12.fitAxis = v14
		local v15 = if foundationFontFaceMigration then UDim.new(1, 0) else nil
		v12.width = v15
		children2.Title = createElement3(v5, v12)

		children2.PaddingBottom = module.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 11),
			LayoutOrder = 3
		})
		children.Title = createElement2(fitFrame2, v10, children2)

		children.Divider = module.createElement("Frame", {
			Size = UDim2.new(1, 0, 0, 1),
			BackgroundColor3 = tokens.Color.Stroke.Default.Color3,
			BorderSizePixel = 0,
			LayoutOrder = 2
		})

		children.Message = module.createElement("Frame", {
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
		})

		local createElement4 = module.createElement
		local v17 = {
			Size = UDim2.new(1, 0, 0, 36),
			BackgroundTransparency = 1,
			LayoutOrder = 4
		}

		local v18 = {
			Layout = module.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 10)
			}),
			CancelButton = 0,
			ConfirmButton = 0
		}

		local v19 = hasCancelButton

		if v19 then
			local createElement5 = module.createElement

			local v22 = if module5 then buttonVariant.Standard else buttonVariant.Subtle
			v19 = createElement5(button, {
				variant = v22,
				size = buttonSize.Medium,
				width = UDim.new(0, v8),
				text = p3.cancelText,
				LayoutOrder = 1,
				onActivated = onCancel
			})
		end

		v18.CancelButton = v19

		v18.ConfirmButton = module.createElement(button, {
			variant = buttonVariant.SubEmphasis,
			size = buttonSize.Medium,
			width = UDim.new(0, v8),
			text = isConfirming and "" or confirmButtonText,
			LayoutOrder = 2,
			onActivated = isConfirming and function() end or onConfirm,
			isLoading = isConfirming
		})
		children.Buttons = createElement4("Frame", v17, v18)
		return createElement(fitFrame, v9, children)
	end

	if cancelButtonText then
		return fn({ cancelText = cancelButtonText })
	end

	return module3({ cancelText = "Feature.GamePage.LabelCancelField" })(fn)
end

local function AlertWindowWithTokens(p2)
	local v6 = useTokens()
	local clone = table.clone(p2)
	clone.tokens = v6
	return React.createElement(extended, clone)
end

return AlertWindowWithTokens
