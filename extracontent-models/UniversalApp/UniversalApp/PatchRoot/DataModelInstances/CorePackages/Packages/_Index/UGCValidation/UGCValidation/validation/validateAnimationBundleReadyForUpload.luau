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
local getFFlagUGCValidationAnimationPackDisableModelStructure = require(ParentParent.flags.getFFlagUGCValidationAnimationPackDisableModelStructure)
local getFFlagUGCValidationAnimationPackMissingTypeMessage = require(ParentParent.flags.getFFlagUGCValidationAnimationPackMissingTypeMessage)
local LegacyValidationAdapter = require(ParentParent.util.LegacyValidationAdapter)
local HttpService = game:GetService("HttpService")

local function hasExactStringValueNames(p1, t1: {[any]: any}) -- line: 29
	local t2 = {}

	for _, v20 in t1 do
		t2[v20] = true
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

	for _, v25 in t1 do
		if not t3[v25] then
			return false
		end
	end

	return true
end
local function validateAnimationBundleReadyForUpload(p2, p3, s1: string, p4: ((...any) -> ...any)?, b1: boolean?, p5) -- line: 54
	-- upvalues: Promise (copy), getFFlagUGCValidationAnimationPackSupport (copy), Constants (copy), getFFlagUGCValidationAnimationPackDisableModelStructure (copy), getFFlagUGCValidationAnimationPackFolderStructure (copy), hasExactStringValueNames (copy), getFFlagUGCValidationAnimationPackMissingTypeMessage (copy), ErrorSourceStrings (copy), getFFlagUGCValidationEnableFolderStructure (copy), HttpService (copy), createEditableInstancesForContext (copy), LegacyValidationAdapter (copy), destroyEditableInstances (copy)
	local u32 = p4 or function() -- line: 62
	end

	assert(u32 ~= nil, "Luau")

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
		local t7 = {}

		if getFFlagUGCValidationAnimationPackDisableModelStructure() or getFFlagUGCValidationAnimationPackFolderStructure() and p2:FindFirstChild("R15Anim") ~= nil then
			local t8 = {}

			for v38, v39 in Constants.ANIMATION_ASSET_INFO do
				local v40 = false

				for _, child in p2:GetChildren() do
					local v43 = child.Name == "R15Anim" and (child:IsA("Folder") and hasExactStringValueNames(child, v39.stringValueNames))

					if not t8[child] and v43 then
						t5[v38] = { child }
						t8[child] = true
						v40 = true

						break
					end
				end

				if not v40 then
					table.insert(t7, v38.Name)
				end
			end

			for _, child in p2:GetChildren() do
				if not t8[child] and (child.Name ~= "R15Anim" or not getFFlagUGCValidationAnimationPackMissingTypeMessage()) then
					table.insert(t6, child.Name)
				end
			end
		else
			local t9 = {}

			for _, v48 in Constants.ANIMATION_ASSET_INFO do
				t9[v48.modelName] = true
			end

			for v49, v50 in Constants.ANIMATION_ASSET_INFO do
				local modelName = p2:FindFirstChild(v50.modelName)

				if modelName then
					t5[v49] = { modelName }
				end
			end

			for _, child in p2:GetChildren() do
				if not t9[child.Name] then
					table.insert(t6, child.Name)
				end
			end
		end

		if getFFlagUGCValidationAnimationPackMissingTypeMessage() and #t7 > 0 then
			local v54 = string.gsub(ErrorSourceStrings.Values.AnimationPack_InvalidR15AnimChildren, "{missingAnimationTypes}", table.concat(t7, ", "))
			local t10 = {
				errors = {{
					assetType = nil,
					error = {
						type = "message",
						message = v54
					}
				}},
				pieces = {}
			}

			return Promise.resolve(t10)
		end

		if #t6 > 0 then
			local v56 = string.gsub(ErrorSourceStrings.Values.AnimationPack_UnexpectedBundleChildren, "{unexpectedNames}", table.concat(t6, ", "))
			local t11 = {
				errors = {{
					assetType = nil,
					error = {
						type = "message",
						message = v56
					}
				}},
				pieces = {}
			}

			return Promise.resolve(t11)
		end
	end

	local t12 = {}
	local t13 = {}
	local t14 = {}

	for v61, v62 in p3[s1].allowedAssetTypeSettings do
		local v63 = assert(Enum.AssetType[v61], "Asset type name doesn't map to an enum item")

		if v62.isEligibleForUpload then
			local v64 = t5[v63]
			local v65 = v64 and v64[1]

			t12[v63] = {
				assetType = v63,
				instance = v65,
				settings = v62,
				status = v65 ~= nil and "pending" or "finished"
			}

			if v65 == nil then
				table.insert(t13, {
					assetType = v63,
					error = {
						type = "notFound"
					}
				})
			end
		end
	end

	if getFFlagUGCValidationAnimationPackSupport() and Constants.ANIMATION_ASSET_INFO then
		for v66, _ in Constants.ANIMATION_ASSET_INFO do
			if t12[v66] then
				table.insert(t14, t12[v66])
			end
		end
	end

	local t15 = {
		errors = t13,
		pieces = t14
	}

	u32(t15)

	local guid = nil

	if getFFlagUGCValidationEnableFolderStructure() then
		guid = HttpService:GenerateGUID()
	end

	return Promise.each(t14, function(p6, n1: number) -- line: 251
		-- upvalues: b1 (copy), p5 (copy), createEditableInstancesForContext (copy), getFFlagUGCValidationEnableFolderStructure (copy), LegacyValidationAdapter (copy), guid (ref), destroyEditableInstances (copy), t15 (ref), u32 (ref)
		if p6.status == "finished" then
			return
		end

		assert(p6.instance ~= nil, "Unfinished piece doesn't have an instance")

		local t16 = { p6.instance }
		local t17 = {
			instances = t16,
			assetTypeEnum = p6.assetType,
			allowEditableInstances = b1,
			bypassFlags = p5
		}
		local v74, v75 = createEditableInstancesForContext.processAll(t16, b1)
		local v76

		if not v74 then
			v76 = false
		else
			t17.editableMeshes = v75.editableMeshes
			t17.editableImages = v75.editableImages
			v76 = true
			v75 = nil

			if getFFlagUGCValidationEnableFolderStructure() then
				v76, v75 = LegacyValidationAdapter.studioRFUAssetValidation(t17, guid, v76, v75)
			end

			destroyEditableInstances(t17.editableMeshes, t17.editableImages)
		end

		t15 = table.clone(t15)
		t15.errors = table.clone(t15.errors)

		if not v76 then
			assert(v75 ~= nil, "Failure without errors")

			for _, v78 in v75 do
				table.insert(t15.errors, {
					assetType = p6.assetType,
					error = {
						type = "message",
						message = v78
					}
				})
			end
		end

		t15.pieces = table.clone(t15.pieces)
		t15.pieces[n1].status = "finished"
		u32(t15)
	end):andThen(function() -- line: 312
		-- upvalues: t15 (ref), b1 (copy), p5 (copy), createEditableInstancesForContext (copy), getFFlagUGCValidationEnableFolderStructure (copy), getFFlagUGCValidationAnimationPackSupport (copy), LegacyValidationAdapter (copy), guid (ref), destroyEditableInstances (copy), u32 (ref)
		local function createFullBodyData(t18: {[any]: any}) -- line: 313
			local t19 = {}

			for _, v95 in t18 do
				table.insert(t19, {
					assetTypeEnum = v95.assetType,
					allSelectedInstances = if not v95.instance then {} else { v95.instance }
				})
			end

			return t19
		end

		local v80 = createFullBodyData(t15.pieces)
		local t20 = {
			isServer = false,
			fullBodyData = v80,
			allowEditableInstances = b1,
			bypassFlags = p5
		}
		local t21 = {}

		for _, v84 in v80 do
			for _, v86 in v84.allSelectedInstances do
				table.insert(t21, v86)
			end
		end

		local v87, v88 = createEditableInstancesForContext.processAll(t21, b1)
		local v89

		if not v87 then
			v89 = false
		else
			t20.editableMeshes = v88.editableMeshes
			t20.editableImages = v88.editableImages
			v89 = true
			v88 = nil

			if getFFlagUGCValidationEnableFolderStructure() and getFFlagUGCValidationAnimationPackSupport() then
				v89, v88 = LegacyValidationAdapter.studioRFUBundleValidation(v80, Enum.BundleType.Animations, t20, guid, v89, v88)
			end

			destroyEditableInstances(t20.editableMeshes, t20.editableImages)
		end

		if not v89 then
			t15 = table.clone(t15)
			t15.errors = table.clone(t15.errors)
			assert(v88 and #v88 > 0, "There should always be a reason for failure")

			for _, v91 in v88 do
				table.insert(t15.errors, {
					assetType = nil,
					error = {
						type = "message",
						message = v91
					}
				})
			end
		end

		u32(t15)
	end):andThen(function() -- line: 386
		-- upvalues: t15 (ref)
		return t15
	end)
end

return validateAnimationBundleReadyForUpload
