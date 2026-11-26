local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Foundation")

local DomLocators = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/DomLocators")
local Squads = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Squads")
local FFlagDebugAppChatEnableDomLocators = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagDebugAppChatEnableDomLocators")

local FFlagAppChatExtendConversationListRowDividers = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatExtendConversationListRowDividers")
local FFlagAppChatRemoveConversationListDivider = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatRemoveConversationListDivider")

local FFlagAppChatTimestampInSubtitleConversationRow = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatTimestampInSubtitleConversationRow")

local ConversationFacePile = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/Cells/ConversationFacePile")
local ConversationRowSubtitle = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatLanding/ConversationRow/ConversationRowSubtitle")
local useConversationRowPresentation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatLanding/ConversationRow/useConversationRowPresentation")

local squadButtonSourceEnum = Squads.Enums.SquadButtonSourceEnum
local squadComponentAccessWrapper = Squads.SquadComponentAccessWrapper
local squadJoinButton = Squads.SquadJoinButton
local memo = React.memo(ConversationFacePile)

local function ConversationRow(props, callback)
	local v5 = useConversationRowPresentation({
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

	local v6 = Foundation.Hooks.useTokens()

	local rowRef = v5.rowRef
	local v7 = React.useCallback(function(current)
		rowRef.current = current

		if type(callback) == "function" then
			callback(current)
		elseif callback ~= nil then
			callback.current = current
		end
	end, { callback, rowRef })

	if not v5.hasConversation then
		return nil
	end

	local udim = UDim.new(0, v5.pagePaddingLeft)
	local udim2 = UDim.new(0, v5.pagePaddingRight)
	local showBackground = v5.showBackground

	local createElement = React.createElement
	local view = Foundation.View
	local v8 = {
		backgroundStyle = v6.Color.None,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, v5.entryHeight),
		testId = 0
	}
	local v9 = if FFlagDebugAppChatEnableDomLocators then v5.testId else nil
	v8.testId = v9

	local createElement2 = React.createElement
	local view2 = Foundation.View

	local v11 = if not FFlagAppChatExtendConversationListRowDividers then UDim2.fromScale(1, 1) else nil

	local v12 = if not showBackground then v6.Color.None else nil
	local cell = {
		Name = "cell",
		Size = v11,
		tag = { ["size-full"] = true, ["bg-surface-0"] = showBackground },
		backgroundStyle = v12,
		selection = { Selectable = true },
		onActivated = v5.onRowActivated,
		stateLayer = showBackground and {
			affordance = Foundation.Enums.StateLayerAffordance.Background
		} or nil,
		ref = v7
	}

	local v14 = if props.debugCellValue then React.createElement("Folder", {}, {
		debugCell = React.createElement("StringValue", { Value = props.debugCellValue })
	}) else nil

	local createElement3 = React.createElement
	local view3 = Foundation.View

	local v16 = if not FFlagAppChatExtendConversationListRowDividers then UDim2.fromScale(1, 1) else nil

	local v19 = {
		avatar = React.createElement(Foundation.View, {
			tag = "size-1000-1000",
			LayoutOrder = 0
		}, {
			facePile = React.createElement(memo, {
				conversationId = v5.conversationId,
				onActivated = v5.onRowActivated,
				participants = v5.participants,
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

	local v24 = {
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
					Text = v5.title,
					LayoutOrder = 1
				}),
				subscriptionBadge = React.createElement(
					Foundation.View,
					{
						tag = "size-400-400",
						Name = "subscriptionBadge",
						LayoutOrder = 2,
						Visible = v5.showSubscriptionBadge
					},
					{
						icon = React.createElement(Foundation.Icon, {
							name = Foundation.Enums.IconName.RobloxPlus,
							size = Foundation.Enums.IconSize.Small,
							style = v6.Color.Content.Emphasis
						})
					}
				)
			}
		),
		subtitle = 0,
		subtitleRow = 0
	}

	local v25 = if not FFlagAppChatTimestampInSubtitleConversationRow then React.createElement(Foundation.Text, {
		tag = "size-full-0 auto-y text-body-small text-align-x-left text-truncate-end content-default",
		Text = v5.subtitleText,
		LayoutOrder = 2
	}) else nil
	v24.subtitle = v25

	local v26 = if FFlagAppChatTimestampInSubtitleConversationRow then React.createElement(ConversationRowSubtitle, {
		subtitleText = v5.subtitleText,
		timestampText = v5.timestampText,
		LayoutOrder = 2
	}) else nil
	v24.subtitleRow = v26
	local children = {
		info = createElement6(
			view6,
			{
				tag = "col align-y-center fill gap-xxsmall size-0-full clip",
				LayoutOrder = 1
			},
			v24
		),
		rightContent = 0
	}

	local createElement7 = React.createElement
	local view7 = Foundation.View
	local v27 = {
		tag = "row align-y-center size-0-full auto-x",
		AutomaticSize = Enum.AutomaticSize.X,
		LayoutOrder = 2
	}
	local v29

	if v5.showSquadButton then
		local createElement8 = React.createElement
		local view8 = Foundation.View

		local createElement9 = React.createElement
		local v33 = { parentChannelId = v5.conversationId }

		local createElement10 = React.createElement
		local v36 = {
			conversationId = v5.conversationId,
			isFullWidth = false,
			isInCard = false,
			layoutOrder = 0,
			onActivated = v5.onSquadActivated,
			Selectable = false,
			shouldAnimate = false,
			squadButtonSource = squadButtonSourceEnum.ConversationEntry,
			squadLocation = v5.squadLocation,
			testId = 0
		}

		local v37 = if FFlagDebugAppChatEnableDomLocators and v5.locatorTitle then DomLocators.chatLandingConversationEntrySquadButton(v5.locatorTitle) else nil
		v36.testId = v37
		v29 = createElement8(view8, {
			tag = "row align-x-right align-y-center auto-xy",
			LayoutOrder = 0
		}, {
			wrapper = createElement9(squadComponentAccessWrapper, v33, {
				button = createElement10(squadJoinButton, v36)
			})
		})
	end

	local createElement8 = React.createElement
	local view8 = Foundation.View
	local v30 = {
		tag = "row align-y-center gap-xsmall auto-xy",
		Name = "timestampCluster",
		Visible = v5.showTimestamp,
		LayoutOrder = 1
	}

	local v32 = if not FFlagAppChatTimestampInSubtitleConversationRow then React.createElement(Foundation.Text, {
		tag = "auto-xy text-body-small content-default",
		Name = "timeStamp",
		Text = v5.timestampText,
		LayoutOrder = 1
	}) else nil
	children.rightContent = createElement7(view7, v27, {
		squadButton = v29,
		timestampCluster = createElement8(view8, v30, {
			timestamp = v32,
			unreadDot = React.createElement(Foundation.View, {
				tag = "size-200-200 radius-circle bg-action-emphasis",
				Name = "unreadDot",
				Visible = v5.showUnread,
				LayoutOrder = 2
			})
		})
	})
	local v21 = {
		mainContent = createElement5(view5, {
			tag = "row align-y-center fill gap-small size-full-0 clip",
			Name = "mainContent",
			LayoutOrder = 1,
			padding = FFlagAppChatExtendConversationListRowDividers and { right = udim2 } or nil
		}, children),
		divider = 0
	}

	local v33 = if not FFlagAppChatRemoveConversationListDivider then React.createElement(
		Foundation.View,
		{ tag = "size-full-0 auto-y", Name = "divider", LayoutOrder = 2 },
		{
			line = React.createElement(Foundation.Divider)
		}
	) else nil
	v21.divider = v33
	v19.body = createElement4(
		view4,
		{ tag = "col fill size-0-full clip", Name = "body", LayoutOrder = 1 },
		v21
	)
	return createElement(view, v8, {
		cell = createElement2(view2, cell, {
			debugCellContainer = v14,
			content = createElement3(view3, {
				Size = v16,
				tag = "row align-y-center gap-small size-full",
				padding = {
					left = udim,
					right = if not FFlagAppChatExtendConversationListRowDividers then udim2 else nil
				}
			}, v19)
		})
	})
end

return React.memo(React.forwardRef(ConversationRow))
