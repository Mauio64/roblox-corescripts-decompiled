local UserActivationFramework = script:FindFirstAncestor("UserActivationFramework")
local UserActivationFrameworkParent = UserActivationFramework.Parent
local React = require(UserActivationFrameworkParent.React)
local UIBlox = require(UserActivationFrameworkParent.UIBlox)
local ButtonStack = UIBlox.App.Button.ButtonStack
local ButtonType = UIBlox.App.Button.Enum.ButtonType

require(UserActivationFramework.Types)

local useLocalization = require(UserActivationFrameworkParent.Localization).Hooks.useLocalization
local FullPageActivationFrameworkContext = require(UserActivationFramework.Context.FullPageActivationFrameworkContext)
local AuthAnalytics = require(UserActivationFrameworkParent.AuthAnalytics)
local EventStreamConstants = AuthAnalytics.EventStreamConstants
local authButtonClick = AuthAnalytics.Events.authButtonClick
local useAttemptNextNavigation = require(UserActivationFramework.Hooks.useAttemptNextNavigation)
local Button = UIBlox.App.Button.Button
local Images = UIBlox.App.ImageSet.Images
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local useStyle = UIBlox.Core.Style.useStyle
local Foundation = require(UserActivationFrameworkParent.Foundation)
local View = Foundation.View
local useDesignTokens = require(UserActivationFrameworkParent.Style).useDesignTokens
local useTokens = Foundation.Hooks.useTokens

local function FullPageNavigationFooter(t1: {[any]: any}) -- line: 33
	-- upvalues: React (copy), FullPageActivationFrameworkContext (copy), useStyle (copy), useDesignTokens (copy), useTokens (copy), useLocalization (copy), useAttemptNextNavigation (copy), ButtonType (copy), authButtonClick (copy), EventStreamConstants (copy), Button (copy), Images (copy), View (copy), StyledTextLabel (copy), ButtonStack (copy)
	local v23 = React.useContext(FullPageActivationFrameworkContext)
	local primaryButton = t1.primaryButton
	local secondaryButton = t1.secondaryButton
	local v26 = useStyle()
	local v27 = useDesignTokens()
	local v28 = useTokens()
	local ActivationFramework = v27.LuaApps.ActivationFramework
	local t2 = {
		orText = "Authentication.SignUp.Description.Or"
	}

	if primaryButton then
		t2.primaryText = primaryButton.buttonTextKey
	end

	if secondaryButton then
		t2.secondaryText = secondaryButton.buttonTextKey
	end

	local v31 = useLocalization(t2)
	local v32 = useAttemptNextNavigation(t1.navigation)
	local t3 = {}

	if secondaryButton and secondaryButton.shouldShowButton then
		table.insert(t3, {
			buttonType = ButtonType.Secondary,
			props = {
				text = v31.secondaryText,
				onActivated = function() -- line: 66
					-- upvalues: authButtonClick (copy), v23 (copy), EventStreamConstants (copy), v32 (copy), secondaryButton (ref)
					authButtonClick(v23.activationFrameworkState.namespace, EventStreamConstants.Button.SecondaryButton, v23.activationFrameworkState.currentState)
					v32(secondaryButton)
				end,
				isDisabled = not secondaryButton.isButtonEnabled
			}
		})
	end

	if primaryButton and primaryButton.shouldShowButton then
		table.insert(t3, {
			buttonType = ButtonType.PrimaryContextual,
			props = {
				text = v31.primaryText,
				onActivated = function() -- line: 88
					-- upvalues: authButtonClick (copy), v23 (copy), EventStreamConstants (copy), v32 (copy), primaryButton (ref)
					authButtonClick(v23.activationFrameworkState.namespace, EventStreamConstants.Button.PrimaryButton, v23.activationFrameworkState.currentState)
					v32(primaryButton)
				end,
				isDisabled = not primaryButton.isButtonEnabled
			}
		})
	end

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y
	}, {
		ButtonStack = if not t1.shouldShowButtonDivider then React.createElement(ButtonStack, {
			buttons = t3,
			buttonHeight = ActivationFramework.footerButtonHeightPx,
			marginBetween = ActivationFramework.footerButtonMarginBetweenPx,
			forcedFillDirection = Enum.FillDirection.Vertical
		}) else React.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		}, {
			UIListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalFlex = Enum.UIFlexAlignment.Fill,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, ActivationFramework.footerButtonMarginBetweenPx)
			}),
			PrimaryButton = primaryButton and (primaryButton.shouldShowButton and React.createElement(Button, {
				layoutOrder = 1,
				text = v31.primaryText,
				icon = if not primaryButton.icon then nil else Images[primaryButton.icon],
				onActivated = function() -- line: 126
					-- upvalues: authButtonClick (copy), v23 (copy), EventStreamConstants (copy), v32 (copy), primaryButton (ref)
					authButtonClick(v23.activationFrameworkState.namespace, EventStreamConstants.Button.PrimaryButton, v23.activationFrameworkState.currentState)
					v32(primaryButton)
				end,
				size = UDim2.new(1, 0, 0, ActivationFramework.footerButtonHeightPx),
				buttonType = ButtonType.PrimaryContextual,
				isDisabled = not primaryButton.isButtonEnabled
			})),
			Divider = t1.shouldShowButtonDivider and React.createElement(View, {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				LayoutOrder = 2,
				Size = UDim2.new(1, 0, 0, ActivationFramework.footerButtonHeightPx)
			}, {
				DividerLine = React.createElement(View, {
					tag = "stroke-default size-full-0 auto-y position-center-center anchor-center-center",
					ZIndex = 1
				}),
				DividerText = React.createElement("Frame", {
					BackgroundTransparency = 0,
					BorderSizePixel = 0,
					ZIndex = 2,
					Size = UDim2.new(0, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.XY,
					BackgroundColor3 = v26.Theme.BackgroundDefault.Color,
					Position = UDim2.new(0.5, 0, 0.5, 0),
					AnchorPoint = Vector2.new(0.5, 0.5)
				}, {
					UIPadding = React.createElement("UIPadding", {
						PaddingRight = UDim.new(0, v28.Padding.Small),
						PaddingLeft = UDim.new(0, v28.Padding.Small)
					}),
					DividerTextLabel = React.createElement(StyledTextLabel, {
						BackgroundTransparency = 1,
						text = v31.orText,
						fontStyle = v28.Typography.LabelMedium,
						colorStyle = v26.Theme.TextDefault,
						textXAlignment = Enum.TextXAlignment.Center,
						textYAlignment = Enum.TextYAlignment.Center,
						automaticSize = Enum.AutomaticSize.XY
					})
				})
			}),
			SecondaryButton = secondaryButton and (secondaryButton.shouldShowButton and React.createElement(Button, {
				layoutOrder = 3,
				text = v31.secondaryText,
				icon = if not secondaryButton.icon then nil else Images[secondaryButton.icon],
				size = UDim2.new(1, 0, 0, ActivationFramework.footerButtonHeightPx),
				onActivated = function() -- line: 180
					-- upvalues: authButtonClick (copy), v23 (copy), EventStreamConstants (copy), v32 (copy), secondaryButton (ref)
					authButtonClick(v23.activationFrameworkState.namespace, EventStreamConstants.Button.SecondaryButton, v23.activationFrameworkState.currentState)
					v32(secondaryButton)
				end,
				buttonType = ButtonType.Secondary,
				isDisabled = not secondaryButton.isButtonEnabled
			}))
		})
	})
end

return FullPageNavigationFooter
