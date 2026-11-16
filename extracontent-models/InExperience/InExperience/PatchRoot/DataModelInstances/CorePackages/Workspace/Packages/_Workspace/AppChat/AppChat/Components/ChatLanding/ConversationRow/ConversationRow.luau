local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)

local DomLocators = require(AppChat.Utils.DomLocators)
local Squads = require(parent.Squads)
local FFlagDebugAppChatEnableDomLocators = require(AppChat.Flags.FFlagDebugAppChatEnableDomLocators)

local FFlagAppChatExtendConversationListRowDividers = require(AppChat.Flags.FFlagAppChatExtendConversationListRowDividers)
local FFlagAppChatRemoveConversationListDivider = require(AppChat.Flags.FFlagAppChatRemoveConversationListDivider)

local FFlagAppChatTimestampInSubtitleConversationRow = require(AppChat.Flags.FFlagAppChatTimestampInSubtitleConversationRow)

local ConversationFacePile = require(AppChat.Components.Cells.ConversationFacePile)
local ConversationRowSubtitle = require(script.Parent.ConversationRowSubtitle)
local useConversationRowPresentation = require(script.Parent.useConversationRowPresentation)

local SquadButtonSourceEnum = Squads.Enums.SquadButtonSourceEnum
local SquadComponentAccessWrapper = Squads.SquadComponentAccessWrapper
local SquadJoinButton = Squads.SquadJoinButton
local memo = React.memo(ConversationFacePile)

