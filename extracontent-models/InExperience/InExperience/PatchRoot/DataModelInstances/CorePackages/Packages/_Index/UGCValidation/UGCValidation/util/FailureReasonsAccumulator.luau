local FailureReasonsAccumulator = {}
FailureReasonsAccumulator.__index = FailureReasonsAccumulator

function FailureReasonsAccumulator.new()
	return (setmetatable({ passed = true, reasons = {} }, FailureReasonsAccumulator))
end

function FailureReasonsAccumulator:updateReasons(flag: boolean, list)
	if flag then
		return
	end

	table.insert(self.reasons, table.concat(list, "\n"))
	self.passed = false
end

function FailureReasonsAccumulator.getFinalResults(p)
	if p.passed then
		return true
	end

	return false, p.reasons
end

return FailureReasonsAccumulator
