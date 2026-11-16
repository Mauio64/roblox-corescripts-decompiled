local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Foundation")
require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SignalsReact")

local DomLocators = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/DomLocators")
local Squads = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Squads")
local FFlagDebugAppChatEnableDomLocators = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagDebugAppChatEnableDomLocators")

local FFlagAppChatExtendConversationListRowDividers = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatExtendConversationListRowDividers")
local FFlagAppChatRemoveConversationListDivider = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatRemoveConversationListDivider")
local FFlagAppChatUseBindingConversationFacePile = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatUseBindingConversationFacePile")

local FFlagAppChatTimestampInSubtitleConversationRow = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatTimestampInSubtitleConversationRow")

local ConversationFacePile = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/Cells/ConversationFacePile")
local ConversationFacePileBinding = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatLanding/ConversationRow/ConversationFacePileBinding")
local ConversationRowSubtitle = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatLanding/ConversationRow/ConversationRowSubtitle")
local useGetOneToOneFriendIdFromConversationId = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useGetOneToOneFriendIdFromConversationId")
local useIsRobloxSubscriberBinding = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UserProfiles").Hooks.useIsRobloxSubscriberBinding

local squadButtonSourceEnum = Squads.Enums.SquadButtonSourceEnum
local squadComponentAccessWrapper = Squads.SquadComponentAccessWrapper
local squadJoinButton = Squads.SquadJoinButton
local memo = React.memo(ConversationFacePile)

local function SubscriptionBadge(p2)
	local v5 = Foundation.Hooks.useTokens()

	return React.createElement(Foundation.View, {
		tag = "size-400-400",
		Name = "subscriptionBadge",
		LayoutOrder = 2,
		testId = "conversation-row-subscription-badge",
		Visible = p2.visible
	}, {
		icon = React.createElement(Foundation.Icon, {
			name = Foundation.Enums.IconName.RobloxPlus,
			size = Foundation.Enums.IconSize.Small,
			style = v5.Color.Content.Emphasis
		})
	})
end

local function LegacySubscriptionBadgeHost(p2)
	local v7 = useIsRobloxSubscriberBinding((useGetOneToOneFriendIdFromConversationId(SignalsReact.useSignalState(p2.itemSignal).id)))

	return React.createElement(SubscriptionBadge, { visible = v7 })
end

local function LegacyConversationFacePileHost(p2)
	local v5 = SignalsReact.useSignalState(p2.itemSignal)
	local v6 = SignalsReact.useSignalState(v5.presentationSignal)

	return React.createElement(memo, {
		conversationId = v5.id,
		onActivated = p2.onActivated,
		localUserId = v6.localUserId,
		selectable = false
	})
end

local function SquadButtonHost(props)
	local v5 = SignalsReact.useSignalState(props.itemSignal)

	local createElement = React.createElement
	local view = Foundation.View

	local createElement2 = React.createElement
	local v9 = { parentChannelId = v5.id }

	local createElement3 = React.createElement
	local v12 = {
		conversationId = v5.id,
		isFullWidth = false,
		isInCard = false,
		layoutOrder = 0,
		onActivated = props.onActivated,
		Selectable = false,
		shouldAnimate = false,
		squadButtonSource = squadButtonSourceEnum.ConversationEntry,
		squadLocation = props.squadLocation,
		testId = 0
	}
	local v13 = if FFlagDebugAppChatEnableDomLocators and props.locatorTitle then DomLocators.chatLandingConversationEntrySquadButton(props.locatorTitle) else nil
	v12.testId = v13
	return createElement(view, {
		tag = "row align-x-right align-y-center auto-xy",
		LayoutOrder = 0
	}, {
		wrapper = createElement2(squadComponentAccessWrapper, v9, {
			button = createElement3(squadJoinButton, v12)
		})
	})
end

