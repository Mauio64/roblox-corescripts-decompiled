local ParentParent = script.Parent.Parent

require(ParentParent.util.Types)

local Constants = require(ParentParent.Constants)
local R15plusUtils = require(ParentParent.util.R15plusUtils)
local flags = ParentParent.flags
local getFFlagUGCValidationEnforceHRDUpload = require(flags.getFFlagUGCValidationEnforceHRDUpload)
local t1 = {
	LeftHand = "LeftHand",
	RightHand = "RightHand"
}

local function createIndividualBodyPartSchema(p1, s1: string, _) -- line: 14
	-- upvalues: Constants (copy), R15plusUtils (copy), getFFlagUGCValidationEnforceHRDUpload (copy), t1 (copy)
	local v11 = Constants.ASSET_TYPE_INFO[p1].subParts[s1]
	local t2 = {
		ClassName = "MeshPart",
		Name = { s1 },
		_children = {
			{
				ClassName = "StringValue",
				Name = { "AvatarPartScaleType" }
			},
			{
				ClassName = "WrapTarget",
				Name = {
					s1,
					s1 .. "WrapTarget",
					"WrapTarget"
				}
			},
			{
				ClassName = "SurfaceAppearance",
				_optional = true,
				Name = { "SurfaceAppearance" }
			}
		}
	}

	table.insert(t2._children, {
		ClassName = "Attachment",
		Name = { v11.rigAttachmentToParent.name }
	})

	for k in pairs(v11.otherAttachments) do
		table.insert(t2._children, {
			ClassName = "Attachment",
			Name = { k }
		})
	end

	if R15plusUtils.checkFlagEnabledForAllowHrd() then
		table.insert(t2._children, {
			ClassName = "HumanoidRigDescription",
			Name = { "HumanoidRigDescription" },
			_optional = not getFFlagUGCValidationEnforceHRDUpload()
		})

		if t1[s1] ~= nil then
			local v14 = `{ t1[s1] }Description`

			table.insert(t2._children, {
				ClassName = "DigitsRigDescription",
				_optional = true,
				Name = {
					"DigitsRigDescription",
					v14
				}
			})
		end

		local v15 = R15plusUtils.getAvatarBoneSchema(s1)
		local v16 = R15plusUtils.getNameWhitelistOfClassInSchema(v15, "Attachment")

		for _, v18 in t2._children do
			if v18.ClassName == "Attachment" and v16[v18.Name[1]] then
				v18._optional = true
			end

			if string.find(v18.Name[1], "ShoulderRigAttachment") then
				if v18._children == nil then
					v18._children = {}
				end

				table.insert(v18._children, {
					ClassName = "Attachment",
					_optional = true,
					Name = { R15plusUtils.JointRotationName }
				})
			end
		end

		for v19, v20 in (R15plusUtils.getNameWhitelistOfClassInSchema(v15, "Bone")) do
			if v20 then
				table.insert(t2._children, {
					ClassName = "Bone",
					_optional = true,
					_ignoreDescendants = true,
					Name = { v19 }
				})
			end
		end
	end

	return t2
end

return createIndividualBodyPartSchema
