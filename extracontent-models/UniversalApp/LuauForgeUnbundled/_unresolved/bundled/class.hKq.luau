local RbxAnalyticsService = game:GetService("RbxAnalyticsService")

local module = require("@luauforge/bundled/hKr")

local class = {}
class.__index = class

local v5 = { selectItemCount = 0, backButtonClickCount = 0, isSeenSummaryPage = false }

local v6 = {
	ABANDONED_TREE_BASED_REPORT = "TreeBasedAbuseReportAbandoned",
	SUBMIT_TREE_BASED_REPORT = "TreeBasedAbuseReportSubmitted"
}

function class.new(p2, p3)
	return (setmetatable({ _target = p2, _context = p3, _state = table.clone(v5) }, class))
end

function class:_sendEvent(p2, options)
	if self._target and self._context then
		local joined = module.Dictionary.join(
			{ platform = self._target, dialogEntryPoint = self._context },
			self._state,
			options or {}
		)
		RbxAnalyticsService:SendEventDeferred(self._target, self._context, p2, joined)
	end
end

function class:onBackButtonPressed()
	self._state.backButtonClickCount += 1
end

function class:onSingleListItemSelected()
	self._state.selectItemCount += 1
end

function class:onSubmissionPageMount()
	self._state.isSeenSummaryPage = true
end

function class:onReportSubmitted()
	self:_sendEvent("TreeBasedAbuseReportSubmitted")
end

function class:onReportAbandoned()
	self:_sendEvent("TreeBasedAbuseReportAbandoned")
end

return class
