local ParentParent = script.Parent.Parent
local dependencies = require(ParentParent.dependencies)
local React = dependencies.React
local UIBlox = dependencies.UIBlox
local useStyle = UIBlox.Core.Style.useStyle
local useDesignTokens = dependencies.Style.useDesignTokens
local PartialPageModal = UIBlox.App.Dialog.Modal.PartialPageModal
local getPartialPageModalMiddleContentWidth = UIBlox.App.Dialog.Modal.getPartialPageModalMiddleContentWidth
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local useLocalization = dependencies.Localization.Hooks.useLocalization
local InputField = require(script.Parent.InputField)
local AnalyticsEvents = require(ParentParent.Analytics.AnalyticsEvents)
local EventConstants = require(ParentParent.Analytics.EventConstants)

local function getButtonStackProps(s1: string, p1: ((...any) -> ...any), b1: boolean, n1: number) -- line: 32
	-- upvalues: ButtonType (copy)
	local t1 = {{
		buttonType = ButtonType.PrimarySystem,
		props = {
			onActivated = p1,
			text = s1,
			isDisabled = b1
		}
	}}

	return {
		buttonHeight = n1,
		forcedFillDirection = Enum.FillDirection.Vertical,
		buttons = t1
	}
end
local function EnterEmailView(t2: {[any]: any}) -- line: 57
	-- upvalues: useStyle (copy), useDesignTokens (copy), useLocalization (copy), getPartialPageModalMiddleContentWidth (copy), React (copy), AnalyticsEvents (copy), EventConstants (copy), PartialPageModal (copy), getButtonStackProps (copy), InputField (copy)
	local v22 = useStyle()
	local v23 = useDesignTokens()
	local v24 = useLocalization({
		emailPlaceholder = "Authentication.Login.Label.Email",
		continueButton = "Authentication.OneTimePasscode.Action.Continue"
	})
	local v25 = getPartialPageModalMiddleContentWidth(t2.screenSize.X)
	local v26 = React.useCallback(function() -- line: 66
		-- upvalues: t2 (copy)
		return t2.isDisabled or (string.len(t2.errorMessage) > 0 or string.len(t2.email) == 0)
	end, {
		t2.isDisabled,
		t2.errorMessage,
		t2.email
	})

	React.useEffect(function() -- line: 72
		-- upvalues: AnalyticsEvents (copy), EventConstants (copy), t2 (copy)
		AnalyticsEvents.sendPageLoadEvent(EventConstants.ctx.sendOtp, t2.origin)
	end, {})

	return React.createElement(PartialPageModal, {
		title = t2.enterEmailTitle,
		screenSize = t2.screenSize,
		buttonStackProps = getButtonStackProps(v24.continueButton, t2.handleContinue, v26(), v23.Size.Size_1200),
		onCloseClicked = t2.onClose,
		position = t2.isKeyboardShowing and UDim2.new(0.5, 0, 1, -t2.keyboardHeight) or nil,
		anchorPoint = t2.isKeyboardShowing and Vector2.new(0.5, 1) or nil
	}, {
		Middle = React.createElement("Frame", {
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.new(1, 0, 0, 0)
		}, {
			ContentPadding = React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, v23.Size.Size_600),
				PaddingBottom = UDim.new(0, v23.Size.Size_600)
			}),
			ListLayout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				Padding = UDim.new(0, v23.Size.Size_300)
			}),
			BodyText = React.createElement("TextLabel", {
				BackgroundTransparency = 1,
				TextWrapped = true,
				LayoutOrder = 1,
				Text = t2.enterEmailDescription,
				TextSize = v22.Font.BaseSize,
				TextColor3 = v22.Theme.TextDefault.Color,
				TextTransparency = v22.Theme.TextDefault.Transparency,
				Font = v22.Font.Body.Font,
				TextXAlignment = Enum.TextXAlignment.Left,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(0, v25, 0, 0)
			}),
			EmailInput = React.createElement(InputField, {
				LayoutOrder = 2,
				text = t2.email,
				disabled = t2.isDisabled,
				onChange = t2.onEmailTextChange,
				errorMessage = t2.errorMessage,
				placeholder = v24.emailPlaceholder
			})
		})
	})
end

return EnterEmailView
