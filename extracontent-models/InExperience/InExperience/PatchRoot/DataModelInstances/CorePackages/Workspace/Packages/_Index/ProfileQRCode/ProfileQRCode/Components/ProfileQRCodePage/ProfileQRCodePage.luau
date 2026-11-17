local ProfileQRCode = script:FindFirstAncestor("ProfileQRCode")
local parent = ProfileQRCode.Parent

local React = require(parent.React)
local UIBlox = require(parent.UIBlox)
local Localization = require(parent.Localization)
local ReactFocusNavigation = require(parent.ReactFocusNavigation)
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local SocialLuaAnalytics = require(parent.SocialLuaAnalytics)
local Contexts = SocialLuaAnalytics.Analytics.Enums.Contexts
local ProfileShareLinks = require(parent.ProfileShareLinks)
local UniversalAppPolicy = require(parent.UniversalAppPolicy)
local useAppPolicy = UniversalAppPolicy.useAppPolicy
local useProfileShareLink = ProfileShareLinks.Hooks.useProfileShareLink
local ProfileSharePolicyEnum = ProfileShareLinks.Enums.ProfileSharePolicyEnum
local RoactUtils = require(parent.RoactUtils)
local AppBlox = require(parent.AppBlox)
local useCloseWithBackButton = AppBlox.useCloseWithBackButton

local Button = UIBlox.App.Button.Button
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local StandardButtonSize = UIBlox.App.Button.Enum.StandardButtonSize
local VerticalScrollView = UIBlox.App.Container.VerticalScrollView

local Images = UIBlox.App.ImageSet.Images

local Foundation = require(parent.Foundation)
local InputLabel = Foundation.InputLabel
local InputLabelSize = Foundation.Enums.InputLabelSize

local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local NavigationRodux = require(parent.NavigationRodux)
local NavigateDown = NavigationRodux.Thunks.NavigateDown
local SharedFlags = require(parent.SharedFlags)
local FFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local navigationCommands

if FFlagSignalsNavP3Dispatch then
	local RobloxAppNavigation = require(parent.RobloxAppNavigation)
	navigationCommands = RobloxAppNavigation.NavigationCommands
else
	navigationCommands = nil
end

local ProfileQRCodeTopElements = require(ProfileQRCode.Components.ProfileQRCodeTopElements)
local QRCodeView = require(ProfileQRCode.Components.QRCodeView)
local TextKeys = require(ProfileQRCode.Common.TextKeys)
local SocialCommon = require(parent.SocialCommon)
local useIsWideMode = SocialCommon.Hooks.useIsWideMode

local useLocalization = Localization.Hooks.useLocalization
local useStyle = UIBlox.Core.Style.useStyle
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useFocusGuiObject = ReactFocusNavigation.useFocusGuiObject
local useLastInputMode = FocusNavigationUtils.useLastInputMode

local color = Color3.new(1, 1, 1)

local FFlagProfileQRCodeFixFocusNavigation = require(ProfileQRCode.Flags.FFlagProfileQRCodeFixFocusNavigation)
local FFlagProfileQRCodeGamepadBackFix = require(ProfileQRCode.Flags.FFlagProfileQRCodeGamepadBackFix)
local SharedFlags2 = require(parent.SharedFlags)
local FFlagQRCodeCopyUpdates = SharedFlags2.FFlagQRCodeCopyUpdates
local SharedFlags3 = require(parent.SharedFlags)
local FFlagQRCodePageVisualRefresh = SharedFlags3.FFlagQRCodePageVisualRefresh
local SharedFlags4 = require(parent.SharedFlags)
local FStringCanAccessTrustedContactsAmpFeature = SharedFlags4.FStringCanAccessTrustedContactsAmpFeature
local SharedFlags5 = require(parent.SharedFlags)
local FFlagTCPolicyCheckRedirect = SharedFlags5.FFlagTCPolicyCheckRedirect
local SharedFlags6 = require(parent.SharedFlags)
local FStringIsUserInTcEligibleCountryAmpFeature = SharedFlags6.FStringIsUserInTcEligibleCountryAmpFeature
local SharedFlags7 = require(parent.SharedFlags)
local FStringCanAccessTrustedContactsAmpNameSpace = SharedFlags7.FStringCanAccessTrustedContactsAmpNameSpace
local AmpUpsell = require(parent.AmpUpsell)
local AmpApiProvider = AmpUpsell.AmpApiProvider
local AmpUpsell2 = require(parent.AmpUpsell)
local AmpEnums = AmpUpsell2.AmpEnums

