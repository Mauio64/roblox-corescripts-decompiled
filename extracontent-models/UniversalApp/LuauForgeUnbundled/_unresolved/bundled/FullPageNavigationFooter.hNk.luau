local module = require("@luauforge/bundled/hMW")
local module2 = require("@luauforge/bundled/hNd")
local buttonStack = module2.App.Button.ButtonStack
local buttonType = module2.App.Button.Enum.ButtonType
require("@luauforge/bundled/hMS")
local useLocalization = require("@luauforge/bundled/hNh").Hooks.useLocalization
local module3 = require("@luauforge/bundled/hMV")
local module4 = require("@luauforge/bundled/hNl")
local eventStreamConstants = module4.EventStreamConstants
local authButtonClick = module4.Events.authButtonClick
local module5 = require("@luauforge/bundled/hNm")

local button = module2.App.Button.Button
local images = module2.App.ImageSet.Images
local styledTextLabel = module2.App.Text.StyledTextLabel
local useStyle = module2.Core.Style.useStyle

local module6 = require("@luauforge/bundled/hNe")
local view = module6.View
local useDesignTokens = require("@luauforge/bundled/hNg").useDesignTokens
local useTokens = module6.Hooks.useTokens

local function FullPageNavigationFooter(props)
	local v5 = module.useContext(module3)
	local primaryButton = props.primaryButton
	local secondaryButton = props.secondaryButton

	local v6 = useStyle()
	local v7 = useDesignTokens()
	local v8 = useTokens()
	local activationFramework = v7.LuaApps.ActivationFramework

	local v9 = { orText = "Authentication.SignUp.Description.Or" }

	if primaryButton then
		v9.primaryText = primaryButton.buttonTextKey
	end

	if secondaryButton then
		v9.secondaryText = secondaryButton.buttonTextKey
	end

	local v10 = useLocalization(v9)

	local v11 = module5(props.navigation)

	local v12 = {}

	if secondaryButton and secondaryButton.shouldShowButton then
		table.insert(v12, {
			buttonType = buttonType.Secondary,
			props = {
				text = v10.secondaryText,
				onActivated = function()
					authButtonClick(
						v5.activationFrameworkState.namespace,
						eventStreamConstants.Button.SecondaryButton,
						v5.activationFrameworkState.currentState
					)

					v11(secondaryButton)
				end,
				isDisabled = not secondaryButton.isButtonEnabled
			}
		})
	end

	if primaryButton and primaryButton.shouldShowButton then
		table.insert(v12, {
			buttonType = buttonType.PrimaryContextual,
			props = {
				text = v10.primaryText,
				onActivated = function()
					authButtonClick(
						v5.activationFrameworkState.namespace,
						eventStreamConstants.Button.PrimaryButton,
						v5.activationFrameworkState.currentState
					)

					v11(primaryButton)
				end,
				isDisabled = not primaryButton.isButtonEnabled
			}
		})
	end

	local createElement = module.createElement
	local v14 = {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		BorderSizePixel = 0
	}
	local v16

	if props.shouldShowButtonDivider then
		local createElement2 = module.createElement
		local v18 = {
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			BorderSizePixel = 0
		}

		local v19 = {
			UIListLayout = module.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalFlex = Enum.UIFlexAlignment.Fill,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, activationFramework.footerButtonMarginBetweenPx)
			}),
			PrimaryButton = 0,
			Divider = 0,
			SecondaryButton = 0
		}

		local v20 = primaryButton and primaryButton.shouldShowButton

		if v20 then
			local createElement3 = module.createElement
			local v22 = {
				text = v10.primaryText,
				icon = 0,
				onActivated = 0,
				size = 0,
				buttonType = 0,
				isDisabled = 0,
				layoutOrder = 1
			}
			local v23 = if primaryButton.icon then images[primaryButton.icon] else nil
			v22.icon = v23
			function v22.onActivated()
				authButtonClick(
					v5.activationFrameworkState.namespace,
					eventStreamConstants.Button.PrimaryButton,
					v5.activationFrameworkState.currentState
				)

				v11(primaryButton)
			end
			v22.size = UDim2.new(1, 0, 0, activationFramework.footerButtonHeightPx)
			v22.buttonType = buttonType.PrimaryContextual
			v22.isDisabled = not primaryButton.isButtonEnabled
			v20 = createElement3(button, v22)
		end

		v19.PrimaryButton = v20

		v19.Divider = props.shouldShowButtonDivider
			and module.createElement(
				view,
				{
					Size = UDim2.new(1, 0, 0, activationFramework.footerButtonHeightPx),
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					LayoutOrder = 2
				},
				{
					DividerLine = module.createElement(view, {
						tag = "stroke-default size-full-0 auto-y position-center-center anchor-center-center",
						ZIndex = 1
					}),
					DividerText = module.createElement("Frame", {
						Size = UDim2.new(0, 0, 0, 0),
						AutomaticSize = Enum.AutomaticSize.XY,
						BackgroundTransparency = 0,
						BackgroundColor3 = v6.Theme.BackgroundDefault.Color,
						BorderSizePixel = 0,
						Position = UDim2.new(0.5, 0, 0.5, 0),
						AnchorPoint = Vector2.new(0.5, 0.5),
						ZIndex = 2
					}, {
						UIPadding = module.createElement("UIPadding", {
							PaddingRight = UDim.new(0, v8.Padding.Small),
							PaddingLeft = UDim.new(0, v8.Padding.Small)
						}),
						DividerTextLabel = module.createElement(styledTextLabel, {
							text = v10.orText,
							fontStyle = v8.Typography.LabelMedium,
							colorStyle = v6.Theme.TextDefault,
							textXAlignment = Enum.TextXAlignment.Center,
							textYAlignment = Enum.TextYAlignment.Center,
							automaticSize = Enum.AutomaticSize.XY,
							BackgroundTransparency = 1
						})
					})
				}
			)

		local v21 = secondaryButton and secondaryButton.shouldShowButton

		if v21 then
			local createElement3 = module.createElement
			local v23 = {
				text = v10.secondaryText,
				icon = 0,
				size = 0,
				onActivated = 0,
				buttonType = 0,
				isDisabled = 0,
				layoutOrder = 3
			}
			local v24 = if secondaryButton.icon then images[secondaryButton.icon] else nil
			v23.icon = v24
			v23.size = UDim2.new(1, 0, 0, activationFramework.footerButtonHeightPx)
			function v23.onActivated()
				authButtonClick(
					v5.activationFrameworkState.namespace,
					eventStreamConstants.Button.SecondaryButton,
					v5.activationFrameworkState.currentState
				)

				v11(secondaryButton)
			end
			v23.buttonType = buttonType.Secondary
			v23.isDisabled = not secondaryButton.isButtonEnabled
			v21 = createElement3(button, v23)
		end

		v19.SecondaryButton = v21
		v16 = createElement2("Frame", v18, v19)
	else
		v16 = module.createElement(buttonStack, {
			buttons = v12,
			buttonHeight = activationFramework.footerButtonHeightPx,
			marginBetween = activationFramework.footerButtonMarginBetweenPx,
			forcedFillDirection = Enum.FillDirection.Vertical
		})
	end

	return createElement("Frame", v14, { ButtonStack = v16 })
end

return FullPageNavigationFooter
