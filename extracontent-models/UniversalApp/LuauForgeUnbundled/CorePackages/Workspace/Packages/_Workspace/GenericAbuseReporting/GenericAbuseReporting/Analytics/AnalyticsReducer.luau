local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/Rodux")
local dictionary = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/Cryo").Dictionary

local v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Logger"):new("AbuseReport Analytics")

local OnFormCommentUpdated = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Analytics/Actions/OnFormCommentUpdated")
local OnFormReasonSelected = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Analytics/Actions/OnFormReasonSelected")
local OnFormLoaded = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Analytics/Actions/OnFormLoaded")

return {
	reducer = Rodux.createReducer({}, {
		[OnFormLoaded.name] = function(p2, data)
			v5:trace("OnFormLoaded")
			return dictionary.union(p2, {
				context = data.context,
				place_id = data.place_id,
				accumulated_time_ms = data.accumulated_time_ms
			})
		end,
		[OnFormReasonSelected.name] = function(p2, p3)
			v5:trace("OnFormReasonSelected - reason_selection: {}", p3.reason_selection)
			return dictionary.union(p2, {
				reason_selection = p3.reason_selection,
				reason_change_count = p2.reason_change_count + 1
			})
		end,
		[OnFormCommentUpdated.name] = function(p2, p3)
			v5:trace("OnFormCommentUpdated - comment_added: {}", p3.comment_added)
			return dictionary.union(p2, { comment_added = p3.comment_added })
		end
	}),
	initialState = {
		interaction_type = 0,
		context = "Unknown",
		event_type = "GenericAbuseReportWithReasonAndComment",
		place_id = 0,
		accumulated_time_ms = 0,
		reason_selection = "",
		reason_change_count = 0,
		comment_added = false
	}
}
