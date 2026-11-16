local parent = script.Parent.Parent.Parent

require(parent.util.Types)
local Constants = require(parent.Constants)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)
local BoundsCalculator = require(parent.util.BoundsCalculator)
local BoundsDataUtils = require(parent.util.BoundsDataUtils)
local MeshSpaceUtils = require(parent.util.MeshSpaceUtils)
local prettyPrintVector3 = require(parent.util.prettyPrintVector3)
local R15plusUtils = require(parent.util.R15plusUtils)
local getAttachmentCFrameInPartSpace = require(parent.util.getAttachmentCFrameInPartSpace)

local getFStringUGCValidationAttachmentErrorLink = require(parent.flags.getFStringUGCValidationAttachmentErrorLink)

local getFFlagUGCValidateAttachmentBoundsErrorMessage = require(parent.flags.getFFlagUGCValidateAttachmentBoundsErrorMessage)

local AttachmentBoundsValid = {}

AttachmentBoundsValid.categories = {
	ValidationEnums.UploadCategory.TORSO_AND_LIMBS,
	ValidationEnums.UploadCategory.DYNAMIC_HEAD
}

AttachmentBoundsValid.requiredData = {
	ValidationEnums.SharedDataMember.rootInstance,
	ValidationEnums.SharedDataMember.uploadEnum,
	ValidationEnums.SharedDataMember.consumerConfig
}

AttachmentBoundsValid.conditionalData = { ValidationEnums.SharedDataMember.renderMeshesData }

AttachmentBoundsValid.expectedFailures = {}

local function validateInMeshSpace(child, instance, bounds, p, object, flag: boolean)
	local v = p.cframe * getAttachmentCFrameInPartSpace(child)
	local boundsCenters = BoundsDataUtils.calculateBoundsCenters(p.boundsData)
	local boundsDimensions = BoundsDataUtils.calculateBoundsDimensions(p.boundsData)

	if not (boundsCenters and boundsDimensions) then
		object:fail(ErrorSourceStrings.Keys.AttachmentBoundsCalculationFailed, {
			AttachmentName = child.Name,
			PartName = instance.Name
		})

		return
	end

	local v2 = (v.Position - boundsCenters) / (boundsDimensions / 2)

	local min = bounds.min
	local max = bounds.max

	for _, v3 in { "X", "Y", "Z" } do
		if v2[v3] < min[v3] or v2[v3] > max[v3] then
			local clampAttachmentToBounds = MeshSpaceUtils.clampAttachmentToBounds(child, p, bounds, 0.001)

			local acceptableBoundsLocalSpace, v4 = MeshSpaceUtils.calculateAcceptableBoundsLocalSpace(
				bounds,
				p,
				boundsDimensions,
				boundsCenters
			)

			local position = acceptableBoundsLocalSpace.Position
			local orientation, v5, v6 = acceptableBoundsLocalSpace.Rotation:ToOrientation()

			local vector3 = Vector3.new(math.deg(orientation), math.deg(v5), (math.deg(v6)))

			if not getFFlagUGCValidateAttachmentBoundsErrorMessage() then
				object:fail(ErrorSourceStrings.Keys.AttachmentOutOfBounds, {
					AttachmentName = child.Name,
					PartName = instance.Name,
					CurrentPosition = prettyPrintVector3(child.CFrame.Position, 3),
					ClosestValidPosition = prettyPrintVector3(clampAttachmentToBounds.Position, 3),
					BoundsPosition = prettyPrintVector3(position, 3),
					BoundsOrientation = prettyPrintVector3(vector3, 3),
					BoundsSize = prettyPrintVector3(v4, 3),
					HelpLink = getFStringUGCValidationAttachmentErrorLink()
				})
				break
			end

			local v7

			if flag then
				v7 = ErrorSourceStrings.Keys.RigAttachmentOutOfBounds
			else
				v7 = ErrorSourceStrings.Keys.AccessoryAttachmentOutOfBounds
			end

			object:fail(v7, {
				AttachmentName = child.Name,
				PartName = instance.Name,
				CurrentPosition = prettyPrintVector3(child.CFrame.Position, 3),
				ClosestValidPosition = prettyPrintVector3(clampAttachmentToBounds.Position, 3),
				HelpLink = getFStringUGCValidationAttachmentErrorLink()
			})
			break
		end
	end
end

local function checkAll(instance, p, p2, object)
	local child = instance:FindFirstChild(p.rigAttachmentToParent.name, R15plusUtils.checkFlagEnabledForAllowHrd())

	if not child then
		return
	end

	validateInMeshSpace(child, instance, p.rigAttachmentToParent.bounds, p2, object, true)

	for childName, otherAttachment in pairs(p.otherAttachments) do
		local child2 = instance:FindFirstChild(childName, R15plusUtils.checkFlagEnabledForAllowHrd())

		if child2 then
			validateInMeshSpace(
				child2,
				instance,
				otherAttachment.bounds,
				p2,
				object,
				string.find(childName, "RigAttachment$") ~= nil
			)
		end
	end
end

function AttachmentBoundsValid.run(object, data)
	local rootInstance = data.rootInstance
	local assetType = data.uploadEnum.assetType

	local v = Constants.ASSET_TYPE_INFO[assetType]

	if not v then
		return
	end

	local editableMeshes = {}

	if data.renderMeshesData then
		local descendants = rootInstance:GetDescendants()
		table.insert(descendants, rootInstance)

		for _, descendant in descendants do
			local v2 = data.renderMeshesData[descendant.Name]

			if v2 and v2.editable then
				editableMeshes[descendant] = {
					MeshId = { instance = v2.editable, created = false }
				}
			end
		end
	end

	local isServer = data.consumerConfig.validationEnv == ValidationEnums.ValidationEnv.Backend

	local individualAssetPartsData, _, v2 = BoundsCalculator.calculateIndividualAssetPartsData(rootInstance, {
		assetTypeEnum = assetType,
		isServer = isServer,
		editableMeshes = editableMeshes
	})

	if not individualAssetPartsData then
		object:fail(ErrorSourceStrings.Keys.AttachmentBoundsAssetCalculationFailed, {
			InstancePath = rootInstance:GetFullName()
		})
	elseif Enum.AssetType.DynamicHead == assetType then
		local v3 = v2[rootInstance.Name]

		if v3 then
			checkAll(rootInstance, v.subParts.Head, v3, object)
		end
	else
		for childName, subPart in pairs(v.subParts) do
			local child = rootInstance:FindFirstChild(childName)

			if not child then
				continue
			end

			local v3 = v2[childName]

			if v3 then
				checkAll(child, subPart, v3, object)
			end
		end
	end
end

return AttachmentBoundsValid
