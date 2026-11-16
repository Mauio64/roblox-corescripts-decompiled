local parent = script.Parent.Parent
local Constants = require(parent.Constants)
require(parent.util.Types)

local R15plusUtils = {}
local jointNameWhitelist = nil

local flags = parent.flags
local getFFlagUGCValidationAllowHRDUpload = require(flags.getFFlagUGCValidationAllowHRDUpload)
local getFFlagDebugAllowHRDUploadOnBundleBackend = require(flags.getFFlagDebugAllowHRDUploadOnBundleBackend)

local fingerFlatSuffixes = { "Index", "Middle", "Pinky", "Ring", "Thumb" }

local function buildDrdSchema(p: string)
	local drdSchema = {}

	for _, v in fingerFlatSuffixes do
		local formatted = `{p}Hand{v}`
		local formatted2 = `{formatted}1`
		drdSchema[formatted2] = {
			ClassName = "Bone",
			_children = {
				[`{formatted}2`] = {
					ClassName = "Bone",
					_children = {
						[`{formatted}3`] = { ClassName = "Bone" }
					}
				}
			}
		}
	end

	return drdSchema
end

local v = {
	HeadBase = {
		ClassName = "Bone",
		_children = {
			FaceCenterAttachment = { ClassName = "Attachment" },
			FaceFrontAttachment = { ClassName = "Attachment" },
			HairAttachment = { ClassName = "Attachment" },
			HatAttachment = { ClassName = "Attachment" }
		}
	}
}

local v2 = {
	Spine = {
		ClassName = "Bone",
		_children = {
			Chest = {
				ClassName = "Bone",
				_children = {
					BodyBackAttachment = { ClassName = "Attachment" },
					BodyFrontAttachment = { ClassName = "Attachment" },
					NeckRigAttachment = { ClassName = "Attachment" },
					NeckAttachment = { ClassName = "Attachment" },
					LeftClavicle = {
						ClassName = "Bone",
						_children = {
							LeftCollarAttachment = { ClassName = "Attachment" },
							LeftShoulderRigAttachment = { ClassName = "Attachment" }
						}
					},
					RightClavicle = {
						ClassName = "Bone",
						_children = {
							RightCollarAttachment = { ClassName = "Attachment" },
							RightShoulderRigAttachment = { ClassName = "Attachment" }
						}
					}
				}
			}
		}
	}
}

local v3 = {
	LeftToeBase = { ClassName = "Bone" }
}

local v4 = {
	RightToeBase = { ClassName = "Bone" }
}

local drdSchema = buildDrdSchema("Left")
local drdSchema2 = buildDrdSchema("Right")

R15plusUtils.JointRotationName = "JointRotation"

local v5 = false

function R15plusUtils.setIsBackendBundleUpload(flag: boolean)
	v5 = flag
end

function R15plusUtils.checkFlagEnabledForAllowHrd(): boolean
	if getFFlagUGCValidationAllowHRDUpload() or getFFlagDebugAllowHRDUploadOnBundleBackend() and v5 then
		return true
	end

	return false
end

local jointLabels = nil
local jointLabels2 = nil

function R15plusUtils.getHrdJointLabels()
	if jointLabels == nil then
		jointLabels = Instance.new("HumanoidRigDescription"):GetJointLabels()
	end

	return jointLabels
end

function R15plusUtils.getDrdJointLabels()
	if jointLabels2 == nil then
		jointLabels2 = Instance.new("DigitsRigDescription"):GetJointLabels()
	end

	return jointLabels2
end

function R15plusUtils.getJointNameWhitelist()
	if jointNameWhitelist ~= nil then
		return jointNameWhitelist
	end

	jointNameWhitelist = {}

	for k, _ in Constants.R15_STANDARD_JOINT_NAMES do
		jointNameWhitelist[k] = true
	end

	for _, v6 in R15plusUtils.getHrdJointLabels() do
		jointNameWhitelist[v6.Name] = true
	end

	for _, v6 in R15plusUtils.getDrdJointLabels() do
		jointNameWhitelist[`LeftHand{v6.Name}`] = true
		jointNameWhitelist[`RightHand{v6.Name}`] = true
	end

	return jointNameWhitelist
end

function R15plusUtils.getNameWhitelistOfClassInSchema(items, p: string)
	local nameWhitelistOfClassInSchema = {}

	for k, item in items do
		if item.ClassName == p then
			nameWhitelistOfClassInSchema[k] = true
		end

		if item._children == nil then
			continue
		end

		for k2, v6 in R15plusUtils.getNameWhitelistOfClassInSchema(item._children, p) do
			nameWhitelistOfClassInSchema[k2] = v6
		end
	end

	return nameWhitelistOfClassInSchema
end

function R15plusUtils.getSchemaFlatHierarchyList(items, p)
	local schemaFlatHierarchyList = {}

	for k, item in items do
		local clone = table.clone(p)
		table.insert(clone, k)

		schemaFlatHierarchyList[k] = { ClassName = item.ClassName, path = clone }

		if item._children == nil then
			continue
		end

		for k2, v6 in R15plusUtils.getSchemaFlatHierarchyList(item._children, clone) do
			schemaFlatHierarchyList[k2] = v6
		end
	end

	return schemaFlatHierarchyList
end

function R15plusUtils.getFingerFlatSuffixes()
	return fingerFlatSuffixes
end

function R15plusUtils.getDrdSchema(p: string)
	if p == "Left" then
		return drdSchema
	elseif p == "Right" then
		return drdSchema2
	end

	error("Invalid side: " .. p)
end

function R15plusUtils.getAvatarBoneSchema(p: string)
	if p == "Head" then
		return v
	elseif p == "UpperTorso" then
		return v2
	elseif p == "LeftFoot" then
		return v3
	elseif p == "RightFoot" then
		return v4
	elseif p == "LeftHand" then
		return drdSchema
	elseif p == "RightHand" then
		return drdSchema2
	end

	return {}
end

return R15plusUtils
