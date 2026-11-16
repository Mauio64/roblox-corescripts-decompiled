local parent = script.Parent.Parent

local Promise = require(parent.Parent.Promise)

local Constants = require(parent.Constants)
require(parent.util.BundlesMetadata)
require(parent.util.Types)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)
local createEditableInstancesForContext = require(parent.util.createEditableInstancesForContext)
local destroyEditableInstances = require(parent.util.destroyEditableInstances)

require(parent.validation.validateBundleReadyForUpload)

local LegacyValidationAdapter = require(parent.util.LegacyValidationAdapter)
local HttpService = game:GetService("HttpService")

local function hasExactStringValueNames(folder, stringValueNames): boolean
	local set = {}

	for _, item in stringValueNames do
		set[item] = true
	end

	local nameSet = {}

	for _, stringValue in folder:GetChildren() do
		if not stringValue:IsA("StringValue") then
			continue
		end

		if set[stringValue.Name] and not nameSet[stringValue.Name] then
			nameSet[stringValue.Name] = true
		else
			return false
		end
	end

	for _, item in stringValueNames do
		if not nameSet[item] then
			return false
		end
	end

	return true
end

local function validateAnimationBundleReadyForUpload(model, p, p2: string, callback, allowEditableInstances: boolean?, bypassFlags)
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

	local v2 = {}

	if Constants.ANIMATION_ASSET_INFO then
		local folderSet = {}
		local names = {}
		local names2 = {}

		for k, v3 in Constants.ANIMATION_ASSET_INFO do
			local v4 = false

			for _, folder in model:GetChildren() do
				local v5

				if folder.Name == "R15Anim" then
					v5 = folder:IsA("Folder") and hasExactStringValueNames(folder, v3.stringValueNames)
				else
					v5 = false
				end

				if not folderSet[folder] and v5 then
					v2[k] = { folder }
					folderSet[folder] = true
					v4 = true
					break
				end
			end

			if not v4 then
				table.insert(names, k.Name)
			end
		end

		for _, child in model:GetChildren() do
			if folderSet[child] or child.Name == "R15Anim" then
				continue
			end

			table.insert(names2, child.Name)
		end

		if #names > 0 then
			local v3 = {
				errors = {
					{
						assetType = nil,
						error = {
							type = "message",
							message = string.gsub(
								ErrorSourceStrings.Values.AnimationPack_InvalidR15AnimChildren,
								"{missingAnimationTypes}",
								table.concat(names, ", ")
							)
						}
					}
				},
				pieces = {}
			}

			return Promise.resolve(v3)
		end

		if #names2 > 0 then
			local v3 = {
				errors = {
					{
						assetType = nil,
						error = {
							type = "message",
							message = string.gsub(
								ErrorSourceStrings.Values.AnimationPack_UnexpectedBundleChildren,
								"{unexpectedNames}",
								table.concat(names2, ", ")
							)
						}
					}
				},
				pieces = {}
			}

			return Promise.resolve(v3)
		end
	end

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

	if Constants.ANIMATION_ASSET_INFO then
		for k, _ in Constants.ANIMATION_ASSET_INFO do
			if v3[k] then
				table.insert(pieces2, v3[k])
			end
		end
	end

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

			v7, v6 = LegacyValidationAdapter.studioRFUAssetValidation(v4, guid, true, nil)

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

			v7, v6 = LegacyValidationAdapter.studioRFUBundleValidation(
				fullBodyData,
				Enum.BundleType.Animations,
				v4,
				guid,
				true,
				nil
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

		v(clone)
	end):andThen(function()
		return clone
	end)
end

return validateAnimationBundleReadyForUpload
