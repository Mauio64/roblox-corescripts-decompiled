local ParentParent = script.Parent.Parent
local Promise = require(ParentParent.Parent.Promise)
local ConstantsInterface = require(ParentParent.ConstantsInterface)

require(ParentParent.util.BundlesMetadata)
require(ParentParent.util.Types)

local createEditableInstancesForContext = require(ParentParent.util.createEditableInstancesForContext)
local destroyEditableInstances = require(ParentParent.util.destroyEditableInstances)
local createUGCBodyPartFolders = require(ParentParent.util.createUGCBodyPartFolders)
local fixUpPreValidation = require(ParentParent.util.fixUpPreValidation)
local validateInternal = require(ParentParent.validation.validateInternal)
local validateFullBody = require(ParentParent.validation.validateFullBody)
local getFFlagUGCValidationEnableFolderStructure = require(ParentParent.flags.getFFlagUGCValidationEnableFolderStructure)
local LegacyValidationAdapter = require(ParentParent.util.LegacyValidationAdapter)
local HttpService = game:GetService("HttpService")
local t1 = {
	Enum.AssetType.DynamicHead,
	Enum.AssetType.Torso,
	Enum.AssetType.LeftArm,
	Enum.AssetType.RightArm,
	Enum.AssetType.LeftLeg,
	Enum.AssetType.RightLeg,
	Enum.AssetType.HairAccessory,
	Enum.AssetType.EyebrowAccessory,
	Enum.AssetType.EyelashAccessory
}

