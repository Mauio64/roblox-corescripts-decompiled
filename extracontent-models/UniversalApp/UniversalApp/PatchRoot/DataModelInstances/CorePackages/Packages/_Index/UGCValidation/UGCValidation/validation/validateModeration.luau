local ParentParent = script.Parent.Parent
local Analytics = require(ParentParent.Analytics)
local Constants = require(ParentParent.Constants)
local getAssetCreationDetails = require(ParentParent.util.getAssetCreationDetails)
local ParseContentIds = require(ParentParent.util.ParseContentIds)

require(ParentParent.util.Types)

local function validateUser(p1, p2, p3) -- line: 11
	if not p1 or #p1 == 0 then
		return true
	end

	local t1 = {}

	for _, v in ipairs(p1) do
		t1[tonumber(v.id)] = true
	end

	for _, v in ipairs(p2) do
		if not t1[tonumber(v.creatorTargetId)] then
			local v16 = p3[tostring(v.assetId)]

			assert(v16)

			return false, { string.format("Failed to validate current user owns %s.%s ( %s ). Make sure you own the assets being validated and try again.", v16.instance:GetFullName(), v16.fieldName, (tostring(v.assetId))) }
		end
	end

	return true
end
local function validateModeration(p4, p5, p6) -- line: 45
	-- upvalues: ParseContentIds (copy), Analytics (copy), getAssetCreationDetails (copy), validateUser (copy), Constants (copy)
	if p6.isServer or p6.allowUnreviewedAssets then
		return true
	end

	local t2 = {}
	local t3 = {}
	local v22, v23 = ParseContentIds.parseWithErrorCheck(t3, t2, p4, nil, nil, p6)

	if not v22 then
		Analytics.reportFailure(Analytics.ErrorType.validateModeration_FailedToParse, nil, p6)

		return false, v23
	end

	local t4 = {}
	local v25, v26 = getAssetCreationDetails(t3)

	if not v25 or #v26 ~= #t3 then
		Analytics.reportFailure(Analytics.ErrorType.validateModeration_CouldNotFetchModerationDetails, nil, p6)

		return false, { string.format("Failed to fetch moderation results for %s. Make sure all assets are owned by the current user.", p4:GetFullName()) }
	end

	local v27, v28 = validateUser(p5, v26, t2)

	if not v27 then
		Analytics.reportFailure(Analytics.ErrorType.validateModeration_ValidateUser, nil, p6)

		return v27, v28
	end

	for _, v in pairs(v26) do
		if v.status == Constants.ASSET_STATUS.UNKNOWN or v.status == Constants.ASSET_STATUS.REVIEW_PENDING or v.status == Constants.ASSET_STATUS.MODERATED then
			table.insert(t4, v.assetId)
		end
	end

	if #t4 > 0 then
		local t5 = {}

		for k, v in pairs(t4) do
			local v34 = t2[v]

			if v34 then
				t5[k] = string.format("%s.%s ( %s )", v34.instance:GetFullName(), v34.fieldName, v)
			else
				t5[k] = v
			end
		end

		Analytics.reportFailure(Analytics.ErrorType.validateModeration_AssetsHaveNotPassedModeration, nil, p6)

		return false, {
			"Asset(s) failed to pass moderation:",
			unpack(t5)
		}
	end

	return true
end

return validateModeration
