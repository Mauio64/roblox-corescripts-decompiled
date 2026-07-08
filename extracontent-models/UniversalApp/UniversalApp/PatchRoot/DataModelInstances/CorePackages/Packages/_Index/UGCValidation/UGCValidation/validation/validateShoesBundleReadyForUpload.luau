local ParentParent = script.Parent.Parent
local Promise = require(ParentParent.Parent.Promise)

require(ParentParent.util.BundlesMetadata)
require(ParentParent.util.Types)

local createEditableInstancesForContext = require(ParentParent.util.createEditableInstancesForContext)
local destroyEditableInstances = require(ParentParent.util.destroyEditableInstances)

require(ParentParent.util.createUGCBodyPartFolders)

local fixUpPreValidation = require(ParentParent.util.fixUpPreValidation)
local validateInternal = require(ParentParent.validation.validateInternal)
local validateShoes = require(ParentParent.validation.validateShoes)

require(ParentParent.validation.validateBundleReadyForUpload)

local v8 = game:DefineFastFlag("ValidateFullShoesBundleStudio", false)
local getFFlagUGCValidationEnableFolderStructure = require(ParentParent.flags.getFFlagUGCValidationEnableFolderStructure)
local LegacyValidationAdapter = require(ParentParent.util.LegacyValidationAdapter)
local HttpService = game:GetService("HttpService")

