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
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local v5

if foundationFontFaceMigration then
	local FitFrame = require(CorePackages.Packages.FitFrame)
	v5 = FitFrame.FitTextLabel
else
	v5 = require("@luauforge/bundled/fpE")
end

local getFFlagEnableAuthsecImageUpdate = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagEnableAuthsecImageUpdate

local UserInputService = game:GetService("UserInputService")

local module3 = require("@luauforge/deferred/hML")

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
		local v6 = errorMessage and errorMessage ~= ""
		local default = authStatefulRoundCornerBorder.BorderState.Default

		local createElement = React.createElement
		local v8 = {
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			BorderSizePixel = 0
		}

		local v9 = {
			ContentPadding = React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, 24)
			}),
			ListLayout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				Padding = UDim.new(0, 24)
			}),
			BodyText = 0,
			TextBox = 0,
			LegalLinks = 0,
			Links = 0
		}

		local createElement2 = React.createElement
		local v11 = {
			LayoutOrder = 2,
			BackgroundTransparency = 1,
			Text = self.props.bodyText,
			TextSize = props.Font.Body.RelativeSize * props.Font.BaseSize,
			TextColor3 = props.Theme.TextDefault.Color,
			TextTransparency = props.Theme.TextDefault.Transparency,
			Font = 0,
			TextXAlignment = 0,
			fitAxis = 0,
			width = 0,
			TextWrapped = true,
			Size = 0
		}

		local v12 = if foundationFontFaceMigration then normalizeFontFace(props.Tokens.Typography.BodyLarge.Font) else props.Font.Body.Font
		v11.Font = v12

		v11.TextXAlignment = Enum.TextXAlignment.Left
		local v13 = if not foundationFontFaceMigration then FitChildren.FitAxis.Height else nil
		v11.fitAxis = v13
		local v14 = if foundationFontFaceMigration then UDim.new(0, p2) else nil
		v11.width = v14

		v11.Size = UDim2.new(0, p2, 0, 0)
		v9.BodyText = createElement2(v5, v11)

		v9.TextBox = self.props.textInputType and React.createElement(textInputBoxWithBorder, {
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
			errorText = v6 and errorMessage,
			Size = UDim2.new(1, 0, 0, 0)
		})

		local v15 = if self.props.shouldShowPrivacyPolicyLink() then React.createElement(
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
		v9.LegalLinks = v15

		v9.Links = self.props.links and React.createElement("Frame", {
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
		return createElement("Frame", v8, v9)
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
		self:setState({
			onScreenKeyboardHeight = UserInputService.OnScreenKeyboardVisible and UserInputService.OnScreenKeyboardSize.Y or 0
		})
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
	local v6 = data.state.onScreenKeyboardHeight > 0

	local v7 = data.props.tokens.Size.Size_2000 * 4
	local v8 = data.props.tokens.Size.Size_2200 * 2
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
	local v9 = errorMessage and errorMessage ~= ""
	local v10 = authStatefulRoundCornerBorder.BorderState.Default

	if v9 then
		v10 = authStatefulRoundCornerBorder.BorderState.Error
	end

	return withStyle(function(props)
		local createElement = Roact.createElement
		local v12 = {
			title = title,
			screenSize = screenSize,
			position = v6 and UDim2.new(0.5, 0, 1, -data.state.onScreenKeyboardHeight) or nil,
			anchorPoint = v6 and Vector2.new(0.5, 1) or nil,
			buttonStackProps = data.getButtonStackProps(),
			onCloseClicked = onCloseClickedCallback
		}
		local v14

		if data.props.useUpdatedModalDesign then
			v14 = data.getUpdatedModalMiddleContent(props, partialPageModalMiddleContentWidth)
		else
			local createElement2 = Roact.createElement
			local fitFrame = FitChildren.FitFrame
			local v15 = {
				BackgroundTransparency = 1,
				fitAxis = FitChildren.FitAxis.Height,
				Size = UDim2.new(1, 0, 0, 0)
			}
			local v16 = {
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
				Icon = not isEmailModalCalledFromHomePage and data.getIcon(v7, v8, size_1200),
				BodyText = 0,
				TextBox = 0,
				PrivacyPolicyButton = 0,
				Links = 0
			}
			local createElement3 = Roact.createElement
			local v18 = {
				LayoutOrder = 2,
				BackgroundTransparency = 1,
				Text = bodyText,
				TextSize = props.Font.Body.RelativeSize * props.Font.BaseSize,
				TextColor3 = props.Theme.TextDefault.Color,
				TextTransparency = props.Theme.TextDefault.Transparency,
				Font = 0,
				TextXAlignment = 0,
				fitAxis = 0,
				width = 0,
				TextWrapped = true,
				Size = 0
			}

			local v19 = if foundationFontFaceMigration then normalizeFontFace(props.Tokens.Typography.BodyLarge.Font) else props.Font.Body.Font
			v18.Font = v19

			v18.TextXAlignment = Enum.TextXAlignment.Center
			local v20 = if not foundationFontFaceMigration then FitChildren.FitAxis.Height else nil
			v18.fitAxis = v20
			local v21 = if foundationFontFaceMigration then UDim.new(0, partialPageModalMiddleContentWidth) else nil
			v18.width = v21

			v18.Size = UDim2.new(0, partialPageModalMiddleContentWidth, 0, 0)
			v16.BodyText = createElement3(v5, v18)

			v16.TextBox = textInputType and Roact.createElement(textInputBoxWithBorder, {
				textInputType = textInputType,
				textInputHeight = 36,
				layoutOrder = 3,
				borderState = v10,
				placeholderText = textFieldPlaceholderText,
				onChangeTextCallback = onChangeTextCallback,
				onFocused = onEmailFocused,
				labelText = textFieldLabelText,
				errorText = v9 and errorMessage,
				Size = UDim2.new(1, 0, 0, 0)
			})

			v16.PrivacyPolicyButton = data.props.shouldShowPrivacyPolicyLink()
				and Roact.createElement(linkButton, {
					text = data.props.privacyPolicyLinkText,
					onActivated = data.props.onPrivacyPolicyLinkActivated,
					layoutOrder = 4,
					fontStyle = "CaptionBody"
				})

			v16.Links = links and Roact.createElement("Frame", {
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
			v14 = createElement2(fitFrame, v15, v16)
		end

		return createElement(partialPageModal, v12, { Middle = v14 })
	end)
end

local v6 = RoactRodux.connect(function(p2, p3)
	return { screenSize = p2.ScreenSize }
end)(extended)

return function(p2)
	local v7 = useTokens()

	return React.createElement(v6, Cryo.Dictionary.join(p2, { tokens = v7 }))
end
