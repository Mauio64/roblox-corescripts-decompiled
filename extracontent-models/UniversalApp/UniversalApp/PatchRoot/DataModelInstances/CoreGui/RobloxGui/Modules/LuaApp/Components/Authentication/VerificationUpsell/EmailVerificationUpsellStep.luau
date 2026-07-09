local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local LinkButton = UIBlox.App.Button.LinkButton
local PartialPageModal = UIBlox.App.Dialog.Modal.PartialPageModal
local getPartialPageModalMiddleContentWidth = UIBlox.App.Dialog.Modal.getPartialPageModalMiddleContentWidth
local AuthCommon = require(CorePackages.Workspace.Packages.AuthCommon)
local AuthStatefulRoundCornerBorder = AuthCommon.Components.AuthStatefulRoundCornerBorder
local TextInputBoxWithBorder = AuthCommon.Components.TextInputBoxWithBorder
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local GetImageData = require(CorePackages.Workspace.Packages.RobloxAppAssets).GetImageData
local Foundation = require(CorePackages.Packages.Foundation)
local useTokens = Foundation.Hooks.useTokens
local Cryo = require(CorePackages.Packages.Cryo)
local FitChildren = require(Modules.LuaApp.FitChildren)
local FitTextLabel = require(Modules.LuaApp.Components.FitTextLabel)
local GetFFlagEnableAuthsecImageUpdate = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagEnableAuthsecImageUpdate
local UserInputService = game:GetService("UserInputService")
local EmailVerificationUpsellLink = require(script.Parent.EmailVerificationUpsellLink)
local v25 = Roact.PureComponent:extend(script.Name)
local Images = UIBlox.App.ImageSet.Images
local IconSize = UIBlox.App.ImageSet.Enum.IconSize
local getIconSizeUDim2 = UIBlox.App.ImageSet.getIconSizeUDim2
local v29 = Images["icons/graphic/lock_xxlarge"]
local v30 = getIconSizeUDim2(IconSize.XLarge)

v25.defaultProps = {
	shouldShowPrivacyPolicyLink = function() -- line: 54
		return false
	end,
	primaryButtonType = ButtonType.PrimarySystem,
	secondaryButtonType = ButtonType.Secondary
}