local function validateShoesBundleReadyForUpload(p1, p2, p3, p4: ((...any) -> ...any)?, b1: boolean?, p5) -- line: 26
	-- upvalues: Promise (copy), fixUpPreValidation (copy), getFFlagUGCValidationEnableFolderStructure (copy), HttpService (copy), createEditableInstancesForContext (copy), validateInternal (copy), LegacyValidationAdapter (copy), destroyEditableInstances (copy), v8 (copy), validateShoes (copy)
	local u19 = p4 or function() -- line: 34
	end

	assert(u19 ~= nil, "Luau")

	if not p1:IsA("Model") then
		local t1 = {
			errors = {{
				assetType = nil,
				error = {
					type = "message",
					message = "Invalid root instance, must be a model"
				}
			}},
			pieces = {}
		}

		return Promise.resolve(t1)
	end

	local LeftShoeAccessory = p1:FindFirstChild("LeftShoeAccessory")
	local RightShoeAccessory = p1:FindFirstChild("RightShoeAccessory")

	if not LeftShoeAccessory or not LeftShoeAccessory:IsA("Accessory") or not RightShoeAccessory or not RightShoeAccessory:IsA("Accessory") then
		local t2 = {
			errors = {{
				assetType = nil,
				error = {
					type = "message",
					message = "Shoes must of type 'Accessory' and names must be 'LeftShoeAccessory' and 'RightShoeAccessory'"
				}
			}},
			pieces = {}
		}

		return Promise.resolve(t2)
	end

	local t3 = {
		[Enum.AssetType.LeftShoeAccessory] = { fixUpPreValidation(LeftShoeAccessory) },
		[Enum.AssetType.RightShoeAccessory] = { fixUpPreValidation(RightShoeAccessory) }
	}
	local t4 = {}
	local t5 = {}
	local t6 = {}

	for v28, v29 in p2[p3].allowedAssetTypeSettings do
		local v30 = assert(Enum.AssetType[v28], "Asset type name doesn't map to an enum item")

		if v29.isEligibleForUpload then
			local v31 = t3[v30]
			local v32 = v31 and v31[1]

			t4[v30] = {
				assetType = v30,
				instance = v32,
				settings = v29,
				status = v32 ~= nil and "pending" or "finished"
			}

			if v32 == nil then
				table.insert(t5, {
					assetType = v30,
					error = {
						type = "notFound"
					}
				})
			end
		end
	end

	table.insert(t6, t4[Enum.AssetType.LeftShoeAccessory])
	table.insert(t6, t4[Enum.AssetType.RightShoeAccessory])

	local t7 = {
		errors = t5,
		pieces = t6
	}

	u19(t7)

	local guid = nil

	if getFFlagUGCValidationEnableFolderStructure() then
		guid = HttpService:GenerateGUID()
	end

	return Promise.each(t6, function(p6, n1: number) -- line: 128
		-- upvalues: b1 (copy), p5 (copy), createEditableInstancesForContext (copy), validateInternal (copy), getFFlagUGCValidationEnableFolderStructure (copy), LegacyValidationAdapter (copy), guid (ref), destroyEditableInstances (copy), t7 (ref), u19 (ref)
		if p6.status == "finished" then
			return
		end

		assert(p6.instance ~= nil, "Unfinished piece doesn't have an instance")

		local t8 = { p6.instance }
		local t9 = {
			instances = t8,
			assetTypeEnum = p6.assetType,
			allowEditableInstances = b1,
			bypassFlags = p5
		}
		local v39, v40 = createEditableInstancesForContext.processAll(t8, b1)
		local v41

		if not v39 then
			v41 = false
		else
			t9.editableMeshes = v40.editableMeshes
			t9.editableImages = v40.editableImages
			v41, v40 = validateInternal(t9)

			if getFFlagUGCValidationEnableFolderStructure() then
				v41, v40 = LegacyValidationAdapter.studioRFUAssetValidation(t9, guid, v41, v40)
			end

			destroyEditableInstances(t9.editableMeshes, t9.editableImages)
		end

		t7 = table.clone(t7)
		t7.errors = table.clone(t7.errors)

		if not v41 then
			assert(v40 ~= nil, "Failure without errors")

			for _, v43 in v40 do
				table.insert(t7.errors, {
					assetType = p6.assetType,
					error = {
						type = "message",
						message = v43
					}
				})
			end
		end

		t7.pieces = table.clone(t7.pieces)
		t7.pieces[n1].status = "finished"
		u19(t7)
	end):andThen(function() -- line: 190
		-- upvalues: v8 (copy), t7 (ref), b1 (copy), p5 (copy), createEditableInstancesForContext (copy), validateShoes (copy), getFFlagUGCValidationEnableFolderStructure (copy), LegacyValidationAdapter (copy), guid (ref), destroyEditableInstances (copy), u19 (ref)
		if v8 then
			local function createFullBodyData(t10: {[any]: any}) -- line: 192
				local t11 = {}

				for _, v60 in t10 do
					table.insert(t11, {
						assetTypeEnum = v60.assetType,
						allSelectedInstances = if not v60.instance then {} else { v60.instance }
					})
				end

				return t11
			end

			local v45 = createFullBodyData(t7.pieces)
			local t12 = {
				isServer = false,
				fullBodyData = v45,
				allowEditableInstances = b1,
				bypassFlags = p5
			}
			local t13 = {}

			for _, v49 in v45 do
				for _, v51 in v49.allSelectedInstances do
					table.insert(t13, v51)
				end
			end

			local v52, v53 = createEditableInstancesForContext.processAll(t13, b1)
			local v54

			if not v52 then
				v54 = false
			else
				t12.editableMeshes = v53.editableMeshes
				t12.editableImages = v53.editableImages
				v54, v53 = validateShoes(t12)

				if getFFlagUGCValidationEnableFolderStructure() then
					v54, v53 = LegacyValidationAdapter.studioRFUBundleValidation(v45, Enum.BundleType.Shoes, t12, guid, v54, v53)
				end

				destroyEditableInstances(t12.editableMeshes, t12.editableImages)
			end

			if not v54 then
				t7 = table.clone(t7)
				t7.errors = table.clone(t7.errors)
				assert(v53 and #v53 > 0, "There should always be a reason for failure")

				for _, v56 in v53 do
					table.insert(t7.errors, {
						assetType = nil,
						error = {
							type = "message",
							message = v56
						}
					})
				end
			end
		end

		u19(t7)
	end):andThen(function() -- line: 267
		-- upvalues: t7 (ref)
		return t7
	end)
end

return validateShoesBundleReadyForUpload
