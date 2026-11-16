local parent = script.Parent.Parent

local Promise = require(parent.Parent.Promise)

require(parent.util.BundlesMetadata)
require(parent.util.Types)
local createEditableInstancesForContext = require(parent.util.createEditableInstancesForContext)
local destroyEditableInstances = require(parent.util.destroyEditableInstances)
require(parent.util.createUGCBodyPartFolders)
local fixUpPreValidation = require(parent.util.fixUpPreValidation)

local validateInternal = require(parent.validation.validateInternal)
local validateShoes = require(parent.validation.validateShoes)
require(parent.validation.validateBundleReadyForUpload)

local defineFastFlag = game:DefineFastFlag("ValidateFullShoesBundleStudio", false)
local LegacyValidationAdapter = require(parent.util.LegacyValidationAdapter)
local HttpService = game:GetService("HttpService")

local function validateShoesBundleReadyForUpload(model, p, p2, callback, allowEditableInstances: boolean?, bypassFlags)
	local v = callback or function() end
	assert(v ~= nil, "Luau")

	if not model:IsA("Model") then
		return Promise.resolve({
			errors = {
				{
					assetType = nil,
					error = { type = "message", message = "Invalid root instance, must be a model" }
				}
			},
			pieces = {}
		})
	end

	local leftShoeAccessory = model:FindFirstChild("LeftShoeAccessory")
	local rightShoeAccessory = model:FindFirstChild("RightShoeAccessory")

	if not (leftShoeAccessory and leftShoeAccessory:IsA("Accessory") and rightShoeAccessory and rightShoeAccessory:IsA("Accessory")) then
		return Promise.resolve({
			errors = {
				{
					assetType = nil,
					error = {
						type = "message",
						message = "Shoes must of type 'Accessory' and names must be 'LeftShoeAccessory' and 'RightShoeAccessory'"
					}
				}
			},
			pieces = {}
		})
	end

	local v2 = {
		[Enum.AssetType.LeftShoeAccessory] = { fixUpPreValidation(leftShoeAccessory) },
		[Enum.AssetType.RightShoeAccessory] = { fixUpPreValidation(rightShoeAccessory) }
	}

	local v3 = {}

	local errors = {}
	local pieces2 = {}

	for k, allowedAssetTypeSetting in p[p2].allowedAssetTypeSettings do
		local assetType = assert(Enum.AssetType[k], "Asset type name doesn't map to an enum item")

		if not allowedAssetTypeSetting.isEligibleForUpload then
			continue
		end

		local v4 = v2[assetType]
		local instance = v4 and v4[1]

		v3[assetType] = {
			assetType = assetType,
			instance = instance,
			settings = allowedAssetTypeSetting,
			status = instance == nil and "finished" or "pending"
		}

		if instance == nil then
			table.insert(errors, {
				assetType = assetType,
				error = { type = "notFound" }
			})
		end
	end

	table.insert(pieces2, v3[Enum.AssetType.LeftShoeAccessory])
	table.insert(pieces2, v3[Enum.AssetType.RightShoeAccessory])

	local clone = { errors = 0, pieces = 0 }
	clone.errors = errors
	clone.pieces = pieces2

	v(clone)

	local guid = HttpService:GenerateGUID()

	return Promise.each(pieces2, function(data, p3: number)
		if data.status == "finished" then
			return
		end

		assert(data.instance ~= nil, "Unfinished piece doesn't have an instance")

		local instances = { data.instance }
		local v4 = {
			instances = instances,
			assetTypeEnum = data.assetType,
			allowEditableInstances = allowEditableInstances,
			bypassFlags = bypassFlags
		}

		local v5, v6 = createEditableInstancesForContext.processAll(instances, allowEditableInstances)
		local v7

		if v5 then
			v4.editableMeshes = v6.editableMeshes
			v4.editableImages = v6.editableImages

			local v8, v9 = validateInternal(v4)
			v7, v6 = LegacyValidationAdapter.studioRFUAssetValidation(v4, guid, v8, v9)

			destroyEditableInstances(v4.editableMeshes, v4.editableImages)
		else
			v7 = false
		end

		clone = table.clone(clone)
		clone.errors = table.clone(clone.errors)

		if not v7 then
			assert(v6 ~= nil, "Failure without errors")

			for _, message in v6 do
				table.insert(clone.errors, {
					assetType = data.assetType,
					error = { type = "message", message = message }
				})
			end
		end

		clone.pieces = table.clone(clone.pieces)
		clone.pieces[p3].status = "finished"

		v(clone)
	end):andThen(function()
		if defineFastFlag then
			local function createFullBodyData(pieces)
				local fullBodyData = {}

				for _, item in pieces do
					table.insert(fullBodyData, {
						assetTypeEnum = item.assetType,
						allSelectedInstances = item.instance and { item.instance } or {}
					})
				end

				return fullBodyData
			end

			local fullBodyData = createFullBodyData(clone.pieces)

			local v4 = {
				fullBodyData = fullBodyData,
				isServer = false,
				allowEditableInstances = allowEditableInstances,
				bypassFlags = bypassFlags
			}

			local allSelectedInstances = {}

			for _, v5 in fullBodyData do
				for _, allSelectedInstance in v5.allSelectedInstances do
					table.insert(allSelectedInstances, allSelectedInstance)
				end
			end

			local v5, v6 = createEditableInstancesForContext.processAll(allSelectedInstances, allowEditableInstances)
			local v7

			if v5 then
				v4.editableMeshes = v6.editableMeshes
				v4.editableImages = v6.editableImages

				local v8, v9 = validateShoes(v4)
				v7, v6 = LegacyValidationAdapter.studioRFUBundleValidation(
					fullBodyData,
					Enum.BundleType.Shoes,
					v4,
					guid,
					v8,
					v9
				)

				destroyEditableInstances(v4.editableMeshes, v4.editableImages)
			else
				v7 = false
			end

			if not v7 then
				clone = table.clone(clone)
				clone.errors = table.clone(clone.errors)

				assert(v6 and #v6 > 0, "There should always be a reason for failure")

				for _, message in v6 do
					table.insert(clone.errors, {
						assetType = nil,
						error = { type = "message", message = message }
					})
				end
			end
		end

		v(clone)
	end):andThen(function()
		return clone
	end)
end

return validateShoesBundleReadyForUpload