local function ConversationRow(props, callback)
	local v = useConversationRowPresentation({
		conversationId = props.conversationId,
		entryHeight = props.entryHeight,
		isSquadEnabled = props.isSquadEnabled,
		isWideMode = props.isWideMode,
		showBackground = props.showBackground,
		onActivated = props.onActivated,
		onSquadJoinButtonActivated = props.onSquadJoinButtonActivated,
		fireImpressionEvent = props.fireImpressionEvent,
		fireClickEvent = props.fireClickEvent
	})

	local v2 = Foundation.Hooks.useTokens()

	local rowRef = v.rowRef
	local ref = React.useCallback(function(current)
		rowRef.current = current

		if type(callback) == "function" then
			callback(current)
		elseif callback ~= nil then
			callback.current = current
		end
	end, { callback, rowRef })

	if not v.hasConversation then
		return nil
	end

	local udim = UDim.new(0, v.pagePaddingLeft)
	local udim2 = UDim.new(0, v.pagePaddingRight)
	local showBackground = v.showBackground

	local createElement = React.createElement
	local view = Foundation.View
	local v3 = {
		backgroundStyle = v2.Color.None,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, v.entryHeight),
		testId = 0
	}
	local testId

	if FFlagDebugAppChatEnableDomLocators then
		testId = v.testId
	end

	v3.testId = testId

	local createElement2 = React.createElement
	local view2 = Foundation.View
	local size

	if not FFlagAppChatExtendConversationListRowDividers then
		size = UDim2.fromScale(1, 1)
	end

	local backgroundStyle

	if not showBackground then
		backgroundStyle = v2.Color.None
	end

	local cell = {
		Name = "cell",
		Size = size,
		tag = { ["size-full"] = true, ["bg-surface-0"] = showBackground },
		backgroundStyle = backgroundStyle,
		selection = { Selectable = true },
		onActivated = v.onRowActivated,
		stateLayer = showBackground and {
			affordance = Foundation.Enums.StateLayerAffordance.Background
		} or nil,
		ref = ref
	}
	local debugCellContainer

	if props.debugCellValue then
		debugCellContainer = React.createElement("Folder", {}, {
			debugCell = React.createElement("StringValue", { Value = props.debugCellValue })
		})
	end

	local createElement3 = React.createElement
	local view3 = Foundation.View
	local size2

	if not FFlagAppChatExtendConversationListRowDividers then
		size2 = UDim2.fromScale(1, 1)
	end

	local right

	if not FFlagAppChatExtendConversationListRowDividers then
		right = udim2
	end

	local v4 = {
		avatar = React.createElement(Foundation.View, { tag = "size-1000-1000", LayoutOrder = 0 }, {
			facePile = React.createElement(memo, {
				conversationId = v.conversationId,
				onActivated = v.onRowActivated,
				participants = v.participants,
				localUserId = props.localUserId,
				selectable = false
			})
		}),
		body = 0
	}

	local createElement4 = React.createElement
	local view4 = Foundation.View

	local createElement5 = React.createElement
	local view5 = Foundation.View

	local createElement6 = React.createElement
	local view6 = Foundation.View

	local v5 = {
		titleContainer = React.createElement(
			Foundation.View,
			{
				tag = "row align-y-center gap-xxsmall size-full-0 auto-y clip",
				Name = "titleContainer",
				LayoutOrder = 1
			},
			{
				title = React.createElement(Foundation.Text, {
					tag = "shrink auto-xy text-title-large text-align-x-left text-truncate-split content-default",
					Name = "title",
					Text = v.title,
					LayoutOrder = 1
				}),
				subscriptionBadge = React.createElement(
					Foundation.View,
					{
						tag = "size-400-400",
						Name = "subscriptionBadge",
						LayoutOrder = 2,
						Visible = v.showSubscriptionBadge
					},
					{
						icon = React.createElement(Foundation.Icon, {
							name = Foundation.Enums.IconName.RobloxPlus,
							size = Foundation.Enums.IconSize.Small,
							style = v2.Color.Content.Emphasis
						})
					}
				)
			}
		),
		subtitle = 0,
		subtitleRow = 0
	}
	local subtitle

	if not FFlagAppChatTimestampInSubtitleConversationRow then
		subtitle = React.createElement(Foundation.Text, {
			tag = "size-full-0 auto-y text-body-small text-align-x-left text-truncate-end content-default",
			Text = v.subtitleText,
			LayoutOrder = 2
		})
	end

	v5.subtitle = subtitle
	local subtitleRow

	if FFlagAppChatTimestampInSubtitleConversationRow then
		subtitleRow = React.createElement(ConversationRowSubtitle, {
			subtitleText = v.subtitleText,
			timestampText = v.timestampText,
			LayoutOrder = 2
		})
	end

	v5.subtitleRow = subtitleRow
	local children = {
		info = createElement6(
			view6,
			{ tag = "col align-y-center fill gap-xxsmall size-0-full clip", LayoutOrder = 1 },
			v5
		),
		rightContent = 0
	}

	local createElement7 = React.createElement
	local view7 = Foundation.View
	local v6 = {
		tag = "row align-y-center size-0-full auto-x",
		AutomaticSize = Enum.AutomaticSize.X,
		LayoutOrder = 2
	}
	local squadButton

	if v.showSquadButton then
		local createElement8 = React.createElement
		local view8 = Foundation.View

		local createElement9 = React.createElement
		local v7 = { parentChannelId = v.conversationId }

		local createElement10 = React.createElement
		local v8 = {
			conversationId = v.conversationId,
			isFullWidth = false,
			isInCard = false,
			layoutOrder = 0,
			onActivated = v.onSquadActivated,
			Selectable = false,
			shouldAnimate = false,
			squadButtonSource = SquadButtonSourceEnum.ConversationEntry,
			squadLocation = v.squadLocation,
			testId = 0
		}
		local testId2

		if FFlagDebugAppChatEnableDomLocators and v.locatorTitle then
			testId2 = DomLocators.chatLandingConversationEntrySquadButton(v.locatorTitle)
		end

		v8.testId = testId2
		squadButton = createElement8(view8, {
			tag = "row align-x-right align-y-center auto-xy",
			LayoutOrder = 0
		}, {
			wrapper = createElement9(SquadComponentAccessWrapper, v7, {
				button = createElement10(SquadJoinButton, v8)
			})
		})
	end

	local createElement8 = React.createElement
	local view8 = Foundation.View
	local v7 = {
		tag = "row align-y-center gap-xsmall auto-xy",
		Name = "timestampCluster",
		Visible = v.showTimestamp,
		LayoutOrder = 1
	}
	local timestamp

	if not FFlagAppChatTimestampInSubtitleConversationRow then
		timestamp = React.createElement(Foundation.Text, {
			tag = "auto-xy text-body-small content-default",
			Name = "timeStamp",
			Text = v.timestampText,
			LayoutOrder = 1
		})
	end

	children.rightContent = createElement7(view7, v6, {
		squadButton = squadButton,
		timestampCluster = createElement8(view8, v7, {
			timestamp = timestamp,
			unreadDot = React.createElement(Foundation.View, {
				tag = "size-200-200 radius-circle bg-action-emphasis",
				Name = "unreadDot",
				Visible = v.showUnread,
				LayoutOrder = 2
			})
		})
	})
	local v8 = {
		mainContent = createElement5(view5, {
			tag = "row align-y-center fill gap-small size-full-0 clip",
			Name = "mainContent",
			LayoutOrder = 1,
			padding = FFlagAppChatExtendConversationListRowDividers and { right = udim2 } or nil
		}, children),
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

	v8.divider = divider
	v4.body = createElement4(view4, {
		tag = "col fill size-0-full clip",
		Name = "body",
		LayoutOrder = 1
	}, v8)
	return createElement(view, v3, {
		cell = createElement2(view2, cell, {
			debugCellContainer = debugCellContainer,
			content = createElement3(view3, {
				Size = size2,
				tag = "row align-y-center gap-small size-full",
				padding = { left = udim, right = right }
			}, v4)
		})
	})
end

return React.memo(React.forwardRef(ConversationRow))
