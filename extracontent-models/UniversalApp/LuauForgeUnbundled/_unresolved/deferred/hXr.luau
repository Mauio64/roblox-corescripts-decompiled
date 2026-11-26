local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local React = require(CorePackages.Packages.React)

local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle
local buttonType = UIBlox.App.Button.Enum.ButtonType
local linkButton = UIBlox.App.Button.LinkButton
local partialPageModal = UIBlox.App.Dialog.Modal.PartialPageModal
local getPartialPageModalMiddleContentWidth = UIBlox.App.Dialog.Modal.getPartialPageModalMiddleContentWidth
local AuthCommon = require("@game/CorePackages/Workspace/Packages/AuthCommon")
local authStatefulRoundCornerBorder = AuthCommon.Components.AuthStatefulRoundCornerBorder
local textInputBoxWithBorder = AuthCommon.Components.TextInputBoxWithBorder
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local getImageData = require("@game/CorePackages/Workspace/Packages/RobloxAppAssets").GetImageData
local Foundation = require(CorePackages.Packages.Foundation)
local useTokens = Foundation.Hooks.useTokens

local Cryo = require(CorePackages.Packages.Cryo)
local FitChildren = require("@game/CorePackages/Workspace/Packages/_Index/PeekView/PeekView/FitChildren")
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local FitFrame = require(CorePackages.Packages.FitFrame)
local fitTextLabel = FitFrame.FitTextLabel

local getFFlagEnableAuthsecImageUpdate = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagEnableAuthsecImageUpdate

local UserInputService = game:GetService("UserInputService")

local module3 = require("@luauforge/deferred/hXs")

local extended = Roact.PureComponent:extend("EmailVerificationUpsellStep")

local images = UIBlox.App.ImageSet.Images
local iconSize = UIBlox.App.ImageSet.Enum.IconSize
local getIconSizeUDim2 = UIBlox.App.ImageSet.getIconSizeUDim2

local iconsgraphiclock_xxlarge = images["icons/graphic/lock_xxlarge"]
local iconSizeUDim2 = getIconSizeUDim2(iconSize.XLarge)

extended.defaultProps = {
	shouldShowPrivacyPolicyLink = function(): boolean
		return false
	end,
	primaryButtonType = buttonType.PrimarySystem,
	secondaryButtonType = buttonType.Secondary
}

