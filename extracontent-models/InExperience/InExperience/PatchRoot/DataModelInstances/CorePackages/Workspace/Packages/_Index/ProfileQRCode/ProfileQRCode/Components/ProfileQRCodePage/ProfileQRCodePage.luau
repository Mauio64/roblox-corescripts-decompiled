local ProfileQRCode = script:FindFirstAncestor("ProfileQRCode")
local ProfileQRCodeParent = ProfileQRCode.Parent
local React = require(ProfileQRCodeParent.React)
local UIBlox = require(ProfileQRCodeParent.UIBlox)
local Localization = require(ProfileQRCodeParent.Localization)
local ReactFocusNavigation = require(ProfileQRCodeParent.ReactFocusNavigation)
local FocusNavigationUtils = require(ProfileQRCodeParent.FocusNavigationUtils)
local Contexts = require(ProfileQRCodeParent.SocialLuaAnalytics).Analytics.Enums.Contexts
local ProfileShareLinks = require(ProfileQRCodeParent.ProfileShareLinks)
local useAppPolicy = require(ProfileQRCodeParent.UniversalAppPolicy).useAppPolicy
local useProfileShareLink = ProfileShareLinks.Hooks.useProfileShareLink
local ProfileSharePolicyEnum = ProfileShareLinks.Enums.ProfileSharePolicyEnum
local RoactUtils = require(ProfileQRCodeParent.RoactUtils)
local Button = UIBlox.App.Button.Button
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local StandardButtonSize = UIBlox.App.Button.Enum.StandardButtonSize
local VerticalScrollView = UIBlox.App.Container.VerticalScrollView
local Images = UIBlox.App.ImageSet.Images
local Foundation = require(ProfileQRCodeParent.Foundation)
local InputLabel = Foundation.InputLabel
local InputLabelSize = Foundation.Enums.InputLabelSize
local AppPage = require(ProfileQRCodeParent.RobloxAppEnums).AppPage
local NavigateDown = require(ProfileQRCodeParent.NavigationRodux).Thunks.NavigateDown
local FFlagSignalsNavP3Dispatch = require(ProfileQRCodeParent.SharedFlags).FFlagSignalsNavP3Dispatch
local v26 = if not FFlagSignalsNavP3Dispatch then nil else require(ProfileQRCodeParent.RobloxAppNavigation).NavigationCommands
local ProfileQRCodeTopElements = require(ProfileQRCode.Components.ProfileQRCodeTopElements)
local QRCodeView = require(ProfileQRCode.Components.QRCodeView)
local TextKeys = require(ProfileQRCode.Common.TextKeys)
local useIsWideMode = require(ProfileQRCodeParent.SocialCommon).Hooks.useIsWideMode
local useLocalization = Localization.Hooks.useLocalization
local useStyle = UIBlox.Core.Style.useStyle
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useFocusGuiObject = ReactFocusNavigation.useFocusGuiObject
local useLastInputMode = FocusNavigationUtils.useLastInputMode
local color3 = Color3.new(1, 1, 1)
local FFlagProfileQRCodeFixFocusNavigation = require(ProfileQRCode.Flags.FFlagProfileQRCodeFixFocusNavigation)
local FFlagQRCodeCopyUpdates = require(ProfileQRCodeParent.SharedFlags).FFlagQRCodeCopyUpdates
local FFlagConnectionsToFriendsRename = require(ProfileQRCodeParent.SharedFlags).FFlagConnectionsToFriendsRename
local FStringCanAccessTrustedContactsAmpFeature = require(ProfileQRCodeParent.SharedFlags).FStringCanAccessTrustedContactsAmpFeature
local FFlagTCPolicyCheckRedirect = require(ProfileQRCodeParent.SharedFlags).FFlagTCPolicyCheckRedirect
local FStringIsUserInTcEligibleCountryAmpFeature = require(ProfileQRCodeParent.SharedFlags).FStringIsUserInTcEligibleCountryAmpFeature
local FStringCanAccessTrustedContactsAmpNameSpace = require(ProfileQRCodeParent.SharedFlags).FStringCanAccessTrustedContactsAmpNameSpace
local AmpApiProvider = require(ProfileQRCodeParent.AmpUpsell).AmpApiProvider
local AmpEnums = require(ProfileQRCodeParent.AmpUpsell).AmpEnums