local function validateBundleReadyForUpload(p1, p2, p3, p4: ((...any) -> ...any)?, b1: boolean?, p5) -- line: 57
	-- upvalues: Promise (copy), fixUpPreValidation (copy), createUGCBodyPartFolders (copy), t1 (copy), getFFlagUGCValidationEnableFolderStructure (copy), HttpService (copy), createEditableInstancesForContext (copy), validateInternal (copy), LegacyValidationAdapter (copy), destroyEditableInstances (copy), ConstantsInterface (copy), validateFullBody (copy)
	local u21 = p4 or function() -- line: 65
	end

	assert(u21 ~= nil, "Luau")

	if not p1:IsA("Model") then
		local t2 = {
			errors = {{
				assetType = nil,
				error = {
					type = "message",
					message = "Invalid root instance, must be a model"
				}
			}},
			pieces = {}
		}

		return Promise.resolve(t2)
	end

	local v23 = fixUpPreValidation(p1)
	local v24 = createUGCBodyPartFolders(v23, p2, p3, false)
	local t3 = {}
	local t4 = {}

	for v27, v28 in p2[p3].allowedAssetTypeSettings do
		local v29 = assert(Enum.AssetType[v27], "Asset type name doesn't map to an enum item")

		if v28.isEligibleForUpload then
			assert(v28.minimumQuantity == 0 or v28.minimumQuantity == 1, "Invalid minimum quantity, createUGCBodyParts folder is a dictionary and will only ever give one.")
			assert(v28.maximumQuantity == 0 or v28.maximumQuantity == 1, "Invalid maximum quantity, createUGCBodyParts folder is a dictionary and will only ever give one.")

			local v30 = v24[v29]
			local v31 = v30 and v30[1]

			if v28.minimumQuantity ~= 0 or v31 ~= nil then
				table.insert(t4, {
					assetType = v29,
					instance = v31,
					settings = v28,
					status = v31 ~= nil and "pending" or "finished"
				})

				if v31 == nil then
					table.insert(t3, {
						assetType = v29,
						error = {
							type = "notFound"
						}
					})
				end
			end
		end
	end

	table.sort(t4, function(p6, p7) -- line: 142
		-- upvalues: t1 (copy)
		return (table.find(t1, p6.assetType) or 1e999) < (table.find(t1, p7.assetType) or 1e999)
	end)

	local t5 = {
		errors = t3,
		pieces = t4
	}

	u21(t5)

	local guid = nil

	if getFFlagUGCValidationEnableFolderStructure() then
		guid = HttpService:GenerateGUID()
	end

	return Promise.each(t4, function(t6: {[any]: any}, n1: number) -- line: 161
		-- upvalues: b1 (copy), p5 (copy), createEditableInstancesForContext (copy), validateInternal (copy), getFFlagUGCValidationEnableFolderStructure (copy), LegacyValidationAdapter (copy), guid (ref), destroyEditableInstances (copy), t5 (ref), u21 (ref)
		if t6.status == "finished" then
			return
		end

		assert(t6.instance ~= nil, "Unfinished piece doesn't have an instnace")

		local t7 = { t6.instance }
		local t8 = {
			allowUnreviewedAssets = false,
			isServer = false,
			isAsync = false,
			validateMeshPartAccessories = true,
			requireAllFolders = false,
			instances = t7,
			assetTypeEnum = t6.assetType,
			allowEditableInstances = b1,
			bypassFlags = p5
		}
		local v40, v41 = createEditableInstancesForContext.processAll(t7, b1)
		local v42

		if not v40 then
			v42 = false
		else
			t8.editableMeshes = v41.editableMeshes
			t8.editableImages = v41.editableImages
			v42, v41 = validateInternal(t8)

			if getFFlagUGCValidationEnableFolderStructure() then
				v42, v41 = LegacyValidationAdapter.studioRFUAssetValidation(t8, guid, v42, v41)
			end

			destroyEditableInstances(t8.editableMeshes, t8.editableImages)
		end

		t5 = table.clone(t5)
		t5.errors = table.clone(t5.errors)

		if not v42 then
			assert(v41 ~= nil, "Failure without errors")

			for _, v44 in v41 do
				table.insert(t5.errors, {
					assetType = t6.assetType,
					error = {
						type = "message",
						message = v44
					}
				})
			end
		end

		t5.pieces = table.clone(t5.pieces)
		t5.pieces[n1].status = "finished"
		u21(t5)
	end):andThen(function() -- line: 228
		-- upvalues: p3 (copy), ConstantsInterface (copy), t5 (ref), b1 (copy), p5 (copy), createEditableInstancesForContext (copy), validateFullBody (copy), getFFlagUGCValidationEnableFolderStructure (copy), LegacyValidationAdapter (copy), guid (ref), destroyEditableInstances (copy), u21 (ref)
		if p3 == "Body" then
			local function createFullBodyData(t9: {[any]: any}) -- line: 230
				-- upvalues: ConstantsInterface (copy)
				local t10 = {}

				for _, v61 in t9 do
					if ConstantsInterface.isBodyPart(v61.assetType) then
						table.insert(t10, {
							assetTypeEnum = v61.assetType,
							allSelectedInstances = if not v61.instance then {} else { v61.instance }
						})
					end
				end

				return t10
			end

			local v46 = createFullBodyData(t5.pieces)
			local t11 = {
				isServer = false,
				validateMeshPartAccessories = false,
				requireAllFolders = false,
				fullBodyData = v46,
				allowEditableInstances = b1,
				bypassFlags = p5
			}
			local t12 = {}

			for _, v50 in v46 do
				for _, v52 in v50.allSelectedInstances do
					table.insert(t12, v52)
				end
			end

			local v53, v54 = createEditableInstancesForContext.processAll(t12, b1)
			local v55

			if not v53 then
				v55 = false
			else
				t11.editableMeshes = v54.editableMeshes
				t11.editableImages = v54.editableImages
				v55, v54 = validateFullBody(t11)

				if getFFlagUGCValidationEnableFolderStructure() then
					v55, v54 = LegacyValidationAdapter.studioRFUBundleValidation(v46, Enum.BundleType.BodyParts, t11, guid, v55, v54)
				end

				destroyEditableInstances(t11.editableMeshes, t11.editableImages)
			end

			if not v55 then
				t5 = table.clone(t5)
				t5.errors = table.clone(t5.errors)
				assert(v54 and #v54 > 0, "There should always be a reason for failure")

				for _, v57 in v54 do
					table.insert(t5.errors, {
						assetType = nil,
						error = {
							type = "message",
							message = v57
						}
					})
				end
			end

			u21(t5)
		end
	end):andThen(function() -- line: 311
		-- upvalues: t5 (ref)
		return t5
	end)
end

return validateBundleReadyForUpload
