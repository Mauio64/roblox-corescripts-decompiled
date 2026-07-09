local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local Parent = script:FindFirstAncestor("AbuseReporting").Parent
local Cryo = require(Parent.Cryo)
local t1 = {}

t1.__index = t1

local t2 = {
	selectItemCount = 0,
	backButtonClickCount = 0,
	isSeenSummaryPage = false
}
local _ = {
	ABANDONED_TREE_BASED_REPORT = "TreeBasedAbuseReportAbandoned",
	SUBMIT_TREE_BASED_REPORT = "TreeBasedAbuseReportSubmitted"
}

function t1.new(s1: string, s2: string) -- line: 40
	-- upvalues: t2 (copy), t1 (copy)
	return (setmetatable({
		_target = s1,
		_context = s2,
		_state = table.clone(t2)
	}, t1))
end
function t1._sendEvent(t3: {[any]: any}, s3: string, p1) -- line: 52
	-- upvalues: Cryo (copy), RbxAnalyticsService (copy)
	if t3._target and t3._context then
		local v12 = Cryo.Dictionary.join({
			platform = t3._target,
			dialogEntryPoint = t3._context
		}, t3._state, p1 or {})

		RbxAnalyticsService:SendEventDeferred(t3._target, t3._context, s3, v12)
	end
end
function t1.onBackButtonPressed(p2) -- line: 62
	local _state = p2._state

	_state.backButtonClickCount = _state.backButtonClickCount + 1
end
function t1.onSingleListItemSelected(p3) -- line: 66
	local _state = p3._state

	_state.selectItemCount = _state.selectItemCount + 1
end
function t1.onSubmissionPageMount(p4) -- line: 70
	p4._state.isSeenSummaryPage = true
end
function t1.onReportSubmitted(p5) -- line: 74
	p5:_sendEvent("TreeBasedAbuseReportSubmitted")
end
function t1.onReportAbandoned(p6) -- line: 78
	p6:_sendEvent("TreeBasedAbuseReportAbandoned")
end

return t1
