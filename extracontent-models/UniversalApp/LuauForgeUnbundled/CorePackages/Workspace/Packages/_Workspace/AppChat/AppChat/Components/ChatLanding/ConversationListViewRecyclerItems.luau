local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SignalsReact")
local SocialCarousel = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SocialCarousel")
local ViewRecyclerReact = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/ViewRecyclerReact")

local ChatLandingModalContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatLanding/ChatLandingModal/ChatLandingModalContainer")
local ConversationGroupsEntryContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatLanding/ConversationGroupsEntryContainer")
local ConversationListItemKind = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatLanding/ConversationListItemKind")
local ConversationRow = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatLanding/ConversationRow/ConversationRow")
local ConversationRowBindingHost = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatLanding/ConversationRow/ConversationRowBindingHost")
local PartyQuickStartContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatLanding/PartyQuickStartContainer")

local FFlagAppChatUseBindingViewRecyclerConversationRow = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatUseBindingViewRecyclerConversationRow")

local constants = SocialCarousel.Constants
local view = Foundation.View
local v5 = { readiness = ViewRecyclerReact.RecyclableViewReadiness.ReadyOnCommit }

local function selectCanvasSize(p2)
	return UDim2.new(1, 0, 0, p2.height)
end

local function selectCanvasBackgroundStyle(p2)
	return p2.backgroundStyle
end

local function CanvasPaddingItemView(p2)
	local v6 = SignalsReact.useSignalBinding(function(p3)
		return selectCanvasSize(p2.itemSignal(p3))
	end)

	local v7 = SignalsReact.useSignalBinding(function(p3)
		return p2.itemSignal(p3).backgroundStyle
	end)

	return React.createElement(view, {
		Size = v6,
		backgroundStyle = v7,
		BorderSizePixel = 0
	})
end

local function ChatLandingModalItemView(p2)
	return React.createElement(
		"Frame",
		{
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		},
		{ ChatLandingModal = React.createElement(ChatLandingModalContainer) }
	)
end

local function StatefulConversationItemView(p2)
	local v6 = SignalsReact.useSignalState(p2.itemSignal)
	local v7 = SignalsReact.useSignalState(v6.presentationSignal)

	local createElement = React.createElement
	local v9 = {
		conversationId = v6.id,
		entryHeight = v7.entryHeight,
		isSquadEnabled = v7.isSquadEnabled,
		isWideMode = v7.isWideMode,
		onActivated = v7.onActivated,
		onSquadJoinButtonActivated = v7.onSquadJoinButtonActivated,
		fireImpressionEvent = v7.fireImpressionEvent,
		fireClickEvent = v7.fireClickEvent,
		showBackground = v7.showBackground,
		localUserId = v7.localUserId,
		debugCellValue = 0
	}
	local v10 = if v7.isDebugEnabled then v6.id else nil
	v9.debugCellValue = v10
	return createElement(ConversationRow, v9)
end

local function BindingConversationItemView(p2)
	return React.createElement(ConversationRowBindingHost, { itemSignal = p2.itemSignal })
end

local function GroupLinkItemView(p2)
	local v6 = SignalsReact.useSignalState(p2.itemSignal)
	return React.createElement(ConversationGroupsEntryContainer, { entryHeight = v6.entryHeight })
end

local function QuickStartItemView(p2)
	local v6 = SignalsReact.useSignalState(p2.itemSignal)
	return React.createElement(PartyQuickStartContainer, { entryHeight = v6.entryHeight })
end

local function SocialCarouselItemView(p2)
	local v6 = SignalsReact.useSignalState(p2.itemSignal)
	local createElement = React.createElement
	local entry = SocialCarousel.Entry
	local v7 = {
		customTileList = v6.customTileList,
		roduxKey = "ChatAppReducer",
		hideCarouselHeader = true,
		source = 0,
		unifiedLogging = 0
	}

	local v8 = if v6.isInExperience then constants.ANALYTICS.SRC.PARTY_PAGE_IN_EXP else constants.ANALYTICS.SRC.PARTY_PAGE_UA
	v7.source = v8

	v7.unifiedLogging = v6.unifiedLogging
	return createElement(entry, v7)
end

local recyclableView = ViewRecyclerReact.createRecyclableView(StatefulConversationItemView, v5)
local v6 = ViewRecyclerReact.createRecyclableView(BindingConversationItemView)
local recyclableView2 = ViewRecyclerReact.createRecyclableView(CanvasPaddingItemView)

local freeze = table.freeze
local v7 = {
	[ConversationListItemKind.CanvasBottomPadding] = recyclableView2,
	[ConversationListItemKind.CanvasTopPadding] = recyclableView2,
	[ConversationListItemKind.ChatLandingModal] = ViewRecyclerReact.createRecyclableView(ChatLandingModalItemView)
}
local conversation = ConversationListItemKind.Conversation

if not FFlagAppChatUseBindingViewRecyclerConversationRow then
	v6 = recyclableView
end

v7[conversation] = v6

v7[ConversationListItemKind.GroupLink] = ViewRecyclerReact.createRecyclableView(GroupLinkItemView, v5)
v7[ConversationListItemKind.QuickStartLink] = ViewRecyclerReact.createRecyclableView(QuickStartItemView, v5)

v7[ConversationListItemKind.SocialCarousel] = ViewRecyclerReact.createRecyclableView(SocialCarouselItemView, v5)
local frozen = freeze(v7)

return table.freeze({
	canvasBottomPadding = function(p2, p3)
		return {
			id = "CanvasBottomPadding",
			kind = ConversationListItemKind.CanvasBottomPadding,
			height = p2,
			backgroundStyle = p3
		}
	end,
	canvasTopPadding = function(p2, p3)
		return {
			id = "CanvasTopPadding",
			kind = ConversationListItemKind.CanvasTopPadding,
			height = p2,
			backgroundStyle = p3
		}
	end,
	chatLandingModal = function()
		return { id = "UnfilteredThreadsFtux", kind = ConversationListItemKind.ChatLandingModal }
	end,
	conversation = function(p2, p3)
		return {
			id = tostring(p2),
			kind = ConversationListItemKind.Conversation,
			presentationSignal = p3
		}
	end,
	getItemKey = function(p2)
		return p2.id
	end,
	getItemType = function(p2)
		local itemType = frozen[p2.kind]
		assert(itemType ~= nil, `ConversationListViewRecycler: unknown item kind "{tostring(p2.kind)}"`)
		return itemType
	end,
	groupLink = function(p2)
		return {
			id = "ConversationGroupsEntryContainer",
			kind = ConversationListItemKind.GroupLink,
			entryHeight = p2
		}
	end,
	quickStart = function(p2)
		return {
			id = "PartyQuickStartContainer",
			kind = ConversationListItemKind.QuickStartLink,
			entryHeight = p2
		}
	end,
	socialCarousel = function(p2, p3, p4)
		return {
			id = "SocialCarousel",
			kind = ConversationListItemKind.SocialCarousel,
			customTileList = p2,
			isInExperience = p3,
			unifiedLogging = p4
		}
	end
})
