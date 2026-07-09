local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local GenericAbuseReportingParent = GenericAbuseReporting.Parent
local Rodux = require(GenericAbuseReportingParent.Rodux)
local Dictionary = require(GenericAbuseReportingParent.Cryo).Dictionary
local v5 = require(GenericAbuseReporting.Logger):new("AbuseReport Analytics")
local OnFormCommentUpdated = require(GenericAbuseReporting.Analytics.Actions.OnFormCommentUpdated)
local OnFormReasonSelected = require(GenericAbuseReporting.Analytics.Actions.OnFormReasonSelected)
local OnFormLoaded = require(GenericAbuseReporting.Analytics.Actions.OnFormLoaded)
local t1 = {
	interaction_type = 0,
	context = "Unknown",
	event_type = "GenericAbuseReportWithReasonAndComment",
	place_id = 0,
	accumulated_time_ms = 0,
	reason_selection = "",
	reason_change_count = 0,
	comment_added = false
}

return {
	reducer = Rodux.createReducer({}, {
		[OnFormLoaded.name] = function(t2: {[any]: any}, p1) -- line: 37
			-- upvalues: v5 (copy), Dictionary (copy)
			v5:trace("OnFormLoaded")

			return Dictionary.union(t2, {
				context = p1.context,
				place_id = p1.place_id,
				accumulated_time_ms = p1.accumulated_time_ms
			})
		end,
		[OnFormReasonSelected.name] = function(t3: {[any]: any}, p2) -- line: 45
			-- upvalues: v5 (copy), Dictionary (copy)
			v5:trace("OnFormReasonSelected - reason_selection: {}", p2.reason_selection)

			return Dictionary.union(t3, {
				reason_selection = p2.reason_selection,
				reason_change_count = t3.reason_change_count + 1
			})
		end,
		[OnFormCommentUpdated.name] = function(t4: {[any]: any}, p3) -- line: 52
			-- upvalues: v5 (copy), Dictionary (copy)
			v5:trace("OnFormCommentUpdated - comment_added: {}", p3.comment_added)

			return Dictionary.union(t4, {
				comment_added = p3.comment_added
			})
		end
	}),
	initialState = t1
}
