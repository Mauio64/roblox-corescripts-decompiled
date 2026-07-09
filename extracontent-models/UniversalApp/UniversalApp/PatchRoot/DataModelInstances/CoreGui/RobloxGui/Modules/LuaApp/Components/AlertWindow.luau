local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Roact = require(Modules.Common.Roact)
local React = require(CorePackages.Packages.React)
local Text = require(Modules.Common.Text)
local withLocalization = require(Modules.LuaApp.withLocalization)
local FitChildren = require(Modules.LuaApp.FitChildren)
local FitTextLabel = require(Modules.LuaApp.Components.FitTextLabel)
local Foundation = require(CorePackages.Packages.Foundation)
local Button = Foundation.Button
local ButtonVariant = Foundation.Enums.ButtonVariant
local ButtonSize = Foundation.Enums.ButtonSize
local useTokens = Foundation.Hooks.useTokens
local FFlagUseStandardFoundationButtonVariant = require(Modules.LuaApp.Flags.FFlagUseStandardFoundationButtonVariant)
local v15 = Roact.PureComponent:extend("AlertWindow")

v15.defaultProps = {
	titleTextSize = 25,
	messageTextAlignment = Enum.TextXAlignment.Center
}

function v15.render(p1) -- line: 47
	-- upvalues: Text (copy), Roact (copy), FitChildren (copy), FitTextLabel (copy), Button (copy), FFlagUseStandardFoundationButtonVariant (copy), ButtonVariant (copy), ButtonSize (copy), withLocalization (copy)
	local tokens = p1.props.tokens
	local containerWidth = p1.props.containerWidth
	local titleText = p1.props.titleText
	local titleTextSize = p1.props.titleTextSize
	local titleFont = p1.props.titleFont
	local messageText = p1.props.messageText
	local messageFont = p1.props.messageFont
	local confirmButtonText = p1.props.confirmButtonText
	local cancelButtonText = p1.props.cancelButtonText
	local onConfirm = p1.props.onConfirm
	local isConfirming = p1.props.isConfirming
	local hasCancelButton = p1.props.hasCancelButton
	local onCancel = p1.props.onCancel
	local messageTextAlignment = p1.props.messageTextAlignment
	local v32 = math.min(containerWidth - 20 - 20, 400)
	local v33 = v32 - 20 - 20
	local v34 = hasCancelButton and (v33 - 10) / 2 or v33
	local v35 = Text.GetTextHeight(messageText, messageFont, 20, v33)

	local function v36(p2) -- line: 70
		-- upvalues: Roact (copy), FitChildren (copy), v32 (copy), tokens (copy), FitTextLabel (copy), titleText (copy), titleFont (copy), titleTextSize (copy), v35 (copy), messageText (copy), messageFont (copy), messageTextAlignment (copy), hasCancelButton (copy), Button (copy), FFlagUseStandardFoundationButtonVariant (copy), ButtonVariant (copy), ButtonSize (copy), v34 (copy), onCancel (copy), isConfirming (copy), confirmButtonText (copy), onConfirm (copy)
		return Roact.createElement(FitChildren.FitFrame, {
			BorderSizePixel = 0,
			Active = true,
			Size = UDim2.new(0, v32, 0, 0),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = tokens.Color.Surface.Surface_300.Color3,
			fitAxis = FitChildren.FitAxis.Height
		}, {
			Layout = Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			Padding = Roact.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, 20),
				PaddingRight = UDim.new(0, 20),
				PaddingBottom = UDim.new(0, 20)
			}),
			Title = Roact.createElement(FitChildren.FitFrame, {
				BackgroundTransparency = 1,
				LayoutOrder = 1,
				Size = UDim2.new(1, 0, 0, 0),
				fitAxis = FitChildren.FitAxis.Height
			}, {
				Layout = Roact.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Center
				}),
				PaddingTop = Roact.createElement("Frame", {
					BackgroundTransparency = 1,
					LayoutOrder = 1,
					Size = UDim2.new(1, 0, 0, 11)
				}),
				Title = Roact.createElement(FitTextLabel, {
					BackgroundTransparency = 1,
					TextWrapped = true,
					LayoutOrder = 2,
					Size = UDim2.new(1, 0, 0, 28),
					Position = UDim2.new(0, 0, 0, 11),
					Text = titleText,
					Font = titleFont,
					TextSize = titleTextSize,
					TextColor3 = tokens.Color.Content.Emphasis.Color3,
					TextXAlignment = Enum.TextXAlignment.Center,
					fitAxis = FitChildren.FitAxis.Height
				}),
				PaddingBottom = Roact.createElement("Frame", {
					BackgroundTransparency = 1,
					LayoutOrder = 3,
					Size = UDim2.new(1, 0, 0, 11)
				})
			}),
			Divider = Roact.createElement("Frame", {
				BorderSizePixel = 0,
				LayoutOrder = 2,
				Size = UDim2.new(1, 0, 0, 1),
				BackgroundColor3 = tokens.Color.Stroke.Default.Color3
			}),
			Message = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 3,
				Size = UDim2.new(1, 0, 0, 86 + v35)
			}, {
				Message = Roact.createElement("TextLabel", {
					BackgroundTransparency = 1,
					TextSize = 20,
					TextWrapped = true,
					Size = UDim2.new(1, 0, 0, v35),
					Position = UDim2.new(0, 0, 0, 40),
					Text = messageText,
					Font = messageFont,
					TextColor3 = tokens.Color.Content.Default.Color3,
					TextXAlignment = messageTextAlignment
				})
			}),
			Buttons = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 4,
				Size = UDim2.new(1, 0, 0, 36)
			}, {
				Layout = Roact.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Horizontal,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 10)
				}),
				CancelButton = hasCancelButton and Roact.createElement(Button, {
					LayoutOrder = 1,
					variant = if not FFlagUseStandardFoundationButtonVariant then ButtonVariant.Subtle else ButtonVariant.Standard,
					size = ButtonSize.Medium,
					width = UDim.new(0, v34),
					text = p2.cancelText,
					onActivated = onCancel
				}),
				ConfirmButton = Roact.createElement(Button, {
					LayoutOrder = 2,
					variant = ButtonVariant.SubEmphasis,
					size = ButtonSize.Medium,
					width = UDim.new(0, v34),
					text = if not isConfirming then confirmButtonText else "",
					onActivated = if not isConfirming then onConfirm else function() -- line: 177
					end,
					isLoading = isConfirming
				})
			})
		})
	end

	if cancelButtonText then
		return v36({
			cancelText = cancelButtonText
		})
	end

	return withLocalization({
		cancelText = "Feature.GamePage.LabelCancelField"
	})(v36)
end

local function AlertWindowWithTokens(p3) -- line: 193
	-- upvalues: useTokens (copy), React (copy), v15 (copy)
	local v38 = useTokens()
	local v39 = table.clone(p3)

	v39.tokens = v38

	return React.createElement(v15, v39)
end

return AlertWindowWithTokens
