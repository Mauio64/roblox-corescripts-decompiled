local parent = script.Parent.Parent

require(parent.util.Types)
local createUGCBodyPartFolders = require(parent.util.createUGCBodyPartFolders)
local fixUpPreValidation = require(parent.util.fixUpPreValidation)

local HttpService = game:GetService("HttpService")

local AssetQualityValidationClient = {}

function AssetQualityValidationClient.getAssetQualityService()
	return game:GetService("AssetQualityService")
end

function AssetQualityValidationClient.buildSettings(data)
	local options = { ConsumerName = data.source }

	if data.intendedBundleType then
		options.IntendedBundleTypeId = tostring(data.intendedBundleType.Value)
	end

	if data.validateSingleAssetsInBundle then
		options.ValidateSingleAssetsInBundle = "true"
	end

	if data.backendConfigs then
		options.LegacyValidationConfigs = HttpService:JSONEncode({
			allowedCreators = data.backendConfigs.restrictedUserIds,
			universeId = data.backendConfigs.universeId,
			isUserInTrustedCreatorProgram = data.backendConfigs.isUserInTrustedCreatorProgram,
			isEmissiveAllowed = data.backendConfigs.isEmissiveAllowed
		})
	end

	local settings = {
		postQualitySteps = { "validation" },
		options = options
	}

	if data.mode then
		settings.mode = data.mode
	end

	return settings
end

function AssetQualityValidationClient.createSingleAssetInput(p, assetType)
	local success, result = pcall(fixUpPreValidation, p)

	if not success then
		error(result, 0)
	end

	local model = Instance.new("Model")
	model.Name = p.Name
	result.Parent = model
	return { model = model, assetType = assetType }
end

function AssetQualityValidationClient.createBodyInputs(p, p2, p3: string)
	local v = fixUpPreValidation(p)
	local bodyInputs = {}
	local success, result = pcall(function()
		local ugcBodyPartFolders = createUGCBodyPartFolders(v, p2, p3, true)

		for k, ugcBodyPartFolder in ugcBodyPartFolders do
			local model = Instance.new("Model")

			for _, v2 in ugcBodyPartFolder do
				v2.Parent = model
			end

			table.insert(bodyInputs, { model = model, assetType = k })
		end
	end)
	v:Destroy()

	if not success then
		for _, bodyInput in bodyInputs do
			bodyInput.model:Destroy()
		end

		error(result, 0)
	end

	return bodyInputs
end

function AssetQualityValidationClient.fetch(list, p)
	local assetQualityService = AssetQualityValidationClient.getAssetQualityService()
	local models = {}
	local v = {}

	for _, item in list do
		table.insert(models, item.model)
		table.insert(v, item.assetType.Value)
	end

	local success, result = pcall(function()
		local assetQualityValidationRawFromModelsAsync = assetQualityService:FetchAssetQualityValidationRawFromModelsAsync(
			models,
			v,
			AssetQualityValidationClient.buildSettings(p)
		)

		if
			typeof(assetQualityValidationRawFromModelsAsync) == "table"
			and typeof(assetQualityValidationRawFromModelsAsync.error) == "string"
		then
			local taskId

			if typeof(assetQualityValidationRawFromModelsAsync.taskId) == "string" then
				taskId = assetQualityValidationRawFromModelsAsync.taskId
			end

			local v2

			if taskId then
				v2 = `{assetQualityValidationRawFromModelsAsync.error} (taskId: {taskId})`
			else
				v2 = assetQualityValidationRawFromModelsAsync.error
			end

			error(v2, 0)
		end

		local validationRawJson

		if typeof(assetQualityValidationRawFromModelsAsync) == "table" then
			validationRawJson = assetQualityValidationRawFromModelsAsync.validationRawJson
		end

		if typeof(validationRawJson) ~= "string" then
			error("AssetQualityService returned no validationRawJson", 0)
		end

		local success, result = pcall(HttpService.JSONDecode, HttpService, validationRawJson)

		if not success or typeof(result) ~= "table" then
			error("Failed to decode validationRawJson from AssetQualityService", 0)
		end

		return result
	end)

	for _, item in list do
		item.model:Destroy()
	end

	if not success then
		error(result, 0)
	end

	local v2 = #list == 1 or p.validateSingleAssetsInBundle == true
	local result2 = {}

	for k, validationData in result do
		local assetType

		if v2 and list[k] then
			assetType = list[k].assetType
		end

		table.insert(result2, { validationData = validationData, assetType = assetType })
	end

	return result2
end

return AssetQualityValidationClient
