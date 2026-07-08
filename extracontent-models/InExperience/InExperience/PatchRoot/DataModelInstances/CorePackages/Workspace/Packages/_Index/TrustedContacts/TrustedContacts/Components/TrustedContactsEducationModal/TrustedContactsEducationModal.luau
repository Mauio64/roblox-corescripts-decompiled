local Parent = script:FindFirstAncestor("TrustedContacts").Parent
local React = require(Parent.React)
local UIBlox = require(Parent.UIBlox)
local PartialPageModal = UIBlox.App.Dialog.Modal.PartialPageModal
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local useScreenSize = require(Parent.RobloxAppHooks).useScreenSize
local useNavigation = require(Parent.Navigation).useNavigation
local useLocalization = require(Parent.Localization).Hooks.useLocalization
local AppPage = require(Parent.RobloxAppEnums).AppPage
local Foundation = require(Parent.Foundation)
local Skeleton = Foundation.Skeleton
local FoundationText = Foundation.Text
local Icon = Foundation.Icon
local IconSize = Foundation.Enums.IconSize
local useTokens = Foundation.Hooks.useTokens
local AmpApiProvider = require(Parent.AmpUpsell).AmpApiProvider
local AccessResponseEnum = require(Parent.AmpUpsell).AmpEnums.AccessResponseEnum
local Analytics = require(script.Parent.Parent.Parent.Analytics)
local useTCAnalytics = Analytics.useTCAnalytics
local EventNames = Analytics.EventNames
local FStringCanAccessTrustedContactsAmpNameSpace = require(Parent.SharedFlags).FStringCanAccessTrustedContactsAmpNameSpace
local FStringIsVerified18PlusAmpFeature = require(Parent.SharedFlags).FStringIsVerified18PlusAmpFeature
local FFlagCreateConnectionsHub = require(Parent.SharedFlags).FFlagCreateConnectionsHub
local v24 = game:DefineFastFlag("ConsoleFriendsPageNavigation", false)
local FFlagConnectionsToFriendsRename = require(Parent.SharedFlags).FFlagConnectionsToFriendsRename

local function TextWithIcon(t1: {[any]: any}) -- line: 39
	-- upvalues: React (copy), Icon (copy), IconSize (copy), FoundationText (copy)
	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.fromScale(1, 0),
		LayoutOrder = t1.layoutOrder
	}, {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, t1.iconPadding),
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Center
		}),
		Icon = React.createElement(Icon, {
			LayoutOrder = 1,
			name = t1.icon,
			size = IconSize.Small
		}),
		Text = React.createElement(FoundationText, {
			tag = "auto-y grow size-full-0 text-align-x-left text-wrap",
			LayoutOrder = 2,
			Text = t1.text
		})
	})
