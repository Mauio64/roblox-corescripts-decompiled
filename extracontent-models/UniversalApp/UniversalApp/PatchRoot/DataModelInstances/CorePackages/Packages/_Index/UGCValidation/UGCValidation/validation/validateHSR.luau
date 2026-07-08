local ParentParent = script.Parent.Parent
local Analytics = require(ParentParent.Analytics)
local FailureReasonsAccumulator = require(ParentParent.util.FailureReasonsAccumulator)

require(ParentParent.util.Types)

local function validateHSR(p1, p2) -- line: 8
	-- upvalues: FailureReasonsAccumulator (copy), Analytics (copy)
	local timestamp = tick()

	if p2.bypassFlags and p2.bypassFlags.skipValidateHSR then
		return true
	end

	local descendants = p1:GetDescendants()

	table.insert(descendants, p1)

	local v9 = FailureReasonsAccumulator.new()

	for _, v11 in descendants do
		if v11:IsA("BaseWrap") and not v11:IsHSRReady() then
			Analytics.reportFailure(Analytics.ErrorType.validateHSR_HSRDataNotReady, nil, p2)
			v9:updateReasons(false, { `Missing HSR data for { v11:GetFullName() }. Please, try again.` })
		end
	end

	Analytics.recordScriptTime(script.Name, timestamp, p2)

	return v9:getFinalResults()
end

return validateHSR
