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
			if p and p2.StatusCode == 200 then
				callback((HttpService:JSONDecode(p2.Body)))
			else
				callback2()
			end
		end)
	end)
end

local function validateAssetCreator(items, data)
	local isServer = data.isServer
	local restrictedEntities = not data.restrictedUserIds and {} or data.restrictedUserIds
	local token = data.token
	local universeId = data.universeId

	local url = v .. (isServer and "packages-api/v1/rcc/canPublish" or "packages-api/v1/canPublish")

	local v2 = FailureReasonsAccumulator.new()
	local v3 = { User = {}, Group = {} }

	local set = {}
	local count = 0
	local canPublishPromises = {}

	for _, v4 in ipairs(restrictedEntities) do
		v3[v4.creatorType][tonumber(v4.id)] = true
	end

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

	local v4 = {}

	for k, _ in set do
		table.insert(v4, k)

		if not (fastInt <= #v4) then
			continue
		end

		local canPublishPromise = createCanPublishPromise(url, v4, restrictedEntities, token, universeId) -- inferred equivalent call
		table.insert(canPublishPromises, canPublishPromise)
		v4 = {}
	end

	if #v4 > 0 then
		local canPublishPromise = createCanPublishPromise(url, v4, restrictedEntities, token, universeId) -- inferred equivalent call
		table.insert(canPublishPromises, canPublishPromise)
	end

	local v5, v6 = Promise.all(canPublishPromises):await()

	if not v5 then
		Analytics.reportFailure(Analytics.ErrorType.validateAssetCreator_FailedToLoad, nil, data)

		return
			false,
			{ "Failed to load detailed information for model assets. Make sure all model assets exist and try again." }
	end

	local v7 = getFStringUGCValidationReferenceMeshIdWhitelistForIEC() ~= ""
	local v8 = not v7 and {} or getWhitelistIds()

	for _, v9 in v6 do
		local result = v9.result

		for k, v10 in pairs(result) do
			if v7 then
				v10 = v10 or v8[k]
			end

			if not v10 then
				Analytics.reportFailure(Analytics.ErrorType.validateAssetCreator_DependencyNotOwnedByCreator, nil, data)
			end

			local item = items[k]
			v2:updateReasons(v10, {
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