end
local function TrustedContactsEducationModal(_: {[any]: any}) -- line: 66
	-- upvalues: useScreenSize (copy), useNavigation (copy), useTokens (copy), React (copy), AccessResponseEnum (copy), AmpApiProvider (copy), FStringIsVerified18PlusAmpFeature (copy), FStringCanAccessTrustedContactsAmpNameSpace (copy), useTCAnalytics (copy), EventNames (copy), FFlagCreateConnectionsHub (copy), AppPage (copy), v24 (copy), useLocalization (copy), FFlagConnectionsToFriendsRename (copy), PartialPageModal (copy), ButtonType (copy), Skeleton (copy), FoundationText (copy), TextWithIcon (copy)
	local v30 = useScreenSize()
	local v31 = useNavigation()
	local v32 = useTokens()
	local v33, v34 = React.useState(AccessResponseEnum.Pending)

	React.useEffect(function() -- line: 72
		-- upvalues: AmpApiProvider (copy), FStringIsVerified18PlusAmpFeature (copy), FStringCanAccessTrustedContactsAmpNameSpace (copy), v34 (copy)
		local v40 = AmpApiProvider.upsellFeatureAccess(FStringIsVerified18PlusAmpFeature, {}, FStringCanAccessTrustedContactsAmpNameSpace)

		v34(v40.access)
	end, {})

	local fireAnalyticsEvent = useTCAnalytics().fireAnalyticsEvent

	React.useEffect(function() -- line: 79
		-- upvalues: fireAnalyticsEvent (copy), EventNames (copy)
		fireAnalyticsEvent(EventNames.TCEducationModalSeen)
	end, {})

	local v36 = React.useCallback(function() -- line: 83
		-- upvalues: fireAnalyticsEvent (copy), EventNames (copy), v31 (copy)
		fireAnalyticsEvent(EventNames.TCEducationCloseClicked)
		v31.pop()
	end, { v31 })
	local v37 = React.useCallback(function() -- line: 88
		-- upvalues: fireAnalyticsEvent (copy), EventNames (copy), v31 (copy)
		fireAnalyticsEvent(EventNames.TCEducationGotItClicked)
		v31.pop()
	end, { v31 })
	local v38 = React.useCallback(function() -- line: 93
		-- upvalues: fireAnalyticsEvent (copy), EventNames (copy), FFlagCreateConnectionsHub (copy), v31 (copy), AppPage (copy), v24 (copy)
		fireAnalyticsEvent(EventNames.TCEducationManageConnectionsClicked)

		if FFlagCreateConnectionsHub then
			v31.navigate(AppPage.CoHubMyConnections)

			return
		end

		if v24 then
			v31.navigate(AppPage.ViewFriends)

			return
		end

		v31.replace(AppPage.ViewFriends)
	end, { v31 })
	local v39 = useLocalization({
		title = "Feature.Friends.TCEducation.Title",
		textChatWithoutFilters = "Feature.Friends.TCFeature.ChatWithoutFilters",
		textPartyVoice = "Feature.Friends.TCFeature.PartyVoice",
		textAndMore = "Feature.Friends.TCFeature.AndMore",
		buttonManage = "Feature.Avatar.Heading.Manage",
		buttonGotIt = "Feature.Friends.Button.GotIt",
		textIntro = not FFlagConnectionsToFriendsRename and "Feature.Friends.TCEducation.Modal.TextIntro" or "Feature.Friends.TFEducation.Modal.TextIntro",
		textIntro18Plus = not FFlagConnectionsToFriendsRename and "Feature.Friends.TCEducation.Modal.TextIntro.EighteenPlus" or "Feature.Friends.TFEducation.Modal.TextIntro.EighteenPlus",
		textOutro = not FFlagConnectionsToFriendsRename and "Feature.Friends.TCEducation.Modal.TextOutro" or "Feature.Friends.TFEducation.Modal.TextOutro",
		textOutro18Plus = not FFlagConnectionsToFriendsRename and "Feature.Friends.TCEducation.Modal.TextOutro.EighteenPlus" or "Feature.Friends.TFEducation.Modal.TextOutro.EighteenPlus"
	})

	return React.createElement(PartialPageModal, {
		title = v39.title,
		screenSize = v30,
		onCloseClicked = v36,
		buttonStackProps = {
			buttons = {
				{
					buttonType = ButtonType.PrimaryContextual,
					props = {
						onActivated = v37,
						text = v39.buttonGotIt
					}
				},
				{
					buttonType = ButtonType.Secondary,
					props = {
						onActivated = v38,
						text = v39.buttonManage
					}
				}
			},
			forcedFillDirection = Enum.FillDirection.Horizontal
		}
	}, {
		ViewContainer = React.createElement("Frame", {
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.fromScale(1, 0)
		}, {
			UIListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Center
			}),
			TextContainer = React.createElement("Frame", {
				LayoutOrder = 2,
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.fromScale(1, 0)
			}, {
				UIListLayout = React.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, v32.Padding.Large),
					HorizontalAlignment = Enum.HorizontalAlignment.Center
				}),
				OuterPadding = React.createElement("UIPadding", {
					PaddingTop = UDim.new(0, v32.Padding.Medium),
					PaddingBottom = UDim.new(0, v32.Padding.Large)
				}),
				ConnectTextIntro = if v33 ~= AccessResponseEnum.Pending then React.createElement(FoundationText, {
					LayoutOrder = 1,
					tag = "auto-y grow size-full-0 text-align-x-left text-wrap",
					Text = if v33 ~= AccessResponseEnum.Granted then v39.textIntro else v39.textIntro18Plus
				}) else React.createElement(Skeleton, {
					LayoutOrder = 1,
					Size = UDim2.new(1, 0, 0, 30)
				}),
				ConnectOptionText1 = React.createElement(TextWithIcon, {
					layoutOrder = 2,
					icon = "icons/menu/platformChatOff_small",
					text = v39.textChatWithoutFilters,
					iconPadding = v32.Padding.Medium
				}),
				ConnectOptionText2 = React.createElement(TextWithIcon, {
					layoutOrder = 3,
					icon = "icons/controls/microphone_small",
					text = v39.textPartyVoice,
					iconPadding = v32.Padding.Medium
				}),
				ConnectOptionText3 = React.createElement(TextWithIcon, {
					layoutOrder = 4,
					icon = "icons/actions/edit/add_small",
					text = v39.textAndMore,
					iconPadding = v32.Padding.Medium
				}),
				ConnectTextOutro = if v33 ~= AccessResponseEnum.Pending then React.createElement(FoundationText, {
					LayoutOrder = 5,
					tag = "auto-y grow size-full-0 text-align-x-left text-wrap",
					Text = if v33 ~= AccessResponseEnum.Granted then v39.textOutro else v39.textOutro18Plus
				}) else React.createElement(Skeleton, {
					LayoutOrder = 5,
					Size = UDim2.new(1, 0, 0, 60)
				})
			})
		})
	})
end

return TrustedContactsEducationModal
