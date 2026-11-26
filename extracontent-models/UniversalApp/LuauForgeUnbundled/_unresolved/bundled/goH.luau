local module = require("@luauforge/bundled/gnx")

local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")

local module2 = require("@luauforge/bundled/goz")
local iconButton = module2.IconButton
local text = module2.Text
local buttonVariant = module2.Enums.ButtonVariant
local inputSize = module2.Enums.InputSize
local useTokens = module2.Hooks.useTokens

local module3 = require("@luauforge/bundled/gop")

local function releaseAnyFocus()
	local focusedTextBox = UserInputService:GetFocusedTextBox()

	if focusedTextBox then
		focusedTextBox:ReleaseFocus()
	end

	if GuiService.SelectedObject ~= nil then
		GuiService.SelectedObject = nil
	end
end

return function(props)
	local v5 = useTokens()

	local createElement = module.createElement
	local v7 = {
		LayoutOrder = props.LayoutOrder,
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.new(1, 0, 0, 0)
	}
	local v9

	if props.onBackActivated then
		v9 = module.createElement(iconButton, {
			icon = "icons/actions/cycleLeft",
			size = inputSize.Medium,
			variant = buttonVariant.Utility,
			Position = UDim2.new(0, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0, 0.5),
			onActivated = function()
				local focusedTextBox = UserInputService:GetFocusedTextBox()

				if focusedTextBox then
					focusedTextBox:ReleaseFocus()
				end

				if GuiService.SelectedObject ~= nil then
					GuiService.SelectedObject = nil
				end

				module3.sendBackButtonClickedEvent(
					props.recoverySessionId or "",
					props.currentComponent or ""
				)
				props.onBackActivated()
			end,
			isDisabled = props.backButtonDisabled or false
		})
	end

	return createElement("Frame", v7, {
		BackButton = v9,
		RecoveryHeadingText = module.createElement(text, {
			Text = props.recoveryHeadingText,
			Size = UDim2.new(1, 0, 1, 0),
			fontStyle = v5.Typography.HeadingSmall,
			textStyle = v5.Color.Content.Emphasis,
			TextXAlignment = Enum.TextXAlignment.Center,
			TextYAlignment = Enum.TextYAlignment.Center
		})
	})
end
