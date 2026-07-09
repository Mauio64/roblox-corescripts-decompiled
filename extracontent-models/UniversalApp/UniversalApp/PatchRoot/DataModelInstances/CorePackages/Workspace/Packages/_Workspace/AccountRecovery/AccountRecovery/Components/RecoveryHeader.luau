local AccountRecovery = script:FindFirstAncestor("AccountRecovery")
local AccountRecoveryParent = AccountRecovery.Parent
local React = require(AccountRecoveryParent.React)
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local Foundation = require(AccountRecoveryParent.Foundation)
local IconButton = Foundation.IconButton
local FoundationText = Foundation.Text
local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize
local useTokens = Foundation.Hooks.useTokens
local EventService = require(AccountRecovery.Analytics.EventService)

local function releaseAnyFocus() -- line: 28
	-- upvalues: UserInputService (copy), GuiService (copy)
	local FocusedTextBox = UserInputService:GetFocusedTextBox()

	if FocusedTextBox then
		FocusedTextBox:ReleaseFocus()
	end

	if GuiService.SelectedObject ~= nil then
		GuiService.SelectedObject = nil
	end
end

return function(t1: {[any]: any}) -- line: 38
	-- upvalues: useTokens (copy), React (copy), IconButton (copy), InputSize (copy), ButtonVariant (copy), UserInputService (copy), GuiService (copy), EventService (copy), FoundationText (copy)
	local v16 = useTokens()

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		LayoutOrder = t1.LayoutOrder,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.new(1, 0, 0, 0)
	}, {
		BackButton = if not t1.onBackActivated then nil else React.createElement(IconButton, {
			icon = "icons/actions/cycleLeft",
			size = InputSize.Medium,
			variant = ButtonVariant.Utility,
			Position = UDim2.new(0, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0, 0.5),
			onActivated = function() -- line: 54
				-- upvalues: UserInputService (copy), GuiService (copy), EventService (copy), t1 (copy)
				local FocusedTextBox = UserInputService:GetFocusedTextBox()

				if FocusedTextBox then
					FocusedTextBox:ReleaseFocus()
				end

				if GuiService.SelectedObject ~= nil then
					GuiService.SelectedObject = nil
				end

				EventService.sendBackButtonClickedEvent(t1.recoverySessionId or "", t1.currentComponent or "")
				t1.onBackActivated()
			end,
			isDisabled = t1.backButtonDisabled or false
		}),
		RecoveryHeadingText = React.createElement(FoundationText, {
			Text = t1.recoveryHeadingText,
			Size = UDim2.new(1, 0, 1, 0),
			fontStyle = v16.Typography.HeadingSmall,
			textStyle = v16.Color.Content.Emphasis,
			TextXAlignment = Enum.TextXAlignment.Center,
			TextYAlignment = Enum.TextYAlignment.Center
		})
	})
end
