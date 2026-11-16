local parent = script.Parent.Parent

require(parent.util.Types)

local Constants = require(parent.Constants)
local R15plusUtils = require(parent.util.R15plusUtils)
local flags = parent.flags
local getFFlagUGCValidationEnforceHRDUpload = require(flags.getFFlagUGCValidationEnforceHRDUpload)
local v = { LeftHand = "LeftHand", RightHand = "RightHand" }

local function createIndividualBodyPartSchema(p, p2: string, _)
	local subPart = Constants.ASSET_TYPE_INFO[p].subParts[p2]

	local individualBodyPartSchema = {
		ClassName = "MeshPart",
		Name = { p2 },
		_children = {
			{
				Name = { "AvatarPartScaleType" },
				ClassName = "StringValue"
			},
			{
				Name = { p2, p2 .. "WrapTarget", "WrapTarget" },
				ClassName = "WrapTarget"
			},
			{
				Name = { "SurfaceAppearance" },
				ClassName = "SurfaceAppearance",
				_optional = true
			}
		}
	}

	table.insert(individualBodyPartSchema._children, {
		Name = { subPart.rigAttachmentToParent.name },
		ClassName = "Attachment"
	})

	for k in pairs(subPart.otherAttachments) do
		table.insert(individualBodyPartSchema._children, {
			Name = { k },
			ClassName = "Attachment"
		})
	end

	if not R15plusUtils.checkFlagEnabledForAllowHrd() then
		return individualBodyPartSchema
	end

	table.insert(individualBodyPartSchema._children, {
		Name = { "HumanoidRigDescription" },
		ClassName = "HumanoidRigDescription",
		_optional = not getFFlagUGCValidationEnforceHRDUpload()
	})

	if v[p2] ~= nil then
		local formatted = `{v[p2]}Description`
		table.insert(individualBodyPartSchema._children, {
			Name = { "DigitsRigDescription", formatted },
			ClassName = "DigitsRigDescription",
			_optional = true
		})
	end

	local avatarBoneSchema = R15plusUtils.getAvatarBoneSchema(p2)
	local nameWhitelistOfClassInSchema = R15plusUtils.getNameWhitelistOfClassInSchema(avatarBoneSchema, "Attachment")

	for _, v2 in individualBodyPartSchema._children do
		if v2.ClassName == "Attachment" and nameWhitelistOfClassInSchema[v2.Name[1]] then
			v2._optional = true
		end

		if not string.find(v2.Name[1], "ShoulderRigAttachment") then
			continue
		end

		if v2._children == nil then
			v2._children = {}
		end

		table.insert(v2._children, {
			Name = { R15plusUtils.JointRotationName },
			ClassName = "Attachment",
			_optional = true
		})
	end

	local nameWhitelistOfClassInSchema2 = R15plusUtils.getNameWhitelistOfClassInSchema(avatarBoneSchema, "Bone")

	for k, v2 in nameWhitelistOfClassInSchema2 do
		if v2 then
			table.insert(individualBodyPartSchema._children, {
				Name = { k },
				ClassName = "Bone",
				_optional = true,
				_ignoreDescendants = true
			})
		end
	end

	return individualBodyPartSchema
end

return createIndividualBodyPartSchema
