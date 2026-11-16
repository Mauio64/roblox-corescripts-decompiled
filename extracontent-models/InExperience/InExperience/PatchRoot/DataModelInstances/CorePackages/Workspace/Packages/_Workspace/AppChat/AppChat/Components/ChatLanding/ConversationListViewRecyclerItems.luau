local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)
local SocialCarousel = require(parent.SocialCarousel)
local ViewRecycler = require(parent.ViewRecycler)

local ChatLandingModalContainer = require(script.Parent.ChatLandingModal.ChatLandingModalContainer)
local ConversationGroupsEntryContainer = require(script.Parent.ConversationGroupsEntryContainer)
local ConversationListItemKind = require(script.Parent.ConversationListItemKind)
local ConversationRow = require(script.Parent.ConversationRow.ConversationRow)
local ConversationRowBindingHost = require(script.Parent.ConversationRow.ConversationRowBindingHost)
local PartyQuickStartContainer = require(script.Parent.PartyQuickStartContainer)

local FFlagAppChatUseBindingViewRecyclerConversationRow = require(AppChat.Flags.FFlagAppChatUseBindingViewRecyclerConversationRow)

local Constants = SocialCarousel.Constants
local View = Foundation.View
local v = { readiness = ViewRecycler.RecyclableViewReadiness.ReadyOnCommit }

local function selectCanvasSize(p)
	return UDim2.new(1, 0, 0, p.height)
end

local function selectCanvasBackgroundStyle(p) -- 1 equivalent call inferred from this helper
	return p.backgroundStyle
end

local function CanvasPaddingItemView(p)
	local size = SignalsReact.useSignalBinding(function(p2)
		return selectCanvasSize(p.itemSignal(p2))
	end)

	local backgroundStyle = SignalsReact.useSignalBinding(function(p2)
		return selectCanvasBackgroundStyle(p.itemSignal(p2)) -- inferred equivalent call
	end)

	return React.createElement(View, {
		Size = size,
		backgroundStyle = backgroundStyle,
		BorderSizePixel = 0
	})
end

local function ChatLandingModalItemView(_)
	return React.createElement(
		"Frame",
		{
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		},
		{
			ChatLandingModal = React.createElement(ChatLandingModalContainer)
		}
	)
end

local function StatefulConversationItemView(p)
	local v2 = SignalsReact.useSignalState(p.itemSignal)
	local v3 = SignalsReact.useSignalState(v2.presentationSignal)

	local createElement = React.createElement
	local v4 = {
		conversationId = v2.id,
		entryHeight = v3.entryHeight,
		isSquadEnabled = v3.isSquadEnabled,
		isWideMode = v3.isWideMode,
		onActivated = v3.onActivated,
		onSquadJoinButtonActivated = v3.onSquadJoinButtonActivated,
		fireImpressionEvent = v3.fireImpressionEvent,
		fireClickEvent = v3.fireClickEvent,
		showBackground = v3.showBackground,
		localUserId = v3.localUserId,
		debugCellValue = 0
	}
	local debugCellValue

	if v3.isDebugEnabled then
		debugCellValue = v2.id
	end

	v4.debugCellValue = debugCellValue
	return createElement(ConversationRow, v4)
end

local function BindingConversationItemView(p)
	return React.createElement(ConversationRowBindingHost, { itemSignal = p.itemSignal })
end

local function GroupLinkItemView(p)
	local v2 = SignalsReact.useSignalState(p.itemSignal)
	return React.createElement(ConversationGroupsEntryContainer, { entryHeight = v2.entryHeight })
end

local function QuickStartItemView(p)
	local v2 = SignalsReact.useSignalState(p.itemSignal)
	return React.createElement(PartyQuickStartContainer, { entryHeight = v2.entryHeight })
end

local function SocialCarouselItemView(p)
	local v2 = SignalsReact.useSignalState(p.itemSignal)
	local createElement = React.createElement
	local entry = SocialCarousel.Entry
	local v3 = {
		customTileList = v2.customTileList,
		roduxKey = "ChatAppReducer",
		hideCarouselHeader = true,
		source = 0,
		unifiedLogging = 0
	}
	local source

	if v2.isInExperience then
		source = Constants.ANALYTICS.SRC.PARTY_PAGE_IN_EXP
	else
		source = Constants.ANALYTICS.SRC.PARTY_PAGE_UA
	end

	v3.source = source

	v3.unifiedLogging = v2.unifiedLogging
	return createElement(entry, v3)
end

local recyclableView = ViewRecycler.createRecyclableView(StatefulConversationItemView, v)
local v2 = ViewRecycler.createRecyclableView(BindingConversationItemView)
local recyclableView2 = ViewRecycler.createRecyclableView(CanvasPaddingItemView)

local v3 = {
	[ConversationListItemKind.CanvasBottomPadding] = recyclableView2,
	[ConversationListItemKind.CanvasTopPadding] = recyclableView2,
	[ConversationListItemKind.ChatLandingModal] = ViewRecycler.createRecyclableView(ChatLandingModalItemView)
}
local Conversation = ConversationListItemKind.Conversation

if not FFlagAppChatUseBindingViewRecyclerConversationRow then
	v2 = recyclableView
end

v3[Conversation] = v2

v3[ConversationListItemKind.GroupLink] = ViewRecycler.createRecyclableView(GroupLinkItemView, v)
v3[ConversationListItemKind.QuickStartLink] = ViewRecycler.createRecyclableView(QuickStartItemView, v)

v3[ConversationListItemKind.SocialCarousel] = ViewRecycler.createRecyclableView(SocialCarouselItemView, v)
local frozen = table.freeze(v3)

return table.freeze({
	canvasBottomPadding = function(height, backgroundStyle)
		return {
			id = "CanvasBottomPadding",
			kind = ConversationListItemKind.CanvasBottomPadding,
			height = height,
			backgroundStyle = backgroundStyle
		}
	end,
	canvasTopPadding = function(height, backgroundStyle)
		return {
			id = "CanvasTopPadding",
			kind = ConversationListItemKind.CanvasTopPadding,
			height = height,
			backgroundStyle = backgroundStyle
		}
	end,
	chatLandingModal = function()
		return { id = "UnfilteredThreadsFtux", kind = ConversationListItemKind.ChatLandingModal }
	end,
	conversation = function(p, presentationSignal)
		return {
			id = tostring(p),
			kind = ConversationListItemKind.Conversation,
			presentationSignal = presentationSignal
		}
	end,
	getItemKey = function(p)
		return p.id
	end,
	getItemType = function(p)
		local itemType = frozen[p.kind]
		assert(itemType ~= nil, `ConversationListViewRecycler: unknown item kind "{tostring(p.kind)}"`)
		return itemType
	end,
	groupLink = function(entryHeight)
		return {
			id = "ConversationGroupsEntryContainer",
			kind = ConversationListItemKind.GroupLink,
			entryHeight = entryHeight
		}
	end,
	quickStart = function(entryHeight)
		return {
			id = "PartyQuickStartContainer",
			kind = ConversationListItemKind.QuickStartLink,
			entryHeight = entryHeight
		}
	end,
	socialCarousel = function(customTileList, isInExperience, unifiedLogging)
		return {
			id = "SocialCarousel",
			kind = ConversationListItemKind.SocialCarousel,
			customTileList = customTileList,
			isInExperience = isInExperience,
			unifiedLogging = unifiedLogging
		}
	end
})