function v25.init(p1) -- line: 61
	-- upvalues: Cryo (copy), Roact (copy), EmailVerificationUpsellLink (copy), Foundation (copy), AuthStatefulRoundCornerBorder (copy), React (copy), FitTextLabel (copy), FitChildren (copy), TextInputBoxWithBorder (copy), GetFFlagEnableAuthsecImageUpdate (copy), ImageSetLabel (copy), Images (copy), GetImageData (copy)
	p1.state = {
		onScreenKeyboardHeight = 0
	}

	function p1.getLinks() -- line: 66
		-- upvalues: Cryo (copy), p1 (copy), Roact (copy), EmailVerificationUpsellLink (copy)
		local v59 = Cryo.List.map(p1.props.links, function(p2, p3) -- line: 67
			-- upvalues: Roact (copy), EmailVerificationUpsellLink (copy)
			return Roact.createElement(EmailVerificationUpsellLink, {
				textKey = p2.textKey,
				layoutOrder = p3,
				onActivatedCallback = p2.onClicked,
				isPrimaryLink = p2.isPrimaryLink
			})
		end)

		return Roact.createFragment(v59)
	end
	function p1.getEnvelopeIconImage(s1: string) -- line: 79
		-- upvalues: Foundation (copy)
		if s1 == Foundation.Enums.Theme.Dark then
			return "icons/graphic/envelope_dark"
		end

		return "icons/graphic/envelope_light"
	end
	function p1.getButtonStackProps() -- line: 87
		-- upvalues: p1 (copy), Cryo (copy)
		local t1 = {}
		local primaryButtonText = p1.props.primaryButtonText
		local secondaryButtonText = p1.props.secondaryButtonText
		local onPrimaryButtonActivated = p1.props.onPrimaryButtonActivated
		local onSecondaryButtonActivated = p1.props.onSecondaryButtonActivated
		local primaryButtonType = p1.props.primaryButtonType
		local secondaryButtonType = p1.props.secondaryButtonType
		local isPrimaryButtonDisabled = p1.state.isPrimaryButtonDisabled

		if primaryButtonText then
			t1 = {{
				buttonType = primaryButtonType,
				props = {
					onActivated = onPrimaryButtonActivated,
					text = primaryButtonText,
					isDisabled = isPrimaryButtonDisabled
				}
			}}
		end

		if secondaryButtonText then
			local t2 = {{
				buttonType = secondaryButtonType,
				props = {
					onActivated = onSecondaryButtonActivated,
					text = secondaryButtonText
				}
			}}

			t1 = Cryo.List.join(t2, t1)
		end

		return {
			buttonHeight = 48,
			forcedFillDirection = Enum.FillDirection.Vertical,
			buttons = t1
		}
	end
	function p1.getUpdatedModalMiddleContent(p4, p5) -- line: 134
		-- upvalues: p1 (copy), AuthStatefulRoundCornerBorder (copy), React (copy), FitTextLabel (copy), FitChildren (copy), TextInputBoxWithBorder (copy), EmailVerificationUpsellLink (copy)
		local errorMessage = p1.props.errorMessage
		local v73 = errorMessage and errorMessage ~= ""
		local Default = AuthStatefulRoundCornerBorder.BorderState.Default

		return React.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		}, {
			ContentPadding = React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, 24)
			}),
			ListLayout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				Padding = UDim.new(0, 24)
			}),
			BodyText = React.createElement(FitTextLabel, {
				LayoutOrder = 2,
				BackgroundTransparency = 1,
				TextWrapped = true,
				Text = p1.props.bodyText,
				TextSize = p4.Font.Body.RelativeSize * p4.Font.BaseSize,
				TextColor3 = p4.Theme.TextDefault.Color,
				TextTransparency = p4.Theme.TextDefault.Transparency,
				Font = p4.Font.Body.Font,
				TextXAlignment = Enum.TextXAlignment.Left,
				fitAxis = FitChildren.FitAxis.Height,
				Size = UDim2.new(0, p5, 0, 0)
			}),
			TextBox = p1.props.textInputType and React.createElement(TextInputBoxWithBorder, {
				textInputHeight = 48,
				layoutOrder = 3,
				textInputType = p1.props.textInputType,
				borderState = Default,
				textBarColor = p4.Theme.BackgroundMuted.Color,
				placeholderText = p1.props.textFieldPlaceholderText,
				placeholderTextColor = p4.Theme.TextMuted.Color,
				onChangeTextCallback = p1.props.onChangeTextCallback,
				onFocused = p1.props.onEmailFocused,
				labelText = p1.props.textFieldLabelText,
				labelTextColor = p4.Theme.TextDefault.Color,
				errorText = v73 and errorMessage,
				Size = UDim2.new(1, 0, 0, 0)
			}),
			LegalLinks = if not p1.props.shouldShowPrivacyPolicyLink() then nil else React.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 4,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y
			}, {
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
				TermsButton = React.createElement(EmailVerificationUpsellLink, {
					isPrimaryLink = false,
					textPadding = 0,
					layoutOrder = 1,
					shouldUseAutomaticSize = true,
					textKey = p1.props.termsOfServiceLinkKey,
					onActivatedCallback = p1.props.onTermsOfServiceLinkActivated
				}),
				PrivacyPolicyButton = p1.props.shouldShowPrivacyPolicyLink() and React.createElement(EmailVerificationUpsellLink, {
					isPrimaryLink = false,
					textPadding = 0,
					layoutOrder = 2,
					shouldUseAutomaticSize = true,
					textKey = p1.props.privacyPolicyLinkKey,
					onActivatedCallback = p1.props.onPrivacyPolicyLinkActivated
				})
			}),
			Links = p1.props.links and React.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 5,
				Size = UDim2.new(1, 0, 0, #p1.props.links * 36)
			}, {
				LinksList = React.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					Padding = UDim.new(0, 12)
				}),
				p1.getLinks()
			})
		})
	end
	function p1.getIcon(p6, p7, p8) -- line: 232
		-- upvalues: GetFFlagEnableAuthsecImageUpdate (copy), Roact (copy), ImageSetLabel (copy), Images (copy), p1 (copy), GetImageData (copy)
		if GetFFlagEnableAuthsecImageUpdate() then
			return Roact.createElement("Frame", {
				LayoutOrder = 1,
				BackgroundTransparency = 1,
				Size = UDim2.new(0, p6, 0, p7 - p8)
			}, {
				Image = Roact.createElement(ImageSetLabel, {
					BackgroundTransparency = 1,
					LayoutOrder = 1,
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.new(0.5, 0, 0.5, 0),
					Size = UDim2.new(0, p6, 0, p7),
					ScaleType = Enum.ScaleType.Fit,
					Image = Images[p1.getEnvelopeIconImage(p1.props.tokens.Config.ColorMode.Name)]
				})
			})
		end

		return Roact.createElement(ImageSetLabel, {
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Size = UDim2.new(0, 100, 0, 100),
			ScaleType = Enum.ScaleType.Fit,
			Image = GetImageData("LuaApp/graphic/verificationUpsellModal") or "LuaApp/graphic/verificationUpsellModal"
		})
	end
