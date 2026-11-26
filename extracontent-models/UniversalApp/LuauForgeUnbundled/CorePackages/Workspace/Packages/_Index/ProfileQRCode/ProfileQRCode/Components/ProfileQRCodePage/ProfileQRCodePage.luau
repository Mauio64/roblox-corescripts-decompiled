local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileQRCode/React")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileQRCode/UIBlox")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileQRCode/Localization")
local ReactFocusNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileQRCode/ReactFocusNavigation")
local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileQRCode/FocusNavigationUtils")
local contexts = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileQRCode/SocialLuaAnalytics").Analytics.Enums.Contexts
local ProfileShareLinks = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileQRCode/ProfileShareLinks")
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileQRCode/UniversalAppPolicy").useAppPolicy
local useProfileShareLink = ProfileShareLinks.Hooks.useProfileShareLink
local profileSharePolicyEnum = ProfileShareLinks.Enums.ProfileSharePolicyEnum
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileQRCode/RoactUtils")
local useCloseWithBackButton = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileQRCode/AppBlox").useCloseWithBackButton

local button = UIBlox.App.Button.Button
local styledTextLabel = UIBlox.App.Text.StyledTextLabel
local buttonType = UIBlox.App.Button.Enum.ButtonType
local standardButtonSize = UIBlox.App.Button.Enum.StandardButtonSize
local verticalScrollView = UIBlox.App.Container.VerticalScrollView

local images = UIBlox.App.ImageSet.Images

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileQRCode/Foundation")
local inputLabel = Foundation.InputLabel
local inputLabelSize = Foundation.Enums.InputLabelSize

local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileQRCode/RobloxAppEnums").AppPage
local navigateDown = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileQRCode/NavigationRodux").Thunks.NavigateDown
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileQRCode/SharedFlags").FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileQRCode/RobloxAppNavigation").NavigationCommands else nil

local ProfileQRCodeTopElements = require("@game/CorePackages/Workspace/Packages/_Index/ProfileQRCode/ProfileQRCode/Components/ProfileQRCodeTopElements")
local module10 = require("@game/CorePackages/Workspace/Packages/_Index/ProfileQRCode/ProfileQRCode/Components/QRCodeView")
local TextKeys = require("@game/CorePackages/Workspace/Packages/_Index/ProfileQRCode/ProfileQRCode/Common/TextKeys")
local useIsWideMode = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileQRCode/SocialCommon").Hooks.useIsWideMode

local useLocalization = Localization.Hooks.useLocalization
local useStyle = UIBlox.Core.Style.useStyle
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useFocusGuiObject = ReactFocusNavigation.useFocusGuiObject
local useLastInputMode = FocusNavigationUtils.useLastInputMode

local color = Color3.new(1, 1, 1)

local FFlagProfileQRCodeFixFocusNavigation = require("@game/CorePackages/Workspace/Packages/_Index/ProfileQRCode/ProfileQRCode/Flags/FFlagProfileQRCodeFixFocusNavigation")
local FFlagProfileQRCodeGamepadBackFix = require("@game/CorePackages/Workspace/Packages/_Index/ProfileQRCode/ProfileQRCode/Flags/FFlagProfileQRCodeGamepadBackFix")
local fFlagQRCodeCopyUpdates = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileQRCode/SharedFlags").FFlagQRCodeCopyUpdates
local fFlagQRCodePageVisualRefresh = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileQRCode/SharedFlags").FFlagQRCodePageVisualRefresh
local fStringCanAccessTrustedContactsAmpFeature = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileQRCode/SharedFlags").FStringCanAccessTrustedContactsAmpFeature
local fFlagTCPolicyCheckRedirect = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileQRCode/SharedFlags").FFlagTCPolicyCheckRedirect
local fStringIsUserInTcEligibleCountryAmpFeature = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileQRCode/SharedFlags").FStringIsUserInTcEligibleCountryAmpFeature
local fStringCanAccessTrustedContactsAmpNameSpace = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileQRCode/SharedFlags").FStringCanAccessTrustedContactsAmpNameSpace
local ampApiProvider = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileQRCode/AmpUpsell").AmpApiProvider
local ampEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileQRCode/AmpUpsell").AmpEnums

