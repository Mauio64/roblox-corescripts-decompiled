local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)

local DomLocators = require(AppChat.Utils.DomLocators)
local Squads = require(parent.Squads)
local FFlagDebugAppChatEnableDomLocators = require(AppChat.Flags.FFlagDebugAppChatEnableDomLocators)

local FFlagAppChatExtendConversationListRowDividers = require(AppChat.Flags.FFlagAppChatExtendConversationListRowDividers)
local FFlagAppChatRemoveConversationListDivider = require(AppChat.Flags.FFlagAppChatRemoveConversationListDivider)
local FFlagAppChatUseBindingConversationFacePile = require(AppChat.Flags.FFlagAppChatUseBindingConversationFacePile)

local FFlagAppChatTimestampInSubtitleConversationRow = require(AppChat.Flags.FFlagAppChatTimestampInSubtitleConversationRow)

local ConversationFacePile = require(AppChat.Components.Cells.ConversationFacePile)
local ConversationFacePileBinding = require(script.Parent.ConversationFacePileBinding)
local ConversationRowSubtitle = require(script.Parent.ConversationRowSubtitle)
local useGetOneToOneFriendIdFromConversationId = require(AppChat.Hooks.useGetOneToOneFriendIdFromConversationId)
local UserProfiles = require(parent.UserProfiles)
local useIsRobloxSubscriberBinding = UserProfiles.Hooks.useIsRobloxSubscriberBinding

local SquadButtonSourceEnum = Squads.Enums.SquadButtonSourceEnum
local SquadComponentAccessWrapper = Squads.SquadComponentAccessWrapper
local SquadJoinButton = Squads.SquadJoinButton
local memo = React.memo(ConversationFacePile)

local function SubscriptionBadge(p)
	local v = Foundation.Hooks.useTokens()

	return React.createElement(Foundation.View, {
		tag = "size-400-400",
		Name = "subscriptionBadge",
		LayoutOrder = 2,
		testId = "conversation-row-subscription-badge",
		Visible = p.visible
	}, {
		icon = React.createElement(Foundation.Icon, {
			name = Foundation.Enums.IconName.RobloxPlus,
			size = Foundation.Enums.IconSize.Small,
			style = v.Color.Content.Emphasis
		})
	})
end

local function LegacySubscriptionBadgeHost(p)
	local visible = useIsRobloxSubscriberBinding((useGetOneToOneFriendIdFromConversationId(SignalsReact.useSignalState(p.itemSignal).id)))

	return React.createElement(SubscriptionBadge, { visible = visible })
end

local function LegacyConversationFacePileHost(p)
	local v = SignalsReact.useSignalState(p.itemSignal)
	local v2 = SignalsReact.useSignalState(v.presentationSignal)

	return React.createElement(memo, {
		conversationId = v.id,
		onActivated = p.onActivated,
		localUserId = v2.localUserId,
		selectable = false
	})
end

local function SquadButtonHost(props)
	local v = SignalsReact.useSignalState(props.itemSignal)

	local createElement = React.createElement
	local view = Foundation.View

	local createElement2 = React.createElement
	local v2 = { parentChannelId = v.id }

	local createElement3 = React.createElement
	local v3 = {
		conversationId = v.id,
		isFullWidth = false,
		isInCard = false,
		layoutOrder = 0,
		onActivated = props.onActivated,
		Selectable = false,
		shouldAnimate = false,
		squadButtonSource = SquadButtonSourceEnum.ConversationEntry,
		squadLocation = props.squadLocation,
		testId = 0
	}
	local testId

	if FFlagDebugAppChatEnableDomLocators and props.locatorTitle then
		testId = DomLocators.chatLandingConversationEntrySquadButton(props.locatorTitle)
	end

	v3.testId = testId
	return createElement(view, { tag = "row align-x-right align-y-center auto-xy", LayoutOrder = 0 }, {
		wrapper = createElement2(SquadComponentAccessWrapper, v2, {
			button = createElement3(SquadJoinButton, v3)
		})
	})
end