return function(t1: {[any]: any}) -- line: 85
	-- upvalues: useDispatch (copy), useAppPolicy (copy), useLocalization (copy), TextKeys (copy), FFlagQRCodeCopyUpdates (copy), FFlagConnectionsToFriendsRename (copy), React (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v26 (copy), NavigateDown (copy), FFlagProfileQRCodeFixFocusNavigation (copy), useIsWideMode (copy), useStyle (copy), useLastInputMode (copy), useFocusGuiObject (copy), useProfileShareLink (copy), Contexts (copy), ProfileSharePolicyEnum (copy), Images (copy), FFlagTCPolicyCheckRedirect (copy), FStringIsUserInTcEligibleCountryAmpFeature (copy), FStringCanAccessTrustedContactsAmpFeature (copy), AmpApiProvider (copy), FStringCanAccessTrustedContactsAmpNameSpace (copy), AmpEnums (copy), ProfileQRCodeTopElements (copy), VerticalScrollView (copy), color3 (copy), QRCodeView (copy), StyledTextLabel (copy), InputLabel (copy), InputLabelSize (copy), Button (copy), ButtonType (copy), StandardButtonSize (copy)
	local v47 = useDispatch()
	local v48 = useAppPolicy(function(p1) -- line: 88
		return p1.getWebViewSupport()
	end)
	local v49 = useLocalization({
		learnMore = "Feature.Chat.Action.LearnMore",
		description = TextKeys.ScanQRText,
		descriptionTCEducation = if not FFlagQRCodeCopyUpdates then nil else TextKeys.TrustedConnectionDescription,
		descriptionTrustedFriends = if not FFlagConnectionsToFriendsRename then nil else TextKeys.TrustedFriendsDescription,
		shareProfileLink = TextKeys.ShareProfileLink,
		copyProfileLink = TextKeys.CopyProfileLink
	})
	local v50 = React.useCallback(function() -- line: 101
		-- upvalues: AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v26 (copy), v47 (copy), NavigateDown (copy)
		local t2 = {
			detail = "https://en.help.roblox.com/hc/en-us/articles/37725513985812",
			name = AppPage.GenericWebPage,
			extraProps = {
				title = ""
			}
		}

		if FFlagSignalsNavP3Dispatch then
			v26.down(v26.fromLegacyPage(t2))

			return
		end

		v47(NavigateDown(t2, nil))
	end, { v47 })
	local v51, v52 = React.useState(false)
	local v53 = if not FFlagProfileQRCodeFixFocusNavigation then nil else React.useRef(nil)
	local v54 = useIsWideMode()
	local v55 = useStyle()
	local v56 = if not FFlagProfileQRCodeFixFocusNavigation then nil else useLastInputMode()
	local v57 = if not FFlagProfileQRCodeFixFocusNavigation then nil else useFocusGuiObject()
	local v58 = useProfileShareLink({
		context = Contexts.ProfileQRCode
	})
	local v59 = v58.policy ~= ProfileSharePolicyEnum.Disabled and v58.hasLoaded
	local shareProfileLink = nil
	local v61 = nil

	if v58.policy == ProfileSharePolicyEnum.Share then
		shareProfileLink = v49.shareProfileLink
		v61 = Images["icons/actions/share"]
	elseif v58.policy == ProfileSharePolicyEnum.Copy then
		shareProfileLink = v49.copyProfileLink
		v61 = Images["icons/menu/link"]
	end

	if FFlagProfileQRCodeFixFocusNavigation then
		React.useEffect(function() -- line: 137
			-- upvalues: v57 (copy), v53 (copy), v56 (copy)
			if v57 and (v53 and v53.current and v56 == "Focus") then
				v57(v53.current)
			end
		end, {})
	end

	local v62, v63 = React.useState(false)
	local v64, v65 = React.useState(false)

	if FFlagQRCodeCopyUpdates then
		React.useEffect(function() -- line: 148
			-- upvalues: FFlagTCPolicyCheckRedirect (copy), FStringIsUserInTcEligibleCountryAmpFeature (copy), FStringCanAccessTrustedContactsAmpFeature (copy), AmpApiProvider (copy), FStringCanAccessTrustedContactsAmpNameSpace (copy), AmpEnums (copy), v63 (copy), v65 (copy)
			local v68 = if not FFlagTCPolicyCheckRedirect then FStringCanAccessTrustedContactsAmpFeature else FStringIsUserInTcEligibleCountryAmpFeature

			if AmpApiProvider.upsellFeatureAccess(v68, {}, FStringCanAccessTrustedContactsAmpNameSpace).access == AmpEnums.AccessResponseEnum.Granted then
				v63(true)
			end

			v65(true)
		end, {})
	end

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.fromScale(1, 1)
	}, {
		TopElements = React.createElement(ProfileQRCodeTopElements, {
			appStorageService = t1.appStorageService,
			onClose = t1.onClose,
			openQrCodeScanner = t1.openQrCodeScanner,
			robloxEventReceiver = t1.robloxEventReceiver
		}),
		VerticalScrollView = React.createElement(VerticalScrollView, {
			useAutomaticCanvasSize = true,
			size = if not v54 then UDim2.new(1, 0, 1, -24) else nil,
			canvasSizeY = UDim.new(),
			position = UDim2.new(0, 0, 0, 56)
		}, {
			GradientBackground = React.createElement("Frame", {
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundColor3 = color3,
				BackgroundTransparency = not v54 and 1 or 0.7,
				Position = UDim2.fromScale(0, 0),
				Size = if not v54 then UDim2.fromScale(1, 1) else UDim2.fromScale(0.6, 1),
				BorderSizePixel = 0,
				[React.Change.AbsoluteSize] = React.useCallback(function(p2) -- line: 183
					-- upvalues: v52 (copy)
					if p2.AbsoluteSize.Y >= 450 then
						v52(true)

						return
					end

					v52(false)
				end)
			}, {
				Layout = React.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					VerticalAlignment = Enum.VerticalAlignment.Bottom
				}),
				Content = React.createElement("Frame", {
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.Y,
					Size = if not v54 then UDim2.new(1, 0, 0.5, 0) else UDim2.new(1, 0, 1, -56)
				}, {
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
					QRCodeView = React.createElement(QRCodeView, {
						layoutOrder = 1,
						isSmallScreen = v51
					}),
					Spacer1 = React.createElement("Frame", {
						BorderSizePixel = 0,
						BackgroundTransparency = 1,
						LayoutOrder = 2,
						AutomaticSize = Enum.AutomaticSize.Y,
						Size = UDim2.fromOffset(0, not v51 and 24 or 12)
					}),
					Description = if not FFlagQRCodeCopyUpdates or v64 ~= false then React.createElement(StyledTextLabel, {
						layoutOrder = 3,
						lineHeight = 1,
						fluidSizing = false,
						richText = false,
						text = if not FFlagQRCodeCopyUpdates or not v62 then v49.description else if not FFlagConnectionsToFriendsRename then v49.descriptionTCEducation else v49.descriptionTrustedFriends,
						fontStyle = v55.Font.CaptionBody,
						colorStyle = v55.Theme.TextDefault,
						size = if not FFlagQRCodeCopyUpdates or not v62 then UDim2.new(1, 0, 0, 0) else UDim2.new(0, 304, 0, 0),
						automaticSize = Enum.AutomaticSize.Y,
						textXAlignment = if not FFlagQRCodeCopyUpdates or not v62 then Enum.TextXAlignment.Center else Enum.TextXAlignment.Left,
						textYAlignment = if not FFlagQRCodeCopyUpdates or not v62 then Enum.TextYAlignment.Center else Enum.TextYAlignment.Top
					}) else React.createElement("Frame", {
						BackgroundTransparency = 1,
						LayoutOrder = 3,
						Size = UDim2.new(0, 304, 0, 45)
					}),
					LearnMoreWebLink = if not v48 then nil else if not FFlagQRCodeCopyUpdates or v64 ~= false then if not FFlagQRCodeCopyUpdates or not v62 then React.createElement(InputLabel, {
						LayoutOrder = 4,
						tag = "auto-y size-full-0",
						RichText = true,
						Text = `<u>{ v49.learnMore }</u>`,
						size = InputLabelSize.Small,
						onActivated = v50
					}) else React.createElement("Frame", {
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						LayoutOrder = 4,
						Size = UDim2.new(0, 304, 0, 0),
						AutomaticSize = Enum.AutomaticSize.Y
					}, {
						Layout = React.createElement("UIListLayout", {
							HorizontalAlignment = Enum.HorizontalAlignment.Left,
							VerticalAlignment = Enum.VerticalAlignment.Top
						}),
						LearnMoreWebLink = React.createElement(InputLabel, {
							tag = "auto-y size-full-0 text-align-x-left",
							RichText = true,
							Text = `<u>{ v49.learnMore }</u>`,
							size = InputLabelSize.Small,
							onActivated = v50
						})
					}) else React.createElement("Frame", {
						BackgroundTransparency = 1,
						LayoutOrder = 4,
						Size = UDim2.new(0, 304, 0, 15)
					}),
					ProfileShareButtonContainer = if not v59 then nil else React.createElement("Frame", {
						BorderSizePixel = 0,
						BackgroundTransparency = 1,
						LayoutOrder = 5,
						AutomaticSize = Enum.AutomaticSize.Y,
						Size = UDim2.fromScale(1, 0)
					}, {
						Layout = React.createElement("UIListLayout", {
							HorizontalAlignment = Enum.HorizontalAlignment.Center
						}),
						UIPadding = React.createElement("UIPadding", {
							PaddingTop = UDim.new(0, 24),
							PaddingBottom = UDim.new(0, 24)
						}),
						ProfileShareButton = React.createElement(Button, {
							maxWidth = 304,
							buttonType = ButtonType.PrimarySystem,
							standardSize = StandardButtonSize.Regular,
							text = shareProfileLink,
							icon = v61,
							onActivated = v58.onActivated,
							ref = if not FFlagProfileQRCodeFixFocusNavigation then nil else v53
						})
					}),
					UISizeConstraint = React.createElement("UISizeConstraint", {
						MinSize = Vector2.new(0, 420)
					})
				}),
				Gradient = React.createElement("UIGradient", {
					Rotation = 90,
					Color = ColorSequence.new({
						ColorSequenceKeypoint.new(0, v55.Theme.BackgroundContrast.Color),
						ColorSequenceKeypoint.new(1, v55.Theme.BackgroundContrast.Color)
					}),
					Transparency = NumberSequence.new({
						NumberSequenceKeypoint.new(0, 0.4),
						NumberSequenceKeypoint.new(1, 0)
					})
				})
			})
		})
	})
end