local function ConversationRowView(props)
	local v5 = Foundation.Hooks.useTokens()

	local udim = UDim.new(0, props.pagePaddingLeft)
	local udim2 = UDim.new(0, props.pagePaddingRight)
	local showBackground = props.showBackground ~= false

	local createElement = React.createElement
	local view = Foundation.View
	local v6 = {
		backgroundStyle = v5.Color.None,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, props.entryHeight),
		testId = 0
	}
	local v7 = if FFlagDebugAppChatEnableDomLocators then props.testId else nil
	v6.testId = v7

	local createElement2 = React.createElement
	local view2 = Foundation.View

	local v9 = if not showBackground then v5.Color.None else nil
	local cell = {
		Name = "cell",
		tag = { ["size-full"] = true, ["bg-surface-0"] = showBackground },
		backgroundStyle = v9,
		selection = { Selectable = true },
		onActivated = props.onRowActivated,
		stateLayer = showBackground and {
			affordance = Foundation.Enums.StateLayerAffordance.Background
		} or nil,
		ref = props.rowRef
	}

	local v11 = if props.debugCellValue then React.createElement("Folder", {}, {
		debugCell = React.createElement("StringValue", { Value = props.debugCellValue })
	}) else nil

	local createElement3 = React.createElement
	local view3 = Foundation.View

	local createElement4 = React.createElement
	local view4 = Foundation.View

	local v17 = if FFlagAppChatUseBindingConversationFacePile then React.createElement(ConversationFacePileBinding, {
		itemSignal = props.itemSignal
	}) else React.createElement(LegacyConversationFacePileHost, {
		itemSignal = props.itemSignal,
		onActivated = props.onRowActivated
	})
	local children = {
		avatar = createElement4(view4, { tag = "size-1000-1000", LayoutOrder = 0 }, {
			facePile = v17
		}),
		body = 0
	}

	local createElement5 = React.createElement
	local view5 = Foundation.View

	local createElement6 = React.createElement
	local view6 = Foundation.View

	local createElement7 = React.createElement
	local view7 = Foundation.View

	local createElement8 = React.createElement
	local view8 = Foundation.View

	local v24 = {
		title = React.createElement(Foundation.Text, {
			tag = "shrink auto-xy text-title-large text-align-x-left text-truncate-split content-default",
			Name = "title",
			Text = props.title,
			LayoutOrder = 1
		}),
		subscriptionBadge = 0
	}

	local v25 = if FFlagAppChatUseBindingConversationFacePile then React.createElement(SubscriptionBadge, {
		visible = props.showSubscriptionBadge
	}) else React.createElement(LegacySubscriptionBadgeHost, {
		itemSignal = props.itemSignal
	})
	v24.subscriptionBadge = v25
	local v22 = {
		titleContainer = createElement8(
			view8,
			{
				tag = "row align-y-center gap-xxsmall size-full-0 auto-y clip",
				Name = "titleContainer",
				LayoutOrder = 1
			},
			v24
		),
		subtitle = 0,
		subtitleRow = 0
	}

	local v26 = if not FFlagAppChatTimestampInSubtitleConversationRow then React.createElement(Foundation.Text, {
		tag = "size-full-0 auto-y text-body-small text-align-x-left text-truncate-end content-default",
		Text = props.subtitleText,
		LayoutOrder = 2
	}) else nil
	v22.subtitle = v26

	local v27 = if FFlagAppChatTimestampInSubtitleConversationRow then React.createElement(ConversationRowSubtitle, {
		subtitleText = props.subtitleText,
		timestampText = props.timestampText,
		LayoutOrder = 2
	}) else nil
	v22.subtitleRow = v27
	local children2 = {
		info = createElement7(
			view7,
			{
				tag = "col align-y-center fill gap-xxsmall size-0-full clip",
				LayoutOrder = 1
			},
			v22
		),
		rightContent = 0
	}

	local createElement9 = React.createElement
	local view9 = Foundation.View

	local v30 = if props.showSquadButton then React.createElement(SquadButtonHost, {
		itemSignal = props.itemSignal,
		locatorTitle = props.locatorTitle,
		onActivated = props.onSquadActivated,
		squadLocation = props.squadLocation
	}) else nil

	local createElement10 = React.createElement
	local view10 = Foundation.View
	local v31 = {
		tag = "row align-y-center gap-xsmall auto-xy",
		Name = "timestampCluster",
		Visible = props.showTimestamp,
		LayoutOrder = 1
	}

	local v33 = if not FFlagAppChatTimestampInSubtitleConversationRow then React.createElement(Foundation.Text, {
		tag = "auto-xy text-body-small content-default",
		Name = "timeStamp",
		Text = props.timestampText,
		LayoutOrder = 1,
		testId = "conversation-row-timestamp"
	}) else nil
	children2.rightContent = createElement9(
		view9,
		{ tag = "row align-y-center size-0-full auto-x", LayoutOrder = 2 },
		{
			squadButton = v30,
			timestampCluster = createElement10(view10, v31, {
				timestamp = v33,
				unreadDot = React.createElement(Foundation.View, {
					tag = "size-200-200 radius-circle bg-action-emphasis",
					Name = "unreadDot",
					Visible = props.showUnread,
					LayoutOrder = 2
				})
			})
		}
	)
	local v19 = {
		mainContent = createElement6(view6, {
			tag = "row align-y-center fill gap-small size-full-0 clip",
			Name = "mainContent",
			LayoutOrder = 1,
			padding = FFlagAppChatExtendConversationListRowDividers and { right = udim2 } or nil
		}, children2),
		divider = 0
	}

	local v34 = if not FFlagAppChatRemoveConversationListDivider then React.createElement(
		Foundation.View,
		{ tag = "size-full-0 auto-y", Name = "divider", LayoutOrder = 2 },
		{
			line = React.createElement(Foundation.Divider)
		}
	) else nil
	v19.divider = v34
	children.body = createElement5(
		view5,
		{ tag = "col fill size-0-full clip", Name = "body", LayoutOrder = 1 },
		v19
	)
	return createElement(view, v6, {
		cell = createElement2(view2, cell, {
			debugCellContainer = v11,
			content = createElement3(view3, {
				tag = "row align-y-center gap-small size-full",
				padding = {
					left = udim,
					right = if not FFlagAppChatExtendConversationListRowDividers then udim2 else nil
				}
			}, children)
		})
	})
end

return React.memo(ConversationRowView)
