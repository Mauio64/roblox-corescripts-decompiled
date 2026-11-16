local parent = script.Parent.Parent

local Analytics = require(parent.Analytics)
local Constants = require(parent.Constants)

local validateSingleInstance = require(parent.validation.validateSingleInstance)
local validateAssetCreator = require(parent.validation.validateAssetCreator)
local ParseContentIds = require(parent.util.ParseContentIds)

require(parent.util.Types)

local function validatePackage(p)
	assert(p.instances ~= nil, "instances required in validationContext for validatePackage")
	local instances = p.instances
	local restrictedUserIds = p.restrictedUserIds

	local v, v2 = validateSingleInstance(instances, p)

	if not v then
		return v, v2
	end

	local instance = instances[1]

	local v3 = {}

	if not restrictedUserIds or #restrictedUserIds == 0 then
		return true
	end

	if ParseContentIds.parseWithErrorCheck({}, v3, instance, Constants.PACKAGE_CONTENT_ID_FIELDS, nil, p) then
		return validateAssetCreator(v3, p)
	end

	Analytics.reportFailure(Analytics.ErrorType.validatePackage_FailedToParse, nil, p)

	return
		false,
		{ string.format(
				"Failed to parse package data for model '%s'. Make sure the packageId is valid and try again.",
				instance:GetFullName()
			) }
end

return validatePackage
