local ParentParent = script.Parent.Parent.Parent

require(ParentParent.util.Types)

local Constants = require(ParentParent.Constants)
local ValidationEnums = require(ParentParent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(ParentParent.validationSystem.ErrorSourceStrings)
local BoundsCalculator = require(ParentParent.util.BoundsCalculator)
local BoundsDataUtils = require(ParentParent.util.BoundsDataUtils)
local MeshSpaceUtils = require(ParentParent.util.MeshSpaceUtils)
local prettyPrintVector3 = require(ParentParent.util.prettyPrintVector3)
local R15plusUtils = require(ParentParent.util.R15plusUtils)
local getAttachmentCFrameInPartSpace = require(ParentParent.util.getAttachmentCFrameInPartSpace)
local getFFlagUGCValidateMigrateSchemaProperties = require(ParentParent.flags.getFFlagUGCValidateMigrateSchemaProperties)
local getFStringUGCValidationAttachmentErrorLink = require(ParentParent.flags.getFStringUGCValidationAttachmentErrorLink)
local t1 = {
	categories = {
		ValidationEnums.UploadCategory.TORSO_AND_LIMBS,
		ValidationEnums.UploadCategory.DYNAMIC_HEAD
	},
	requiredData = {
		ValidationEnums.SharedDataMember.rootInstance,
		ValidationEnums.SharedDataMember.uploadEnum,
		ValidationEnums.SharedDataMember.consumerConfig
	},
	conditionalData = { ValidationEnums.SharedDataMember.renderMeshesData },
	fflag = getFFlagUGCValidateMigrateSchemaProperties,
	expectedFailures = {}
}

local function validateInMeshSpace(p1, p2, p3, p4, p5) -- line: 34
	-- upvalues: getAttachmentCFrameInPartSpace (copy), BoundsDataUtils (copy), ErrorSourceStrings (copy), MeshSpaceUtils (copy), prettyPrintVector3 (copy), getFStringUGCValidationAttachmentErrorLink (copy)
	local v21 = p4.cframe * getAttachmentCFrameInPartSpace(p1)
	local v22 = BoundsDataUtils.calculateBoundsCenters(p4.boundsData)
	local v23 = BoundsDataUtils.calculateBoundsDimensions(p4.boundsData)

	if not v22 or not v23 then
		p5:fail(ErrorSourceStrings.Keys.AttachmentBoundsCalculationFailed, {
			AttachmentName = p1.Name,
			PartName = p2.Name
		})

		return
	end

	local v24 = (v21.Position - v22) / (v23 / 2)
	local min = p3.min
	local max = p3.max

	for _, v28 in {
		"X",
		"Y",
		"Z"
	} do
		if v24[v28] < min[v28] or v24[v28] > max[v28] then
			local v29 = MeshSpaceUtils.clampAttachmentToBounds(p1, p4, p3, 0.001)
			local v30, v31 = MeshSpaceUtils.calculateAcceptableBoundsLocalSpace(p3, p4, v23, v22)
			local Position = v30.Position
			local v33, v34, v35 = v30.Rotation:ToOrientation()
			local vector3 = Vector3.new(math.deg(v33), math.deg(v34), (math.deg(v35)))

			p5:fail(ErrorSourceStrings.Keys.AttachmentOutOfBounds, {
				AttachmentName = p1.Name,
				PartName = p2.Name,
				CurrentPosition = prettyPrintVector3(p1.CFrame.Position, 3),
				ClosestValidPosition = prettyPrintVector3(v29.Position, 3),
				BoundsPosition = prettyPrintVector3(Position, 3),
				BoundsOrientation = prettyPrintVector3(vector3, 3),
				BoundsSize = prettyPrintVector3(v31, 3),
				HelpLink = getFStringUGCValidationAttachmentErrorLink()
			})

			return
		end
	end
end
local function checkAll(p6, p7, p8, p9) -- line: 91
	-- upvalues: R15plusUtils (copy), validateInMeshSpace (copy)
	local p7rigAttachmentToParentname = p6:FindFirstChild(p7.rigAttachmentToParent.name, R15plusUtils.checkFlagEnabledForAllowHrd())

	if not p7rigAttachmentToParentname then
		return
	end

	validateInMeshSpace(p7rigAttachmentToParentname, p6, p7.rigAttachmentToParent.bounds, p8, p9)

	for k, v in pairs(p7.otherAttachments) do
		local k2 = p6:FindFirstChild(k, R15plusUtils.checkFlagEnabledForAllowHrd())

		if k2 then
			validateInMeshSpace(k2, p6, v.bounds, p8, p9)
		end
	end
end

function t1.run(p10, p11) -- line: 125
	-- upvalues: Constants (copy), ValidationEnums (copy), BoundsCalculator (copy), ErrorSourceStrings (copy), checkAll (copy)
	local rootInstance = p11.rootInstance
	local assetType = p11.uploadEnum.assetType
	local v49 = Constants.ASSET_TYPE_INFO[assetType]

	if not v49 then
		return
	end

	local t2 = {}

	if p11.renderMeshesData then
		local descendants = rootInstance:GetDescendants()

		table.insert(descendants, rootInstance)

		for _, v53 in descendants do
			local v54 = p11.renderMeshesData[v53.Name]

			if v54 and v54.editable then
				t2[v53] = {
					MeshId = {
						created = false,
						instance = v54.editable
					}
				}
			end
		end
	end

	local t3 = {
		assetTypeEnum = assetType,
		isServer = p11.consumerConfig.consumerEnv == ValidationEnums.ConsumerEnv.Backend,
		editableMeshes = t2
	}
	local v56, _, v58 = BoundsCalculator.calculateIndividualAssetPartsData(rootInstance, t3)

	if not v56 then
		p10:fail(ErrorSourceStrings.Keys.AttachmentBoundsAssetCalculationFailed, {
			InstancePath = rootInstance:GetFullName()
		})

		return
	end

	if assetType == Enum.AssetType.DynamicHead then
		local v59 = v58[rootInstance.Name]

		if v59 then
			checkAll(rootInstance, v49.subParts.Head, v59, p10)

			return
		end
	else
		for k, v in pairs(v49.subParts) do
			local k3 = rootInstance:FindFirstChild(k)

			if k3 then
				local v63 = v58[k]

				if v63 then
					checkAll(k3, v, v63, p10)
				end
			end
		end
	end
end

return t1