end
function v25.didMount(p9) -- line: 262
	-- upvalues: UserInputService (copy)
	p9.keyboardVisibleChanged = UserInputService:GetPropertyChangedSignal("OnScreenKeyboardVisible"):connect(function() -- line: 264
		-- upvalues: UserInputService (copy), p9 (copy)
		local v78 = UserInputService.OnScreenKeyboardVisible and UserInputService.OnScreenKeyboardSize.Y or 0

		p9:setState({
			onScreenKeyboardHeight = v78
		})
	end)
end
function v25.willUnmount(p10) -- line: 274
	if p10.keyboardVisibleChanged then
		p10.keyboardVisibleChanged:disconnect()
	end

	p10.keyboardVisibleChanged = nil
end
function v25.render(p11) -- line: 281
	-- upvalues: getPartialPageModalMiddleContentWidth (copy), AuthStatefulRoundCornerBorder (copy), withStyle (copy), Roact (copy), PartialPageModal (copy), FitChildren (copy), ImageSetLabel (copy), v30 (copy), v29 (copy), FitTextLabel (copy), TextInputBoxWithBorder (copy), LinkButton (copy)
	local screenSize = p11.props.screenSize
	local v37 = getPartialPageModalMiddleContentWidth(screenSize.X)
	local v38 = p11.state.onScreenKeyboardHeight > 0
	local v39 = p11.props.tokens.Size.Size_2000 * 4
	local v40 = p11.props.tokens.Size.Size_2200 * 2
	local Size_1200 = p11.props.tokens.Size.Size_1200
	local title = p11.props.title
	local bodyText = p11.props.bodyText
	local textInputType = p11.props.textInputType
	local textFieldLabelText = p11.props.textFieldLabelText
	local textFieldPlaceholderText = p11.props.textFieldPlaceholderText
	local errorMessage = p11.props.errorMessage
	local links = p11.props.links
	local onEmailFocused = p11.props.onEmailFocused
	local onChangeTextCallback = p11.props.onChangeTextCallback
	local onCloseClickedCallback = p11.props.onCloseClickedCallback
	local isEmailModalCalledFromHomePage = p11.props.isEmailModalCalledFromHomePage
	local v53 = errorMessage and errorMessage ~= ""
	local Default = AuthStatefulRoundCornerBorder.BorderState.Default

	if v53 then
		Default = AuthStatefulRoundCornerBorder.BorderState.Error
	end

	return withStyle(function(p12) -- line: 313
		-- upvalues: Roact (copy), PartialPageModal (copy), title (copy), screenSize (copy), v38 (copy), p11 (copy), onCloseClickedCallback (copy), v37 (copy), FitChildren (copy), isEmailModalCalledFromHomePage (copy), ImageSetLabel (copy), v30 (copy), v29 (copy), v39 (copy), v40 (copy), Size_1200 (copy), FitTextLabel (copy), bodyText (copy), textInputType (copy), TextInputBoxWithBorder (copy), Default (ref), textFieldPlaceholderText (copy), onChangeTextCallback (copy), onEmailFocused (copy), textFieldLabelText (copy), v53 (copy), errorMessage (copy), LinkButton (copy), links (copy)
		return Roact.createElement(PartialPageModal, {
			title = title,
			screenSize = screenSize,
			position = v38 and UDim2.new(0.5, 0, 1, -p11.state.onScreenKeyboardHeight) or nil,
			anchorPoint = v38 and Vector2.new(0.5, 1) or nil,
			buttonStackProps = p11.getButtonStackProps(),
			onCloseClicked = onCloseClickedCallback
		}, {
			Middle = if not p11.props.useUpdatedModalDesign then Roact.createElement(FitChildren.FitFrame, {
				BackgroundTransparency = 1,
				fitAxis = FitChildren.FitAxis.Height,
				Size = UDim2.new(1, 0, 0, 0)
			}, {
				ContentPadding = Roact.createElement("UIPadding", {
					PaddingTop = UDim.new(0, 24),
					PaddingBottom = UDim.new(0, 24)
				}),
				ListLayout = Roact.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					Padding = UDim.new(0, 24)
				}),
				UIBloxLockImage = isEmailModalCalledFromHomePage and Roact.createElement(ImageSetLabel, {
					BackgroundTransparency = 1,
					LayoutOrder = 1,
					ImageTransparency = 0,
					Size = v30,
					ScaleType = Enum.ScaleType.Fit,
					Image = v29,
					ImageColor3 = p12.Theme.UIEmphasis.Color
				}),
				Icon = not isEmailModalCalledFromHomePage and p11.getIcon(v39, v40, Size_1200),
				BodyText = Roact.createElement(FitTextLabel, {
					LayoutOrder = 2,
					BackgroundTransparency = 1,
					TextWrapped = true,
					Text = bodyText,
					TextSize = p12.Font.Body.RelativeSize * p12.Font.BaseSize,
					TextColor3 = p12.Theme.TextDefault.Color,
					TextTransparency = p12.Theme.TextDefault.Transparency,
					Font = p12.Font.Body.Font,
					TextXAlignment = Enum.TextXAlignment.Center,
					fitAxis = FitChildren.FitAxis.Height,
					Size = UDim2.new(0, v37, 0, 0)
				}),
				TextBox = textInputType and Roact.createElement(TextInputBoxWithBorder, {
					textInputHeight = 36,
					layoutOrder = 3,
					textInputType = textInputType,
					borderState = Default,
					placeholderText = textFieldPlaceholderText,
					onChangeTextCallback = onChangeTextCallback,
					onFocused = onEmailFocused,
					labelText = textFieldLabelText,
					errorText = v53 and errorMessage,
					Size = UDim2.new(1, 0, 0, 0)
				}),
				PrivacyPolicyButton = p11.props.shouldShowPrivacyPolicyLink() and Roact.createElement(LinkButton, {
					layoutOrder = 4,
					fontStyle = "CaptionBody",
					text = p11.props.privacyPolicyLinkText,
					onActivated = p11.props.onPrivacyPolicyLinkActivated
				}),
				Links = links and Roact.createElement("Frame", {
					BackgroundTransparency = 1,
					LayoutOrder = 5,
					Size = UDim2.new(1, 0, 0, #links * 36)
				}, {
					LinksList = Roact.createElement("UIListLayout", {
						SortOrder = Enum.SortOrder.LayoutOrder,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						Padding = UDim.new(0, 12)
					}),
					TopPadding = Roact.createElement("UIPadding", {
						PaddingTop = UDim.new(0, 24)
					}),
					p11.getLinks()
				})
			}) else p11.getUpdatedModalMiddleContent(p12, v37)
		})
	end)
end

local v31 = RoactRodux.connect(function(p13, _) -- line: 410
	return {
		screenSize = p13.ScreenSize
	}
end)(v25)

return function(p15) -- line: 417
	-- upvalues: useTokens (copy), React (copy), v31 (copy), Cryo (copy)
	local v58 = useTokens()

	return React.createElement(v31, Cryo.Dictionary.join(p15, {
		tokens = v58
	}))
end