function extended:init()
	self.state = { onScreenKeyboardHeight = 0 }

	function self.getLinks()
		local mapped = Cryo.List.map(self.props.links, function(props, p2)
			return Roact.createElement(module3, {
				textKey = props.textKey,
				layoutOrder = p2,
				onActivatedCallback = props.onClicked,
				isPrimaryLink = props.isPrimaryLink,
				testId = "auth-signup-upsell-link-" .. tostring(p2)
			})
		end)

		return Roact.createFragment(mapped)
	end

	function self.getEnvelopeIconImage(p2): string
		if p2 == Foundation.Enums.ColorMode.Dark then
			return "icons/graphic/envelope_dark"
		end

		return "icons/graphic/envelope_light"
	end

	function self.getButtonStackProps()
		local primaryButtonText = self.props.primaryButtonText
		local secondaryButtonText = self.props.secondaryButtonText
		local onPrimaryButtonActivated = self.props.onPrimaryButtonActivated
		local onSecondaryButtonActivated = self.props.onSecondaryButtonActivated
		local primaryButtonType = self.props.primaryButtonType
		local secondaryButtonType = self.props.secondaryButtonType

		local isPrimaryButtonDisabled = self.state.isPrimaryButtonDisabled
		local joined = primaryButtonText and {
			{
				buttonType = primaryButtonType,
				props = {
					onActivated = onPrimaryButtonActivated,
					text = primaryButtonText,
					isDisabled = isPrimaryButtonDisabled
				}
			}
		} or {}

		if secondaryButtonText then
			joined = Cryo.List.join({
				{
					buttonType = secondaryButtonType,
					props = {
						onActivated = onSecondaryButtonActivated,
						text = secondaryButtonText
					}
				}
			}, joined)
		end

		return {
			buttonHeight = 48,
			forcedFillDirection = Enum.FillDirection.Vertical,
			buttons = joined
		}
	end

	function self.getUpdatedModalMiddleContent(props, p2)
		local errorMessage = self.props.errorMessage
		local v5 = errorMessage and errorMessage ~= ""
		local default = authStatefulRoundCornerBorder.BorderState.Default

		local createElement = React.createElement
		local v7 = {
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			BorderSizePixel = 0
		}

		local v8 = {
			ContentPadding = React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, 24)
			}),
			ListLayout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				Padding = UDim.new(0, 24)
			}),
			BodyText = React.createElement(fitTextLabel, {
				LayoutOrder = 2,
				BackgroundTransparency = 1,
				Text = self.props.bodyText,
				TextSize = props.Font.Body.RelativeSize * props.Font.BaseSize,
				TextColor3 = props.Theme.TextDefault.Color,
				TextTransparency = props.Theme.TextDefault.Transparency,
				Font = normalizeFontFace(props.Tokens.Typography.BodyLarge.Font),
				TextXAlignment = Enum.TextXAlignment.Left,
				width = UDim.new(0, p2),
				TextWrapped = true,
				Size = UDim2.new(0, p2, 0, 0)
			}),
			TextBox = self.props.textInputType and React.createElement(textInputBoxWithBorder, {
				textInputType = self.props.textInputType,
				textInputHeight = 48,
				layoutOrder = 3,
				borderState = default,
				textBarColor = props.Theme.BackgroundMuted.Color,
				placeholderText = self.props.textFieldPlaceholderText,
				placeholderTextColor = props.Theme.TextMuted.Color,
				onChangeTextCallback = self.props.onChangeTextCallback,
				onFocused = self.props.onEmailFocused,
				labelText = self.props.textFieldLabelText,
				labelTextColor = props.Theme.TextDefault.Color,
				errorText = v5 and errorMessage,
				Size = UDim2.new(1, 0, 0, 0)
			}),
			LegalLinks = 0,
			Links = 0
		}

		local v9 = if self.props.shouldShowPrivacyPolicyLink() then React.createElement(
			"Frame",
			{
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				LayoutOrder = 4
			},
			{
				Padding = React.createElement("UIPadding", {
					PaddingBottom = UDim.new(0, 12)
				}),
				LinksList = React.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					FillDirection = Enum.FillDirection.Horizontal,
					Padding = UDim.new(0, 24)
				}),
				TermsButton = React.createElement(module3, {
					textKey = self.props.termsOfServiceLinkKey,
					onActivatedCallback = self.props.onTermsOfServiceLinkActivated,
					isPrimaryLink = false,
					textPadding = 0,
					layoutOrder = 1,
					shouldUseAutomaticSize = true,
					testId = "auth-signup-upsell-terms"
				}),
				PrivacyPolicyButton = self.props.shouldShowPrivacyPolicyLink() and React.createElement(module3, {
					textKey = self.props.privacyPolicyLinkKey,
					onActivatedCallback = self.props.onPrivacyPolicyLinkActivated,
					isPrimaryLink = false,
					textPadding = 0,
					layoutOrder = 2,
					shouldUseAutomaticSize = true,
					testId = "auth-signup-upsell-privacy"
				})
			}
		) else nil
		v8.LegalLinks = v9

		v8.Links = self.props.links and React.createElement("Frame", {
			Size = UDim2.new(1, 0, 0, #self.props.links * 36),
			BackgroundTransparency = 1,
			LayoutOrder = 5
		}, {
			LinksList = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				Padding = UDim.new(0, 12)
			}),
			self.getLinks()
		})
		return createElement("Frame", v7, v8)
	end

	function self.getIcon(p2, p3, p4)
		if getFFlagEnableAuthsecImageUpdate() then
			return Roact.createElement("Frame", {
				LayoutOrder = 1,
				Size = UDim2.new(0, p2, 0, p3 - p4),
				BackgroundTransparency = 1
			}, {
				Image = Roact.createElement(imageSetLabel, {
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.new(0.5, 0, 0.5, 0),
					Size = UDim2.new(0, p2, 0, p3),
					ScaleType = Enum.ScaleType.Fit,
					BackgroundTransparency = 1,
					LayoutOrder = 1,
					Image = images[self.getEnvelopeIconImage(self.props.tokens.Config.ColorMode.Name)]
				})
			})
		end

		return Roact.createElement(imageSetLabel, {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Size = UDim2.new(0, 100, 0, 100),
			ScaleType = Enum.ScaleType.Fit,
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			Image = getImageData("LuaApp/graphic/verificationUpsellModal") or "LuaApp/graphic/verificationUpsellModal"
		})
	end
end

function extended:didMount()
	self.keyboardVisibleChanged = UserInputService:GetPropertyChangedSignal("OnScreenKeyboardVisible"):connect(function()
		local y = UserInputService.OnScreenKeyboardVisible and UserInputService.OnScreenKeyboardSize.Y or 0

		self:setState({ onScreenKeyboardHeight = y })
	end)
end

function extended:willUnmount()
	if self.keyboardVisibleChanged then
		self.keyboardVisibleChanged:disconnect()
	end

	self.keyboardVisibleChanged = nil
end

