local React = require("@game/CorePackages/Workspace/Packages/_Workspace/TrustedContacts/React")

local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/TrustedContacts/UIBlox")
local partialPageModal = UIBlox.App.Dialog.Modal.PartialPageModal
local buttonType = UIBlox.App.Button.Enum.ButtonType

local useScreenSize = require("@game/CorePackages/Workspace/Packages/_Workspace/TrustedContacts/RobloxAppHooks").useScreenSize
local useNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/TrustedContacts/Navigation").useNavigation
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/TrustedContacts/Localization").Hooks.useLocalization

local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/TrustedContacts/RobloxAppEnums").AppPage

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/TrustedContacts/Foundation")
local skeleton = Foundation.Skeleton

local text = Foundation.Text
local icon = Foundation.Icon
local iconSize = Foundation.Enums.IconSize
local useTokens = Foundation.Hooks.useTokens

local ampApiProvider = require("@game/CorePackages/Workspace/Packages/_Workspace/TrustedContacts/AmpUpsell").AmpApiProvider
local accessResponseEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/TrustedContacts/AmpUpsell").AmpEnums.AccessResponseEnum

local Analytics = require("@game/CorePackages/Workspace/Packages/_Index/TrustedContacts/TrustedContacts/Analytics")
local useTCAnalytics = Analytics.useTCAnalytics
local eventNames = Analytics.EventNames

local fStringCanAccessTrustedContactsAmpNameSpace = require("@game/CorePackages/Workspace/Packages/_Workspace/TrustedContacts/SharedFlags").FStringCanAccessTrustedContactsAmpNameSpace
local fStringIsVerified18PlusAmpFeature = require("@game/CorePackages/Workspace/Packages/_Workspace/TrustedContacts/SharedFlags").FStringIsVerified18PlusAmpFeature

local fFlagCreateConnectionsHub = require("@game/CorePackages/Workspace/Packages/_Workspace/TrustedContacts/SharedFlags").FFlagCreateConnectionsHub
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
			Icon = React.createElement(icon, {
				name = props.icon,
				size = iconSize.Small,
				LayoutOrder = 1
			}),
			Text = React.createElement(text, {
				tag = "auto-y grow size-full-0 text-align-x-left text-wrap",
				Text = props.text,
				LayoutOrder = 2
			})
		}
	)
end

local function TrustedContactsEducationModal(p2)
	local v5 = useScreenSize()
	local v6 = useNavigation()
	local v7 = useTokens()

	local state, setState = React.useState(accessResponseEnum.Pending)
	React.useEffect(function()
		setState(ampApiProvider.upsellFeatureAccess(
			fStringIsVerified18PlusAmpFeature,
			{},
			fStringCanAccessTrustedContactsAmpNameSpace
		).access)
	end, {})

	local fireAnalyticsEvent = useTCAnalytics().fireAnalyticsEvent

	React.useEffect(function()
		fireAnalyticsEvent(eventNames.TCEducationModalSeen)
	end, {})

	local v8 = React.useCallback(function()
		fireAnalyticsEvent(eventNames.TCEducationCloseClicked)
		v6.pop()
	end, { v6 })

	local v9 = React.useCallback(function()
		fireAnalyticsEvent(eventNames.TCEducationGotItClicked)
		v6.pop()
	end, { v6 })

	local v10 = React.useCallback(function()
		fireAnalyticsEvent(eventNames.TCEducationManageConnectionsClicked)

		if fFlagCreateConnectionsHub then
			v6.navigate(appPage.CoHubMyConnections)
		elseif defineFastFlag then
			v6.navigate(appPage.ViewFriends)
		else
			v6.replace(appPage.ViewFriends)
		end
	end, { v6 })

	local v11 = useLocalization({
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
	local v13 = {
		title = v11.title,
		screenSize = v5,
		onCloseClicked = v8,
		buttonStackProps = {
			buttons = {
				{
					buttonType = buttonType.PrimaryContextual,
					props = { onActivated = v9, text = v11.buttonGotIt }
				},
				{
					buttonType = buttonType.Secondary,
					props = { onActivated = v10, text = v11.buttonManage }
				}
			},
			forcedFillDirection = Enum.FillDirection.Horizontal
		}
	}

	local createElement2 = React.createElement
	local v16 = {
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.fromScale(1, 0),
		BackgroundTransparency = 1
	}

	local v17 = {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Center
		}),
		TextContainer = 0
	}

	local createElement3 = React.createElement
	local v19 = {
		LayoutOrder = 2,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.fromScale(1, 0),
		BackgroundTransparency = 1
	}

	local children = {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, v7.Padding.Large),
			HorizontalAlignment = Enum.HorizontalAlignment.Center
		}),
		OuterPadding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, v7.Padding.Medium),
			PaddingBottom = UDim.new(0, v7.Padding.Large)
		}),
		ConnectTextIntro = 0,
		ConnectOptionText1 = 0,
		ConnectOptionText2 = 0,
		ConnectOptionText3 = 0,
		ConnectTextOutro = 0
	}
	local v20

	if state == accessResponseEnum.Pending then
		v20 = React.createElement(skeleton, {
			Size = UDim2.new(1, 0, 0, 30),
			LayoutOrder = 1
		})
	else
		local createElement4 = React.createElement

		local v23 = if state == accessResponseEnum.Granted then v11.textIntro18Plus else v11.textIntro
		v20 = createElement4(text, {
			LayoutOrder = 1,
			tag = "auto-y grow size-full-0 text-align-x-left text-wrap",
			Text = v23
		})
	end

	children.ConnectTextIntro = v20

	children.ConnectOptionText1 = React.createElement(TextWithIcon, {
		layoutOrder = 2,
		icon = "icons/menu/platformChatOff_small",
		text = v11.textChatWithoutFilters,
		iconPadding = v7.Padding.Medium
	})

	children.ConnectOptionText2 = React.createElement(TextWithIcon, {
		layoutOrder = 3,
		icon = "icons/controls/microphone_small",
		text = v11.textPartyVoice,
		iconPadding = v7.Padding.Medium
	})

	children.ConnectOptionText3 = React.createElement(TextWithIcon, {
		layoutOrder = 4,
		icon = "icons/actions/edit/add_small",
		text = v11.textAndMore,
		iconPadding = v7.Padding.Medium
	})
	local v21

	if state == accessResponseEnum.Pending then
		v21 = React.createElement(skeleton, {
			Size = UDim2.new(1, 0, 0, 60),
			LayoutOrder = 5
		})
	else
		local createElement4 = React.createElement

		local v24 = if state == accessResponseEnum.Granted then v11.textOutro18Plus else v11.textOutro
		v21 = createElement4(text, {
			LayoutOrder = 5,
			tag = "auto-y grow size-full-0 text-align-x-left text-wrap",
			Text = v24
		})
	end

	children.ConnectTextOutro = v21
	v17.TextContainer = createElement3("Frame", v19, children)
	return createElement(partialPageModal, v13, {
		ViewContainer = createElement2("Frame", v16, v17)
	})
end

return TrustedContactsEducationModal
