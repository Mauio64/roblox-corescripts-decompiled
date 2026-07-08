local ParentParent = script.Parent.Parent
local Promise = require(ParentParent.Parent.Promise)
local Constants = require(ParentParent.Constants)

require(ParentParent.util.BundlesMetadata)
require(ParentParent.util.Types)

local ErrorSourceStrings = require(ParentParent.validationSystem.ErrorSourceStrings)
local createEditableInstancesForContext = require(ParentParent.util.createEditableInstancesForContext)
local destroyEditableInstances = require(ParentParent.util.destroyEditableInstances)

require(ParentParent.validation.validateBundleReadyForUpload)

local getFFlagUGCValidationEnableFolderStructure = require(ParentParent.flags.getFFlagUGCValidationEnableFolderStructure)
local getFFlagUGCValidationAnimationPackSupport = require(ParentParent.flags.getFFlagUGCValidationAnimationPackSupport)
local getFFlagUGCValidationAnimationPackFolderStructure = require(ParentParent.flags.getFFlagUGCValidationAnimationPackFolderStructure)
local LegacyValidationAdapter = require(ParentParent.util.LegacyValidationAdapter)
local HttpService = game:GetService("HttpService")

local function hasExactStringValueNames(p1, t1: {[any]: any}) -- line: 25
	local t2 = {}

	for _, v18 in t1 do
		t2[v18] = true
	end

	local t3 = {}

	for _, child in p1:GetChildren() do
		if not child:IsA("StringValue") then
			continue
		end

		if not t2[child.Name] or t3[child.Name] then
			return false
		end

		t3[child.Name] = true
	end

	for _, v23 in t1 do
		if not t3[v23] then
			return false
		end
	end

	return true