return function(props)
	local v = useDispatch()

	local v2 = useAppPolicy(function(p)
		return p.getWebViewSupport()
	end)

	local v3 = useLocalization({
		description = TextKeys.ScanQRText,
		descriptionTrustedFriends = TextKeys.TrustedFriendsDescription,
		shareProfileLink = TextKeys.ShareProfileLink,
		copyProfileLink = TextKeys.CopyProfileLink,
		learnMore = "Feature.Chat.Action.LearnMore"
	})

	local onActivated = React.useCallback(function()
		local v4 = {
			name = AppPage.GenericWebPage,
			detail = "https://en.help.roblox.com/hc/en-us/articles/37725513985812",
			extraProps = { title = "" }
		}

		if FFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v4))
		else
			v(NavigateDown(v4, nil))
		end
	end, { v })

	local state, setState = React.useState(false)
	local ref

	if FFlagProfileQRCodeFixFocusNavigation then
		ref = React.useRef(nil)
	else
		ref = nil
	end

	local v4 = useIsWideMode()
	local v5 = useStyle()
	local v6

	if FFlagProfileQRCodeFixFocusNavigation then
		v6 = useLastInputMode()
	else
		v6 = nil
	end

	local v7

	if FFlagProfileQRCodeFixFocusNavigation then
		v7 = useFocusGuiObject()
	else
		v7 = nil
	end

	local ref2

	if FFlagProfileQRCodeGamepadBackFix then
		ref2 = useCloseWithBackButton(nil, props.onClose)
	end

	local v8 = useProfileShareLink({ context = Contexts.ProfileQRCode })
	local v9

	if v8.policy == ProfileSharePolicyEnum.Disabled then
		v9 = false
	else
		v9 = v8.hasLoaded
	end

	local text = nil
	local icon = nil

	if v8.policy == ProfileSharePolicyEnum.Share then
		text = v3.shareProfileLink
		icon = Images["icons/actions/share"]
	elseif v8.policy == ProfileSharePolicyEnum.Copy then
		text = v3.copyProfileLink
		icon = Images["icons/menu/link"]
	end

	if FFlagProfileQRCodeFixFocusNavigation then
		React.useEffect(function()
			if v7 and ref and ref.current and v6 == "Focus" then
				v7(ref.current)
			end
		end, {})
	end

	local state2, setState2 = React.useState(false)
	local state3, setState3 = React.useState(false)

	if FFlagQRCodeCopyUpdates then
		React.useEffect(function()
			local v10

			if FFlagTCPolicyCheckRedirect then
				v10 = FStringIsUserInTcEligibleCountryAmpFeature
			else
				v10 = FStringCanAccessTrustedContactsAmpFeature
			end

			if AmpApiProvider.upsellFeatureAccess(v10, {}, FStringCanAccessTrustedContactsAmpNameSpace).access == AmpEnums.AccessResponseEnum.Granted then
				setState2(true)
			end

			setState3(true)
		end, {})
	end

	local createElement = React.createElement
	local v10 = {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ref = ref2
	}
	local widePanel

	if FFlagQRCodePageVisualRefresh and v4 then
		widePanel = React.createElement(Foundation.View, {
			tag = "bg-over-media-100",
			Size = UDim2.fromScale(0.6, 1),
			ZIndex = 0
		})
	end

	local children = {
		WidePanel = widePanel,
		TopElements = React.createElement(ProfileQRCodeTopElements, {
			appStorageService = props.appStorageService,
			onClose = props.onClose,
			openQrCodeScanner = props.openQrCodeScanner,
			robloxEventReceiver = props.robloxEventReceiver
		}),
		VerticalScrollView = 0
	}

	local createElement2 = React.createElement
	local size

	if not v4 then
		size = UDim2.new(1, 0, 1, -24)
	end

	local v11 = {
		useAutomaticCanvasSize = true,
		size = size,
		canvasSizeY = UDim.new(),
		position = UDim2.new(0, 0, 0, 56)
	}

	local createElement3 = React.createElement
	local v12 = {}
	v12.AutomaticSize = Enum.AutomaticSize.Y
	v12.BackgroundColor3 = color
	v12.BackgroundTransparency = v4 and not FFlagQRCodePageVisualRefresh and 0.7 or 1
	v12.Position = UDim2.fromScale(0, 0)
	local size2

	if v4 then
		size2 = UDim2.fromScale(0.6, 1)
	else
		size2 = UDim2.fromScale(1, 1)
	end

	v12.Size = size2
	v12.BorderSizePixel = 0
	v12[React.Change.AbsoluteSize] = React.useCallback(function(p)
		if p.AbsoluteSize.Y >= 450 then
			setState(true)
		else
			setState(false)
		end
	end)
	local children2 = {
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Bottom
		}),
		Content = 0,
		Gradient = 0
	}

	local createElement4 = React.createElement
	local v13 = {
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		Size = 0,
		BorderSizePixel = 0
	}
	local size3

	if v4 then
		size3 = UDim2.new(1, 0, 1, -56)
	else
		size3 = UDim2.new(1, 0, 0.5, 0)
	end

	v13.Size = size3

	local v14 = {
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		Padding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, 24),
			PaddingRight = UDim.new(0, 24),
			PaddingBottom = UDim.new(0, 24),
			PaddingLeft = UDim.new(0, 24)
		}),
		QRCodeView = React.createElement(QRCodeView, { layoutOrder = 1, isSmallScreen = state }),
		Spacer1 = React.createElement("Frame", {
			AutomaticSize = Enum.AutomaticSize.Y,
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			Size = UDim2.fromOffset(0, state and 12 or 24),
			LayoutOrder = 2
		}),
		Description = 0,
		LearnMoreWebLink = 0,
		ProfileShareButtonContainer = 0,
		UISizeConstraint = 0
	}
	local description

	if FFlagQRCodeCopyUpdates and state3 == false then
		description = React.createElement("Frame", {
			Size = UDim2.new(0, 304, 0, 45),
			BackgroundTransparency = 1,
			LayoutOrder = 3
		})
	else
		local createElement5 = React.createElement
		local text2

		if FFlagQRCodeCopyUpdates and state2 then
			text2 = v3.descriptionTrustedFriends
		else
			text2 = v3.description
		end

		local v15 = {
			layoutOrder = 3,
			text = text2,
			fontStyle = v5.Font.CaptionBody,
			lineHeight = 1,
			colorStyle = v5.Theme.TextDefault,
			size = 0,
			automaticSize = 0,
			textXAlignment = 0,
			textYAlignment = 0,
			fluidSizing = false,
			richText = false
		}
		local size4

		if FFlagQRCodeCopyUpdates and state2 then
			size4 = UDim2.new(0, 304, 0, 0)
		else
			size4 = UDim2.new(1, 0, 0, 0)
		end

		v15.size = size4

		v15.automaticSize = Enum.AutomaticSize.Y
		local textXAlignment

		if FFlagQRCodeCopyUpdates and state2 then
			textXAlignment = Enum.TextXAlignment.Left
		else
			textXAlignment = Enum.TextXAlignment.Center
		end

		v15.textXAlignment = textXAlignment
		local textYAlignment

		if FFlagQRCodeCopyUpdates and state2 then
			textYAlignment = Enum.TextYAlignment.Top
		else
			textYAlignment = Enum.TextYAlignment.Center
		end

		v15.textYAlignment = textYAlignment
		description = createElement5(StyledTextLabel, v15)
	end

	v14.Description = description
	local learnMoreWebLink

	if v2 then
		if FFlagQRCodeCopyUpdates and state3 == false then
			learnMoreWebLink = React.createElement("Frame", {
				Size = UDim2.new(0, 304, 0, 15),
				BackgroundTransparency = 1,
				LayoutOrder = 4
			})
		elseif FFlagQRCodeCopyUpdates and state2 then
			learnMoreWebLink = React.createElement("Frame", {
				Size = UDim2.new(0, 304, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				LayoutOrder = 4
			}, {
				Layout = React.createElement("UIListLayout", {
					HorizontalAlignment = Enum.HorizontalAlignment.Left,
					VerticalAlignment = Enum.VerticalAlignment.Top
				}),
				LearnMoreWebLink = React.createElement(InputLabel, {
					tag = "auto-y size-full-0 text-align-x-left",
					RichText = true,
					Text = `<u>{v3.learnMore}</u>`,
					size = InputLabelSize.Small,
					onActivated = onActivated
				})
			})
		else
			learnMoreWebLink = React.createElement(InputLabel, {
				LayoutOrder = 4,
				tag = "auto-y size-full-0",
				RichText = true,
				Text = `<u>{v3.learnMore}</u>`,
				size = InputLabelSize.Small,
				onActivated = onActivated
			})
		end
	end

	v14.LearnMoreWebLink = learnMoreWebLink
	local profileShareButtonContainer

	if v9 then
		local createElement5 = React.createElement
		local v15 = {
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.fromScale(1, 0),
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			LayoutOrder = 5
		}

		local v16 = {
			Layout = React.createElement("UIListLayout", {
				HorizontalAlignment = Enum.HorizontalAlignment.Center
			}),
			UIPadding = React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, 24),
				PaddingBottom = UDim.new(0, 24)
			}),
			ProfileShareButton = 0
		}

		local createElement6 = React.createElement
		local v17 = {
			buttonType = ButtonType.PrimarySystem,
			standardSize = StandardButtonSize.Regular,
			text = text,
			icon = icon,
			maxWidth = 304,
			onActivated = v8.onActivated,
			ref = 0
		}
		local ref3

		if FFlagProfileQRCodeFixFocusNavigation then
			ref3 = ref
		end

		v17.ref = ref3
		v16.ProfileShareButton = createElement6(Button, v17)
		profileShareButtonContainer = createElement5("Frame", v15, v16)
	end

	v14.ProfileShareButtonContainer = profileShareButtonContainer

	v14.UISizeConstraint = React.createElement("UISizeConstraint", { MinSize = Vector2.new(0, 420) })
	children2.Content = createElement4("Frame", v13, v14)

	children2.Gradient = React.createElement("UIGradient", {
		Rotation = 90,
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, v5.Theme.BackgroundContrast.Color),
			ColorSequenceKeypoint.new(1, v5.Theme.BackgroundContrast.Color)
		}),
		Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.4), NumberSequenceKeypoint.new(1, 0) })
	})
	children.VerticalScrollView = createElement2(VerticalScrollView, v11, {
		GradientBackground = createElement3("Frame", v12, children2)
	})
	return createElement("Frame", v10, children)
end
