local parent = script.Parent.Parent

local Promise = require(parent.Parent.Promise)

game:DefineFastInt("UGCValidationCanPublishRequestPageSize", 50)
game:DefineFastInt("UGCValidationMaxAssetSizeAllowed", 500)

local Analytics = require(parent.Analytics)

local APIUtil = require(parent.util.APIUtil)
require(parent.util.Types)

local HttpService = game:GetService("HttpService")

local baseDomain = APIUtil.getBaseDomain()
local v = string.format("https://apis.%s", baseDomain)

local fastInt = game:GetFastInt("UGCValidationCanPublishRequestPageSize")
local fastInt2 = game:GetFastInt("UGCValidationMaxAssetSizeAllowed")
local Constants = require(parent.Constants)

local FailureReasonsAccumulator = require(parent.util.FailureReasonsAccumulator)

local getFStringUGCValidationReferenceMeshIdWhitelistForIEC = require(parent.flags.getFStringUGCValidationReferenceMeshIdWhitelistForIEC)

local getFFlagUGCValidateRejectUnsupportedCreatorTypes = require(parent.flags.getFFlagUGCValidateRejectUnsupportedCreatorTypes)

local function getWhitelistIds()
	local whitelistIds = {}
	local fStringUGCValidationReferenceMeshIdWhitelistForIEC = getFStringUGCValidationReferenceMeshIdWhitelistForIEC()

	if #fStringUGCValidationReferenceMeshIdWhitelistForIEC == 0 then
		return whitelistIds
	end

	for k in string.gmatch(fStringUGCValidationReferenceMeshIdWhitelistForIEC, "([^,%s]+)") do
		whitelistIds[k] = true
	end

	return whitelistIds
end

local function createCanPublishPromise(url, assetIds, restrictedEntities, token, universeId) -- 2 equivalent calls inferred from this helper
	if #assetIds == 0 then
		return Promise.resolve()
	end

	return Promise.new(function(callback, callback2)
		HttpService:RequestInternal({
			Url = url,
			Method = "POST",
			Body = HttpService:JSONEncode({
				assetIds = assetIds,
				restrictedEntities = restrictedEntities,
				universeId = universeId
			}),
			Headers = {
				[Constants.ExperienceAuthHeaderKey] = token,
				[Constants.ContentType] = Constants.ApplicationJson
			}
		}):Start(function(p, p2)
			if not p or p2.StatusCode ~= 200 then
				callback2()

				return
			end

			callback((HttpService:JSONDecode(p2.Body)))
		end)
	end)
end

local function validateAssetCreator(items, data)
	local isServer = data.isServer
	local restrictedEntities = not data.restrictedUserIds and {} or data.restrictedUserIds
	local token = data.token
	local universeId = data.universeId

	if getFFlagUGCValidateRejectUnsupportedCreatorTypes() then
		for _, v2 in restrictedEntities do
			if v2.creatorType == "Experience" then
				return
					false,
					{ `Experience creators are not supported. CreatorType: Experience, CreatorId: {tostring(v2.id)}.` }
			end

			if v2.creatorType ~= "User" and v2.creatorType ~= "Group" then
				return
					false,
					{ `Unsupported creator type. CreatorType: {tostring(v2.creatorType)}, CreatorId: {tostring(v2.id)}.` }
			end
		end
	else
		local v2 = { User = {}, Group = {} }

		for _, v3 in ipairs(restrictedEntities) do
			v2[v3.creatorType][tonumber(v3.id)] = true
		end
	end

	local url = v .. (isServer and "packages-api/v1/rcc/canPublish" or "packages-api/v1/canPublish")
	local v2 = FailureReasonsAccumulator.new()
	local set = {}
	local count = 0
	local canPublishPromises = {}

	for k, _ in items do
		if set[k] then
			continue
		end

		count += 1
		set[k] = true
	end

	if fastInt2 < count then
		Analytics.reportFailure(Analytics.ErrorType.validateAssetCreator_TooManyDependencies, nil, data)

		return
			false,
			{ "Upload of model has too many children assets (Meshes, Textures, etc.) and cannot be processed as is. You need to rearrange the model." }
	end

	local v3 = {}

	for k, _ in set do
		table.insert(v3, k)

		if not (fastInt <= #v3) then
			continue
		end

		local canPublishPromise = createCanPublishPromise(url, v3, restrictedEntities, token, universeId) -- inferred equivalent call
		table.insert(canPublishPromises, canPublishPromise)
		v3 = {}
	end

	if #v3 > 0 then
		local canPublishPromise = createCanPublishPromise(url, v3, restrictedEntities, token, universeId) -- inferred equivalent call
		table.insert(canPublishPromises, canPublishPromise)
	end

	local v4, v5 = Promise.all(canPublishPromises):await()

	if not v4 then
		Analytics.reportFailure(Analytics.ErrorType.validateAssetCreator_FailedToLoad, nil, data)

		return
			false,
			{ "Failed to load detailed information for model assets. Make sure all model assets exist and try again." }
	end

	local v6 = getFStringUGCValidationReferenceMeshIdWhitelistForIEC() ~= ""
	local v7 = not v6 and {} or getWhitelistIds()

	for _, v8 in v5 do
		local result = v8.result

		for k, v9 in pairs(result) do
			if v6 then
				v9 = v9 or v7[k]
			end

			if not v9 then
				Analytics.reportFailure(Analytics.ErrorType.validateAssetCreator_DependencyNotOwnedByCreator, nil, data)
			end

			local item = items[k]
			v2:updateReasons(v9, {
				(string.format(
					"%s.%s ( %s ) being used is not owned by the experience creator or player. You can only publish assets that you own.",
					item.instance:GetFullName(),
					item.fieldName,
					k
				))
			})
		end
	end

	return v2:getFinalResults()
end

return validateAssetCreator