function extended.render(data)
	local screenSize = data.props.screenSize
	local partialPageModalMiddleContentWidth = getPartialPageModalMiddleContentWidth(screenSize.X)
	local v5 = data.state.onScreenKeyboardHeight > 0

	local v6 = data.props.tokens.Size.Size_2000 * 4
	local v7 = data.props.tokens.Size.Size_2200 * 2
	local size_1200 = data.props.tokens.Size.Size_1200

	local title = data.props.title
	local bodyText = data.props.bodyText
	local textInputType = data.props.textInputType
	local textFieldLabelText = data.props.textFieldLabelText
	local textFieldPlaceholderText = data.props.textFieldPlaceholderText
	local errorMessage = data.props.errorMessage
	local links = data.props.links
	local onEmailFocused = data.props.onEmailFocused

	local onChangeTextCallback = data.props.onChangeTextCallback
	local onCloseClickedCallback = data.props.onCloseClickedCallback

	local isEmailModalCalledFromHomePage = data.props.isEmailModalCalledFromHomePage
	local v8 = errorMessage and errorMessage ~= ""
	local v9 = authStatefulRoundCornerBorder.BorderState.Default

	if v8 then
		v9 = authStatefulRoundCornerBorder.BorderState.Error
	end

	return withStyle(function(props)
		local createElement = Roact.createElement
		local v11 = {
			title = title,
			screenSize = screenSize,
			position = v5 and UDim2.new(0.5, 0, 1, -data.state.onScreenKeyboardHeight) or nil,
			anchorPoint = v5 and Vector2.new(0.5, 1) or nil,
			buttonStackProps = data.getButtonStackProps(),
			onCloseClicked = onCloseClickedCallback
		}
		local v13

		if data.props.useUpdatedModalDesign then
			v13 = data.getUpdatedModalMiddleContent(props, partialPageModalMiddleContentWidth)
		else
			v13 = Roact.createElement(
				FitChildren.FitFrame,
				{
					BackgroundTransparency = 1,
					fitAxis = FitChildren.FitAxis.Height,
					Size = UDim2.new(1, 0, 0, 0)
				},
				{
					ContentPadding = Roact.createElement("UIPadding", {
						PaddingTop = UDim.new(0, 24),
						PaddingBottom = UDim.new(0, 24)
					}),
					ListLayout = Roact.createElement("UIListLayout", {
						SortOrder = Enum.SortOrder.LayoutOrder,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						Padding = UDim.new(0, 24)
					}),
					UIBloxLockImage = isEmailModalCalledFromHomePage and Roact.createElement(imageSetLabel, {
						Size = iconSizeUDim2,
						BackgroundTransparency = 1,
						LayoutOrder = 1,
						ScaleType = Enum.ScaleType.Fit,
						Image = iconsgraphiclock_xxlarge,
						ImageColor3 = props.Theme.UIEmphasis.Color,
						ImageTransparency = 0
					}),
					Icon = not isEmailModalCalledFromHomePage and data.getIcon(v6, v7, size_1200),
					BodyText = Roact.createElement(fitTextLabel, {
						LayoutOrder = 2,
						BackgroundTransparency = 1,
						Text = bodyText,
						TextSize = props.Font.Body.RelativeSize * props.Font.BaseSize,
						TextColor3 = props.Theme.TextDefault.Color,
						TextTransparency = props.Theme.TextDefault.Transparency,
						Font = normalizeFontFace(props.Tokens.Typography.BodyLarge.Font),
						TextXAlignment = Enum.TextXAlignment.Center,
						width = UDim.new(0, partialPageModalMiddleContentWidth),
						TextWrapped = true,
						Size = UDim2.new(0, partialPageModalMiddleContentWidth, 0, 0)
					}),
					TextBox = textInputType and Roact.createElement(textInputBoxWithBorder, {
						textInputType = textInputType,
						textInputHeight = 36,
						layoutOrder = 3,
						borderState = v9,
						placeholderText = textFieldPlaceholderText,
						onChangeTextCallback = onChangeTextCallback,
						onFocused = onEmailFocused,
						labelText = textFieldLabelText,
						errorText = v8 and errorMessage,
						Size = UDim2.new(1, 0, 0, 0)
					}),
					PrivacyPolicyButton = data.props.shouldShowPrivacyPolicyLink() and Roact.createElement(linkButton, {
						text = data.props.privacyPolicyLinkText,
						onActivated = data.props.onPrivacyPolicyLinkActivated,
						layoutOrder = 4,
						fontStyle = "CaptionBody"
					}),
					Links = links and Roact.createElement("Frame", {
						Size = UDim2.new(1, 0, 0, #links * 36),
						BackgroundTransparency = 1,
						LayoutOrder = 5
					}, {
						LinksList = Roact.createElement("UIListLayout", {
							SortOrder = Enum.SortOrder.LayoutOrder,
							HorizontalAlignment = Enum.HorizontalAlignment.Center,
							Padding = UDim.new(0, 12)
						}),
						TopPadding = Roact.createElement("UIPadding", {
							PaddingTop = UDim.new(0, 24)
						}),
						data.getLinks()
					})
				}
			)
		end

		return createElement(partialPageModal, v11, { Middle = v13 })
	end)
end

local v5 = RoactRodux.connect(function(p2, p3)
	return { screenSize = p2.ScreenSize }
end)(extended)

return function(p2)
	local v6 = useTokens()

	return React.createElement(v5, Cryo.Dictionary.join(p2, { tokens = v6 }))
end