return function(props)
	local v5 = useDispatch()

	local v6 = useAppPolicy(function(p2)
		return p2.getWebViewSupport()
	end)

	local v7 = useLocalization({
		description = TextKeys.ScanQRText,
		descriptionTrustedFriends = TextKeys.TrustedFriendsDescription,
		shareProfileLink = TextKeys.ShareProfileLink,
		copyProfileLink = TextKeys.CopyProfileLink,
		learnMore = "Feature.Chat.Action.LearnMore"
	})

	local v8 = React.useCallback(function()
		local v9 = {
			name = appPage.GenericWebPage,
			detail = "https://en.help.roblox.com/hc/en-us/articles/37725513985812",
			extraProps = { title = "" }
		}

		if fFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v9))
		else
			v5(navigateDown(v9, nil))
		end
	end, { v5 })

	local state, setState = React.useState(false)
	local ref = if FFlagProfileQRCodeFixFocusNavigation then React.useRef(nil) else nil
	local v9 = useIsWideMode()
	local v10 = useStyle()
	local v11 = if FFlagProfileQRCodeFixFocusNavigation then useLastInputMode() else nil
	local v12 = if FFlagProfileQRCodeFixFocusNavigation then useFocusGuiObject() else nil
	local v13 = if FFlagProfileQRCodeGamepadBackFix then useCloseWithBackButton(nil, props.onClose) else nil

	local v14 = useProfileShareLink({ context = contexts.ProfileQRCode })
	local v15 = not (v14.policy == profileSharePolicyEnum.Disabled) and v14.hasLoaded

	local v16 = nil
	local v17 = nil

	if v14.policy == profileSharePolicyEnum.Share then
		v16 = v7.shareProfileLink
		v17 = images["icons/actions/share"]
	elseif v14.policy == profileSharePolicyEnum.Copy then
		v16 = v7.copyProfileLink
		v17 = images["icons/menu/link"]
	end

	if FFlagProfileQRCodeFixFocusNavigation then
		React.useEffect(function()
			if v12 and ref and ref.current and v11 == "Focus" then
				v12(ref.current)
			end
		end, {})
	end

	local state2, setState2 = React.useState(false)
	local state3, setState3 = React.useState(false)

	if fFlagQRCodeCopyUpdates then
		React.useEffect(function()
			local v18

			if fFlagTCPolicyCheckRedirect then
				v18 = fStringIsUserInTcEligibleCountryAmpFeature
			else
				v18 = fStringCanAccessTrustedContactsAmpFeature
			end

			if ampApiProvider.upsellFeatureAccess(v18, {}, fStringCanAccessTrustedContactsAmpNameSpace).access == ampEnums.AccessResponseEnum.Granted then
				setState2(true)
			end

			setState3(true)
		end, {})
	end

	local createElement = React.createElement
	local v19 = {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ref = v13
	}

	local v20 = if fFlagQRCodePageVisualRefresh and v9 then React.createElement(Foundation.View, {
		tag = "bg-over-media-100",
		Size = UDim2.fromScale(0.6, 1),
		ZIndex = 0
	}) else nil
	local children = {
		WidePanel = v20,
		TopElements = React.createElement(ProfileQRCodeTopElements, {
			appStorageService = props.appStorageService,
			onClose = props.onClose,
			openQrCodeScanner = props.openQrCodeScanner,
			robloxEventReceiver = props.robloxEventReceiver
		}),
		VerticalScrollView = 0
	}

	local createElement2 = React.createElement

	local v23 = if not v9 then UDim2.new(1, 0, 1, -24) else nil
	local v22 = {
		useAutomaticCanvasSize = true,
		size = v23,
		canvasSizeY = UDim.new(),
		position = UDim2.new(0, 0, 0, 56)
	}

	local createElement3 = React.createElement
	local v26 = {}
	v26.AutomaticSize = Enum.AutomaticSize.Y
	v26.BackgroundColor3 = color
	v26.BackgroundTransparency = v9 and not fFlagQRCodePageVisualRefresh and 0.7 or 1
	v26.Position = UDim2.fromScale(0, 0)
	local v27 = if v9 then UDim2.fromScale(0.6, 1) else UDim2.fromScale(1, 1)
	v26.Size = v27
	v26.BorderSizePixel = 0
	v26[React.Change.AbsoluteSize] = React.useCallback(function(p2)
		if p2.AbsoluteSize.Y >= 450 then
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
	local v29 = {
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		Size = 0,
		BorderSizePixel = 0
	}

	local v30 = if v9 then UDim2.new(1, 0, 1, -56) else UDim2.new(1, 0, 0.5, 0)
	v29.Size = v30

	local v31 = {
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
		QRCodeView = React.createElement(module10, {
			layoutOrder = 1,
			isSmallScreen = state
		}),
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
	local v32

	if fFlagQRCodeCopyUpdates and state3 == false then
		v32 = React.createElement("Frame", {
			Size = UDim2.new(0, 304, 0, 45),
			BackgroundTransparency = 1,
			LayoutOrder = 3
		})
	else
		local createElement5 = React.createElement

		local v35 = if fFlagQRCodeCopyUpdates and state2 then v7.descriptionTrustedFriends else v7.description
		local v34 = {
			layoutOrder = 3,
			text = v35,
			fontStyle = v10.Font.CaptionBody,
			lineHeight = 1,
			colorStyle = v10.Theme.TextDefault,
			size = 0,
			automaticSize = 0,
			textXAlignment = 0,
			textYAlignment = 0,
			fluidSizing = false,
			richText = false
		}

		local v36 = if fFlagQRCodeCopyUpdates and state2 then UDim2.new(0, 304, 0, 0) else UDim2.new(1, 0, 0, 0)
		v34.size = v36

		v34.automaticSize = Enum.AutomaticSize.Y

		local v37 = if fFlagQRCodeCopyUpdates and state2 then Enum.TextXAlignment.Left else Enum.TextXAlignment.Center
		v34.textXAlignment = v37

		local v38 = if fFlagQRCodeCopyUpdates and state2 then Enum.TextYAlignment.Top else Enum.TextYAlignment.Center
		v34.textYAlignment = v38
		v32 = createElement5(styledTextLabel, v34)
	end

	v31.Description = v32
	local v33

	if v6 then
		if fFlagQRCodeCopyUpdates and state3 == false then
			v33 = React.createElement("Frame", {
				Size = UDim2.new(0, 304, 0, 15),
				BackgroundTransparency = 1,
				LayoutOrder = 4
			})
		elseif fFlagQRCodeCopyUpdates and state2 then
			v33 = React.createElement("Frame", {
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
				LearnMoreWebLink = React.createElement(inputLabel, {
					tag = "auto-y size-full-0 text-align-x-left",
					RichText = true,
					Text = `<u>{v7.learnMore}</u>`,
					size = inputLabelSize.Small,
					onActivated = v8
				})
			})
		else
			v33 = React.createElement(inputLabel, {
				LayoutOrder = 4,
				tag = "auto-y size-full-0",
				RichText = true,
				Text = `<u>{v7.learnMore}</u>`,
				size = inputLabelSize.Small,
				onActivated = v8
			})
		end
	end

	v31.LearnMoreWebLink = v33
	local v34

	if v15 then
		v34 = React.createElement("Frame", {
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.fromScale(1, 0),
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			LayoutOrder = 5
		}, {
			Layout = React.createElement("UIListLayout", {
				HorizontalAlignment = Enum.HorizontalAlignment.Center
			}),
			UIPadding = React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, 24),
				PaddingBottom = UDim.new(0, 24)
			}),
			ProfileShareButton = React.createElement(button, {
				buttonType = buttonType.PrimarySystem,
				standardSize = standardButtonSize.Regular,
				text = v16,
				icon = v17,
				maxWidth = 304,
				onActivated = v14.onActivated,
				ref = if FFlagProfileQRCodeFixFocusNavigation then ref else nil
			})
		})
	end

	v31.ProfileShareButtonContainer = v34

	v31.UISizeConstraint = React.createElement("UISizeConstraint", {
		MinSize = Vector2.new(0, 420)
	})
	children2.Content = createElement4("Frame", v29, v31)

	children2.Gradient = React.createElement("UIGradient", {
		Rotation = 90,
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, v10.Theme.BackgroundContrast.Color),
			ColorSequenceKeypoint.new(1, v10.Theme.BackgroundContrast.Color)
		}),
		Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0.4),
			NumberSequenceKeypoint.new(1, 0)
		})
	})
	children.VerticalScrollView = createElement2(verticalScrollView, v22, {
		GradientBackground = createElement3("Frame", v26, children2)
	})
	return createElement("Frame", v19, children)
end