end
local function validateAnimationBundleReadyForUpload(p2, p3, s1: string, p4: ((...any) -> ...any)?, b1: boolean?, p5) -- line: 50
	-- upvalues: Promise (copy), getFFlagUGCValidationAnimationPackSupport (copy), Constants (copy), getFFlagUGCValidationAnimationPackFolderStructure (copy), hasExactStringValueNames (copy), ErrorSourceStrings (copy), getFFlagUGCValidationEnableFolderStructure (copy), HttpService (copy), createEditableInstancesForContext (copy), LegacyValidationAdapter (copy), destroyEditableInstances (copy)
	local u30 = p4 or function() -- line: 58
	end

	assert(u30 ~= nil, "Luau")

	if not p2:IsA("Model") then
		local t4 = {
			errors = {{
				assetType = nil,
				error = {
					type = "message",
					message = "Invalid root instance, must be a model"
				}
			}},
			pieces = {}
		}

		return Promise.resolve(t4)
	end

	local t5 = {}

	if getFFlagUGCValidationAnimationPackSupport() and Constants.ANIMATION_ASSET_INFO then
		local t6 = {}

		if getFFlagUGCValidationAnimationPackFolderStructure() and p2:FindFirstChild("R15Anim") ~= nil then
			local t7 = {}

			for v35, v36 in Constants.ANIMATION_ASSET_INFO do
				for _, child in p2:GetChildren() do
					local v39 = child.Name == "R15Anim" and (child:IsA("Folder") and hasExactStringValueNames(child, v36.stringValueNames))

					if not t7[child] and v39 then
						t5[v35] = { child }
						t7[child] = true

						break
					end
				end
			end

			for _, child in p2:GetChildren() do
				if not t7[child] then
					table.insert(t6, child.Name)
				end
			end
		else
			local t8 = {}

			for _, v44 in Constants.ANIMATION_ASSET_INFO do
				t8[v44.modelName] = true
			end

			for v45, v46 in Constants.ANIMATION_ASSET_INFO do
				local modelName = p2:FindFirstChild(v46.modelName)

				if modelName then
					t5[v45] = { modelName }
				end
			end

			for _, child in p2:GetChildren() do
				if not t8[child.Name] then
					table.insert(t6, child.Name)
				end
			end
		end

		if #t6 > 0 then
			local v50 = string.gsub(ErrorSourceStrings.Values.AnimationPack_UnexpectedBundleChildren, "{unexpectedNames}", table.concat(t6, ", "))
			local t9 = {
				errors = {{
					assetType = nil,
					error = {
						type = "message",
						message = v50
					}
				}},
				pieces = {}
			}

			return Promise.resolve(t9)
		end
	end

	local t10 = {}
	local t11 = {}
	local t12 = {}

	for v55, v56 in p3[s1].allowedAssetTypeSettings do
		local v57 = assert(Enum.AssetType[v55], "Asset type name doesn't map to an enum item")

		if v56.isEligibleForUpload then
			local v58 = t5[v57]
			local v59 = v58 and v58[1]

			t10[v57] = {
				assetType = v57,
				instance = v59,
				settings = v56,
				status = v59 ~= nil and "pending" or "finished"
			}

			if v59 == nil then
				table.insert(t11, {
					assetType = v57,
					error = {
						type = "notFound"
					}
				})
			end
		end
	end

	if getFFlagUGCValidationAnimationPackSupport() and Constants.ANIMATION_ASSET_INFO then
		for v60, _ in Constants.ANIMATION_ASSET_INFO do
			if t10[v60] then
				table.insert(t12, t10[v60])
			end
		end
	end

	local t13 = {
		errors = t11,
		pieces = t12
	}

	u30(t13)

	local guid = nil

	if getFFlagUGCValidationEnableFolderStructure() then
		guid = HttpService:GenerateGUID()
	end

	return Promise.each(t12, function(p6, n1: number) -- line: 213
		-- upvalues: b1 (copy), p5 (copy), createEditableInstancesForContext (copy), getFFlagUGCValidationEnableFolderStructure (copy), LegacyValidationAdapter (copy), guid (ref), destroyEditableInstances (copy), t13 (ref), u30 (ref)
		if p6.status == "finished" then
			return
		end

		assert(p6.instance ~= nil, "Unfinished piece doesn't have an instance")

		local t14 = { p6.instance }
		local t15 = {
			instances = t14,
			assetTypeEnum = p6.assetType,
			allowEditableInstances = b1,
			bypassFlags = p5
		}
		local v68, v69 = createEditableInstancesForContext.processAll(t14, b1)
		local v70

		if not v68 then
			v70 = false
		else
			t15.editableMeshes = v69.editableMeshes
			t15.editableImages = v69.editableImages
			v70 = true
			v69 = nil

			if getFFlagUGCValidationEnableFolderStructure() then
				v70, v69 = LegacyValidationAdapter.studioRFUAssetValidation(t15, guid, v70, v69)
			end

			destroyEditableInstances(t15.editableMeshes, t15.editableImages)
		end

		t13 = table.clone(t13)
		t13.errors = table.clone(t13.errors)

		if not v70 then
			assert(v69 ~= nil, "Failure without errors")

			for _, v72 in v69 do
				table.insert(t13.errors, {
					assetType = p6.assetType,
					error = {
						type = "message",
						message = v72
					}
				})
			end
		end

		t13.pieces = table.clone(t13.pieces)
		t13.pieces[n1].status = "finished"
		u30(t13)
	end):andThen(function() -- line: 274
		-- upvalues: t13 (ref), b1 (copy), p5 (copy), createEditableInstancesForContext (copy), getFFlagUGCValidationEnableFolderStructure (copy), getFFlagUGCValidationAnimationPackSupport (copy), LegacyValidationAdapter (copy), guid (ref), destroyEditableInstances (copy), u30 (ref)
		local function createFullBodyData(t16: {[any]: any}) -- line: 275
			local t17 = {}

			for _, v89 in t16 do
				table.insert(t17, {
					assetTypeEnum = v89.assetType,
					allSelectedInstances = if not v89.instance then {} else { v89.instance }
				})
			end

			return t17
		end

		local v74 = createFullBodyData(t13.pieces)
		local t18 = {
			isServer = false,
			fullBodyData = v74,
			allowEditableInstances = b1,
			bypassFlags = p5
		}
		local t19 = {}

		for _, v78 in v74 do
			for _, v80 in v78.allSelectedInstances do
				table.insert(t19, v80)
			end
		end

		local v81, v82 = createEditableInstancesForContext.processAll(t19, b1)
		local v83

		if not v81 then
			v83 = false
		else
			t18.editableMeshes = v82.editableMeshes
			t18.editableImages = v82.editableImages
			v83 = true
			v82 = nil

			if getFFlagUGCValidationEnableFolderStructure() and getFFlagUGCValidationAnimationPackSupport() then
				v83, v82 = LegacyValidationAdapter.studioRFUBundleValidation(v74, Enum.BundleType.Animations, t18, guid, v83, v82)
			end

			destroyEditableInstances(t18.editableMeshes, t18.editableImages)
		end

		if not v83 then
			t13 = table.clone(t13)
			t13.errors = table.clone(t13.errors)
			assert(v82 and #v82 > 0, "There should always be a reason for failure")

			for _, v85 in v82 do
				table.insert(t13.errors, {
					assetType = nil,
					error = {
						type = "message",
						message = v85
					}
				})
			end
		end

		u30(t13)
	end):andThen(function() -- line: 348
		-- upvalues: t13 (ref)
		return t13
	end)
end

return validateAnimationBundleReadyForUpload
