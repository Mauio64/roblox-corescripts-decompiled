local UGCValidationService = game:GetService("UGCValidationService")

local parent = script.Parent.Parent

local Analytics = require(parent.Analytics)

require(parent.util.Types)
local pcallDeferred = require(parent.util.pcallDeferred)
local getFIntUGCLCCagingRelevancyMinimum = require(parent.flags.getFIntUGCLCCagingRelevancyMinimum)

local function validateLCCagingRelevancy(p, p2, p3, vector3: Vector3, vector3_2: Vector3, p4)
	local v, v2, v3 = pcallDeferred(function()
		return UGCValidationService:GetEditableCagingRelevancyMetrics(
			p.editableMesh,
			p2.editableMesh,
			p3.editableMesh,
			vector3,
			vector3_2
		)
	end, p4)

	if not v then
		Analytics.reportFailure(Analytics.ErrorType.validateCagingRelevancy_FailedToExecute, nil, p4)

		return
			false,
			{ string.format(
					"Failed to execute cage relevancy detection for '%s'. Make sure the cage mesh exists and try again.",
					p3.fullName
				) }
	end

	if v3 == 0 then
		return true
	end

	local v4 = math.floor(100 * v2 / v3)

	if v4 < getFIntUGCLCCagingRelevancyMinimum() then
		Analytics.reportFailure(Analytics.ErrorType.validateCagingRelevancy_IrrelevantCaging, nil, p4)

		return
			false,
			{ string.format(
					"Validation detected %d%% of the outer cage edits do not cover the accessory. Make sure you are moving the outer cage only where needed.[Read more](https://create.roblox.com/docs/art/validation-errors#cageRelevancy)",
					100 - v4
				) }
	end

	return true
end

return validateLCCagingRelevancy
