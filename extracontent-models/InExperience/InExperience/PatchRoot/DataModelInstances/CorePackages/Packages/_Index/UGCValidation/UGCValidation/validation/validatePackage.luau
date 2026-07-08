local ParentParent = script.Parent.Parent
local Analytics = require(ParentParent.Analytics)
local Constants = require(ParentParent.Constants)
local validateSingleInstance = require(ParentParent.validation.validateSingleInstance)
local validateAssetCreator = require(ParentParent.validation.validateAssetCreator)
local ParseContentIds = require(ParentParent.util.ParseContentIds)

require(ParentParent.util.Types)

local function validatePackage(p1) -- line: 12
	-- upvalues: validateSingleInstance (copy), ParseContentIds (copy), Constants (copy), Analytics (copy), validateAssetCreator (copy)
	assert(p1.instances ~= nil, "instances required in validationContext for validatePackage")

	local instances = p1.instances
	local restrictedUserIds = p1.restrictedUserIds
	local v11, v12 = validateSingleInstance(instances, p1)

	if not v11 then
		return v11, v12
	end

	local v13 = instances[1]
	local t1 = {}

	if not restrictedUserIds or #restrictedUserIds == 0 then
		return true
	end

	if not ParseContentIds.parseWithErrorCheck({}, t1, v13, Constants.PACKAGE_CONTENT_ID_FIELDS, nil, p1) then
		Analytics.reportFailure(Analytics.ErrorType.validatePackage_FailedToParse, nil, p1)

		return false, { string.format("Failed to parse package data for model '%s'. Make sure the packageId is valid and try again.", v13:GetFullName()) }
	end

	return validateAssetCreator(t1, p1)
end

return validatePackage