local function ConversationRowView(props)
	local v = Foundation.Hooks.useTokens()

	local udim = UDim.new(0, props.pagePaddingLeft)
	local udim2 = UDim.new(0, props.pagePaddingRight)
	local showBackground = props.showBackground ~= false

	local createElement = React.createElement
	local view = Foundation.View
	local v2 = {
		backgroundStyle = v.Color.None,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, props.entryHeight),
		testId = 0
	}
	local testId

	if FFlagDebugAppChatEnableDomLocators then
		testId = props.testId
	end

	v2.testId = testId

	local createElement2 = React.createElement
	local view2 = Foundation.View
	local backgroundStyle

	if not showBackground then
		backgroundStyle = v.Color.None
	end

	local cell = {
		Name = "cell",
		tag = { ["size-full"] = true, ["bg-surface-0"] = showBackground },
		backgroundStyle = backgroundStyle,
		selection = { Selectable = true },
		onActivated = props.onRowActivated,
		stateLayer = showBackground and {
			affordance = Foundation.Enums.StateLayerAffordance.Background
		} or nil,
		ref = props.rowRef
	}
	local debugCellContainer

	if props.debugCellValue then
		debugCellContainer = React.createElement("Folder", {}, {
			debugCell = React.createElement("StringValue", { Value = props.debugCellValue })
		})
	end

	local createElement3 = React.createElement
	local view3 = Foundation.View
	local right

	if not FFlagAppChatExtendConversationListRowDividers then
		right = udim2
	end

	local createElement4 = React.createElement
	local view4 = Foundation.View
	local facePile

	if FFlagAppChatUseBindingConversationFacePile then
		facePile = React.createElement(ConversationFacePileBinding, {
			itemSignal = props.itemSignal
		})
	else
		facePile = React.createElement(LegacyConversationFacePileHost, {
			itemSignal = props.itemSignal,
			onActivated = props.onRowActivated
		})
	end

	local children = {
		avatar = createElement4(view4, { tag = "size-1000-1000", LayoutOrder = 0 }, {
			facePile = facePile
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

	local v3 = {
		title = React.createElement(Foundation.Text, {
			tag = "shrink auto-xy text-title-large text-align-x-left text-truncate-split content-default",
			Name = "title",
			Text = props.title,
			LayoutOrder = 1
		}),
		subscriptionBadge = 0
	}
	local subscriptionBadge

	if FFlagAppChatUseBindingConversationFacePile then
		subscriptionBadge = React.createElement(SubscriptionBadge, {
			visible = props.showSubscriptionBadge
		})
	else
		subscriptionBadge = React.createElement(LegacySubscriptionBadgeHost, {
			itemSignal = props.itemSignal
		})
	end

	v3.subscriptionBadge = subscriptionBadge
	local v4 = {
		titleContainer = createElement8(
			view8,
			{
				tag = "row align-y-center gap-xxsmall size-full-0 auto-y clip",
				Name = "titleContainer",
				LayoutOrder = 1
			},
			v3
		),
		subtitle = 0,
		subtitleRow = 0
	}
	local subtitle

	if not FFlagAppChatTimestampInSubtitleConversationRow then
		subtitle = React.createElement(Foundation.Text, {
			tag = "size-full-0 auto-y text-body-small text-align-x-left text-truncate-end content-default",
			Text = props.subtitleText,
			LayoutOrder = 2
		})
	end

	v4.subtitle = subtitle
	local subtitleRow

	if FFlagAppChatTimestampInSubtitleConversationRow then
		subtitleRow = React.createElement(ConversationRowSubtitle, {
			subtitleText = props.subtitleText,
			timestampText = props.timestampText,
			LayoutOrder = 2
		})
	end

	v4.subtitleRow = subtitleRow
	local children2 = {
		info = createElement7(
			view7,
			{ tag = "col align-y-center fill gap-xxsmall size-0-full clip", LayoutOrder = 1 },
			v4
		),
		rightContent = 0
	}

	local createElement9 = React.createElement
	local view9 = Foundation.View
	local squadButton

	if props.showSquadButton then
		squadButton = React.createElement(SquadButtonHost, {
			itemSignal = props.itemSignal,
			locatorTitle = props.locatorTitle,
			onActivated = props.onSquadActivated,
			squadLocation = props.squadLocation
		})
	end

	local createElement10 = React.createElement
	local view10 = Foundation.View
	local v5 = {
		tag = "row align-y-center gap-xsmall auto-xy",
		Name = "timestampCluster",
		Visible = props.showTimestamp,
		LayoutOrder = 1
	}
	local timestamp

	if not FFlagAppChatTimestampInSubtitleConversationRow then
		timestamp = React.createElement(Foundation.Text, {
			tag = "auto-xy text-body-small content-default",
			Name = "timeStamp",
			Text = props.timestampText,
			LayoutOrder = 1,
			testId = "conversation-row-timestamp"
		})
	end

	children2.rightContent = createElement9(view9, {
		tag = "row align-y-center size-0-full auto-x",
		LayoutOrder = 2
	}, {
		squadButton = squadButton,
		timestampCluster = createElement10(view10, v5, {
			timestamp = timestamp,
			unreadDot = React.createElement(Foundation.View, {
				tag = "size-200-200 radius-circle bg-action-emphasis",
				Name = "unreadDot",
				Visible = props.showUnread,
				LayoutOrder = 2
			})
		})
	})
	local v6 = {
		mainContent = createElement6(view6, {
			tag = "row align-y-center fill gap-small size-full-0 clip",
			Name = "mainContent",
			LayoutOrder = 1,
			padding = FFlagAppChatExtendConversationListRowDividers and { right = udim2 } or nil
		}, children2),
		divider = 0
	}
	local divider

	if not FFlagAppChatRemoveConversationListDivider then
		divider = React.createElement(
			Foundation.View,
			{ tag = "size-full-0 auto-y", Name = "divider", LayoutOrder = 2 },
			{
				line = React.createElement(Foundation.Divider)
			}
		)
	end

	v6.divider = divider
	children.body = createElement5(view5, {
		tag = "col fill size-0-full clip",
		Name = "body",
		LayoutOrder = 1
	}, v6)
	return createElement(view, v2, {
		cell = createElement2(view2, cell, {
			debugCellContainer = debugCellContainer,
			content = createElement3(view3, {
				tag = "row align-y-center gap-small size-full",
				padding = { left = udim, right = right }
			}, children)
		})
	})
end

return React.memo(ConversationRowView)
