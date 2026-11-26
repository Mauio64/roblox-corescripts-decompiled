local FFlagAppChatConversationStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatConversationStore")
local FFlagAppChatSignalsMessageStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatSignalsMessageStore")
local FFlagAppChatUseFoundationConversationRow = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatUseFoundationConversationRow")

local FFlagAppChatReadConversationListFromSignalsStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatReadConversationListFromSignalsStore")
local FFlagAppChatReadMessageListFromSignalsStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatReadMessageListFromSignalsStore")
local FFlagAppChatUseViewRecyclerMessageList = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatUseViewRecyclerMessageList")
local FFlagAppChatIncrementalPaginationProjection = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatIncrementalPaginationProjection")
local v5 = FFlagAppChatUseFoundationConversationRow and FFlagAppChatConversationStore and FFlagAppChatSignalsMessageStore
local v6 = FFlagAppChatReadMessageListFromSignalsStore and FFlagAppChatSignalsMessageStore

return {
	shouldUseFoundationConversationRow = v5,
	shouldReadConversationListFromSignalsStore = FFlagAppChatReadConversationListFromSignalsStore and v5,
	shouldReadMessageListFromSignalsStore = v6,
	shouldUseViewRecyclerMessageList = FFlagAppChatUseViewRecyclerMessageList and FFlagAppChatIncrementalPaginationProjection and v6
}
