local parent = script:FindFirstAncestor("TrustedContacts").Parent

local React = require(parent.React)

local UIBlox = require(parent.UIBlox)
local PartialPageModal = UIBlox.App.Dialog.Modal.PartialPageModal
local ButtonType = UIBlox.App.Button.Enum.ButtonType

local RobloxAppHooks = require(parent.RobloxAppHooks)
local useScreenSize = RobloxAppHooks.useScreenSize
local Navigation = require(parent.Navigation)
local useNavigation = Navigation.useNavigation
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage

local Foundation = require(parent.Foundation)
local Skeleton = Foundation.Skeleton

local Text = Foundation.Text
local Icon = Foundation.Icon
local IconSize = Foundation.Enums.IconSize
local useTokens = Foundation.Hooks.useTokens

local AmpUpsell = require(parent.AmpUpsell)
local AmpApiProvider = AmpUpsell.AmpApiProvider
local AmpUpsell2 = require(parent.AmpUpsell)
local AccessResponseEnum = AmpUpsell2.AmpEnums.AccessResponseEnum

local Analytics = require(script.Parent.Parent.Parent.Analytics)
local useTCAnalytics = Analytics.useTCAnalytics
local EventNames = Analytics.EventNames

local SharedFlags = require(parent.SharedFlags)
local FStringCanAccessTrustedContactsAmpNameSpace = SharedFlags.FStringCanAccessTrustedContactsAmpNameSpace
local SharedFlags2 = require(parent.SharedFlags)
local FStringIsVerified18PlusAmpFeature = SharedFlags2.FStringIsVerified18PlusAmpFeature

local SharedFlags3 = require(parent.SharedFlags)
local FFlagCreateConnectionsHub = SharedFlags3.FFlagCreateConnectionsHub
local defineFastFlag = game:DefineFastFlag("ConsoleFriendsPageNavigation", false)

local function TextWithIcon(props)
	return React.createElement(
		"Frame",
		{
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.fromScale(1, 0),
			BackgroundTransparency = 1,
			LayoutOrder = props.layoutOrder
		},
		{
			UIListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, props.iconPadding),
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				VerticalAlignment = Enum.VerticalAlignment.Center
			}),
			Icon = React.createElement(Icon, {
				name = props.icon,
				size = IconSize.Small,
				LayoutOrder = 1
			}),
			Text = React.createElement(Text, {
				tag = "auto-y grow size-full-0 text-align-x-left text-wrap",
				Text = props.text,
				LayoutOrder = 2
			})
		}
	)
end

