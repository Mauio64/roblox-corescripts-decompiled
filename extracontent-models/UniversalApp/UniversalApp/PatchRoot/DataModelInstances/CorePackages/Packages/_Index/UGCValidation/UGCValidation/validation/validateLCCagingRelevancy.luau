local UGCValidationService = game:GetService("UGCValidationService")
local ParentParent = script.Parent.Parent
local Analytics = require(ParentParent.Analytics)

require(ParentParent.util.Types)

local pcallDeferred = require(ParentParent.util.pcallDeferred)
local getFIntUGCLCCagingRelevancyMinimum = require(ParentParent.flags.getFIntUGCLCCagingRelevancyMinimum)

local function validateLCCagingRelevancy(p1, p2, p3, vector3: Vector3, vector3_2: Vector3, p4) -- line: 11
	-- upvalues: pcallDeferred (copy), UGCValidationService (copy), Analytics (copy), getFIntUGCLCCagingRelevancyMinimum (copy)
	local v13, v14, v15 = pcallDeferred(function() -- line: 19
		-- upvalues: UGCValidationService (copy), p1 (copy), p2 (copy), p3 (copy), vector3 (copy), vector3_2 (copy)
		return UGCValidationService:GetEditableCagingRelevancyMetrics(p1.editableMesh, p2.editableMesh, p3.editableMesh, vector3, vector3_2)
	end, p4)

	if not v13 then
		Analytics.reportFailure(Analytics.ErrorType.validateCagingRelevancy_FailedToExecute, nil, p4)

		return false, { string.format("Failed to execute cage relevancy detection for '%s'. Make sure the cage mesh exists and try again.", p3.fullName) }
	end

	if v15 == 0 then
		return true
	end

	local v16 = math.floor(100 * v14 / v15)

	if v16 < getFIntUGCLCCagingRelevancyMinimum() then
		Analytics.reportFailure(Analytics.ErrorType.validateCagingRelevancy_IrrelevantCaging, nil, p4)

		local v17 = "Validation detected %d%% of the outer cage edits do not cover the accessory. Make sure you are moving the outer cage only where needed." .. "[Read more](https://create.roblox.com/docs/art/validation-errors#cageRelevancy)"

		return false, { string.format(v17, 100 - v16) }
	end

	return true
end

return validateLCCagingRelevancy
