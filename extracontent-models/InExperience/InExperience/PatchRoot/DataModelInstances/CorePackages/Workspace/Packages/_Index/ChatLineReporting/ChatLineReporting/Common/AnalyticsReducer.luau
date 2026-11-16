local ChatLineReporting = script:FindFirstAncestor("ChatLineReporting")

require(ChatLineReporting.Common.Types)
local Constants = require(ChatLineReporting.Common.Constants)

local AnalyticsActions = Constants.AnalyticsActions
local function analyticsReducer(p, data)
	local clone = table.clone(p)
	local kind = data.type

	if kind == AnalyticsActions.SetPlaceId then
		clone.place_id = data.place_id
		return clone
	end

	if kind == AnalyticsActions.AccumulateForTimeSpent then
		clone.accumulated_time_ms = data.accumulated_time_ms
		return clone
	end

	if kind == AnalyticsActions.SetReasonSelection then
		clone.reason_selection = data.reason_selection
		return clone
	end

	if kind == AnalyticsActions.SetCommentAdded then
		clone.comment_added = data.comment_added
		return clone
	end

	if kind == AnalyticsActions.SetChatLineSelected then
		clone.chat_line_selected = true
		clone.selected_chat_line_index = data.selected_chat_line_index
	elseif kind == AnalyticsActions.SetChatHistoryInformation then
		clone.selectable_chat_history_size = data.selectable_chat_history_size
		clone.total_chat_history_size = data.total_chat_history_size
		clone.num_non_general_channel_chats = data.num_non_general_channel_chats
	elseif kind == AnalyticsActions.SetViewportInformation then
		clone.viewport_size_x = data.viewport_size_x
		clone.viewport_size_y = data.viewport_size_y
		clone.is_portrait_mode = data.is_portrait_mode
	end

	return clone
end

return analyticsReducer