local function TrustedContactsEducationModal(_)
	local screenSize = useScreenSize()
	local v = useNavigation()
	local v2 = useTokens()

	local state, setState = React.useState(AccessResponseEnum.Pending)
	React.useEffect(function()
		setState(AmpApiProvider.upsellFeatureAccess(
			FStringIsVerified18PlusAmpFeature,
			{},
			FStringCanAccessTrustedContactsAmpNameSpace
		).access)
	end, {})

	local fireAnalyticsEvent = useTCAnalytics().fireAnalyticsEvent

	React.useEffect(function()
		fireAnalyticsEvent(EventNames.TCEducationModalSeen)
	end, {})

	local onCloseClicked = React.useCallback(function()
		fireAnalyticsEvent(EventNames.TCEducationCloseClicked)
		v.pop()
	end, { v })

	local onActivated = React.useCallback(function()
		fireAnalyticsEvent(EventNames.TCEducationGotItClicked)
		v.pop()
	end, { v })

	local onActivated2 = React.useCallback(function()
		fireAnalyticsEvent(EventNames.TCEducationManageConnectionsClicked)

		if FFlagCreateConnectionsHub then
			v.navigate(AppPage.CoHubMyConnections)
		elseif defineFastFlag then
			v.navigate(AppPage.ViewFriends)
		else
			v.replace(AppPage.ViewFriends)
		end
	end, { v })

	local v3 = useLocalization({
		title = "Feature.Friends.TCEducation.Title",
		textIntro = "Feature.Friends.TFEducation.Modal.TextIntro",
		textIntro18Plus = "Feature.Friends.TFEducation.Modal.TextIntro.EighteenPlus",
		textChatWithoutFilters = "Feature.Friends.TCFeature.ChatWithoutFilters",
		textPartyVoice = "Feature.Friends.TCFeature.PartyVoice",
		textAndMore = "Feature.Friends.TCFeature.AndMore",
		textOutro = "Feature.Friends.TFEducation.Modal.TextOutro",
		textOutro18Plus = "Feature.Friends.TFEducation.Modal.TextOutro.EighteenPlus",
		buttonManage = "Feature.Avatar.Heading.Manage",
		buttonGotIt = "Feature.Friends.Button.GotIt"
	})

	local createElement = React.createElement
	local v4 = {
		title = v3.title,
		screenSize = screenSize,
		onCloseClicked = onCloseClicked,
		buttonStackProps = {
			buttons = {
				{
					buttonType = ButtonType.PrimaryContextual,
					props = { onActivated = onActivated, text = v3.buttonGotIt }
				},
				{
					buttonType = ButtonType.Secondary,
					props = { onActivated = onActivated2, text = v3.buttonManage }
				}
			},
			forcedFillDirection = Enum.FillDirection.Horizontal
		}
	}

	local createElement2 = React.createElement
	local v5 = {
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.fromScale(1, 0),
		BackgroundTransparency = 1
	}

	local v6 = {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Center
		}),
		TextContainer = 0
	}

	local createElement3 = React.createElement
	local v7 = {
		LayoutOrder = 2,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.fromScale(1, 0),
		BackgroundTransparency = 1
	}

	local children = {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, v2.Padding.Large),
			HorizontalAlignment = Enum.HorizontalAlignment.Center
		}),
		OuterPadding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, v2.Padding.Medium),
			PaddingBottom = UDim.new(0, v2.Padding.Large)
		}),
		ConnectTextIntro = 0,
		ConnectOptionText1 = 0,
		ConnectOptionText2 = 0,
		ConnectOptionText3 = 0,
		ConnectTextOutro = 0
	}
	local connectTextIntro

	if state == AccessResponseEnum.Pending then
		connectTextIntro = React.createElement(Skeleton, {
			Size = UDim2.new(1, 0, 0, 30),
			LayoutOrder = 1
		})
	else
		local createElement4 = React.createElement
		local text

		if state == AccessResponseEnum.Granted then
			text = v3.textIntro18Plus
		else
			text = v3.textIntro
		end

		connectTextIntro = createElement4(Text, {
			LayoutOrder = 1,
			tag = "auto-y grow size-full-0 text-align-x-left text-wrap",
			Text = text
		})
	end

	children.ConnectTextIntro = connectTextIntro

	children.ConnectOptionText1 = React.createElement(TextWithIcon, {
		layoutOrder = 2,
		icon = "icons/menu/platformChatOff_small",
		text = v3.textChatWithoutFilters,
		iconPadding = v2.Padding.Medium
	})

	children.ConnectOptionText2 = React.createElement(TextWithIcon, {
		layoutOrder = 3,
		icon = "icons/controls/microphone_small",
		text = v3.textPartyVoice,
		iconPadding = v2.Padding.Medium
	})

	children.ConnectOptionText3 = React.createElement(TextWithIcon, {
		layoutOrder = 4,
		icon = "icons/actions/edit/add_small",
		text = v3.textAndMore,
		iconPadding = v2.Padding.Medium
	})
	local connectTextOutro

	if state == AccessResponseEnum.Pending then
		connectTextOutro = React.createElement(Skeleton, {
			Size = UDim2.new(1, 0, 0, 60),
			LayoutOrder = 5
		})
	else
		local createElement4 = React.createElement
		local text

		if state == AccessResponseEnum.Granted then
			text = v3.textOutro18Plus
		else
			text = v3.textOutro
		end

		connectTextOutro = createElement4(Text, {
			LayoutOrder = 5,
			tag = "auto-y grow size-full-0 text-align-x-left text-wrap",
			Text = text
		})
	end

	children.ConnectTextOutro = connectTextOutro
	v6.TextContainer = createElement3("Frame", v7, children)
	return createElement(PartialPageModal, v4, {
		ViewContainer = createElement2("Frame", v5, v6)
	})
end

return TrustedContactsEducationModal
