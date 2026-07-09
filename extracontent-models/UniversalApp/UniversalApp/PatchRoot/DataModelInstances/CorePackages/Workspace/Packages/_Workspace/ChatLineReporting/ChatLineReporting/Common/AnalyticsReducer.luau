local ChatLineReporting = script:FindFirstAncestor("ChatLineReporting")

require(ChatLineReporting.Common.Types)

local AnalyticsActions = require(ChatLineReporting.Common.Constants).AnalyticsActions

local function analyticsReducer(p1, p2) -- line: 7
	-- upvalues: AnalyticsActions (copy)
	local v6 = table.clone(p1)
	local type = p2.type

	if type == AnalyticsActions.SetPlaceId then
		v6.place_id = p2.place_id

		return v6
	end

	if type == AnalyticsActions.AccumulateForTimeSpent then
		v6.accumulated_time_ms = p2.accumulated_time_ms

		return v6
	end

	if type == AnalyticsActions.SetReasonSelection then
		v6.reason_selection = p2.reason_selection

		return v6
	end

	if type == AnalyticsActions.SetCommentAdded then
		v6.comment_added = p2.comment_added

		return v6
	end

	if type == AnalyticsActions.SetChatLineSelected then
		v6.chat_line_selected = true
		v6.selected_chat_line_index = p2.selected_chat_line_index

		return v6
	end

	if type == AnalyticsActions.SetChatHistoryInformation then
		v6.selectable_chat_history_size = p2.selectable_chat_history_size
		v6.total_chat_history_size = p2.total_chat_history_size
		v6.num_non_general_channel_chats = p2.num_non_general_channel_chats

		return v6
	end

	if type == AnalyticsActions.SetViewportInformation then
		v6.viewport_size_x = p2.viewport_size_x
		v6.viewport_size_y = p2.viewport_size_y
		v6.is_portrait_mode = p2.is_portrait_mode
	end

	return v6
end

return analyticsReducer
