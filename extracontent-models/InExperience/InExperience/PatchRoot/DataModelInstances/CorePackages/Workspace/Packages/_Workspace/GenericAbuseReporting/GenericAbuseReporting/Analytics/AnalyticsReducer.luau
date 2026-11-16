local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local parent = GenericAbuseReporting.Parent
local Rodux = require(parent.Rodux)
local Cryo = require(parent.Cryo)
local Dictionary = Cryo.Dictionary

local Logger = require(GenericAbuseReporting.Logger)
local v = Logger:new("AbuseReport Analytics")

local OnFormCommentUpdated = require(GenericAbuseReporting.Analytics.Actions.OnFormCommentUpdated)
local OnFormReasonSelected = require(GenericAbuseReporting.Analytics.Actions.OnFormReasonSelected)
local OnFormLoaded = require(GenericAbuseReporting.Analytics.Actions.OnFormLoaded)

return {
	reducer = Rodux.createReducer({}, {
		[OnFormLoaded.name] = function(p, data)
			v:trace("OnFormLoaded")
			return Dictionary.union(p, {
				context = data.context,
				place_id = data.place_id,
				accumulated_time_ms = data.accumulated_time_ms
			})
		end,
		[OnFormReasonSelected.name] = function(p, p2)
			v:trace("OnFormReasonSelected - reason_selection: {}", p2.reason_selection)
			return Dictionary.union(p, {
				reason_selection = p2.reason_selection,
				reason_change_count = p.reason_change_count + 1
			})
		end,
		[OnFormCommentUpdated.name] = function(p, p2)
			v:trace("OnFormCommentUpdated - comment_added: {}", p2.comment_added)
			return Dictionary.union(p, { comment_added = p2.comment_added })
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
