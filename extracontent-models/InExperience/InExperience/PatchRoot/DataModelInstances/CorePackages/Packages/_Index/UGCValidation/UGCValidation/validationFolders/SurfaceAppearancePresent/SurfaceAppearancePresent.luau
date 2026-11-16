local parent = script.Parent.Parent.Parent

require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)

local v = { InExpServer = true, InExpClient = true }

return {
	categories = {
		ValidationEnums.UploadCategory.TORSO_AND_LIMBS,
		ValidationEnums.UploadCategory.DYNAMIC_HEAD,
		ValidationEnums.UploadCategory.RIGID_ACCESSORY
	},
	requiredData = {},
	expectedFailures = {},
	run = function(object, p)
		local rootInstance = p.rootInstance

		local v2 = v[p.consumerConfig.source] == true

		local descendants = rootInstance:GetDescendants()
		table.insert(descendants, rootInstance)

		for _, part in descendants do
			if not part:IsA("MeshPart") then
				continue
			end

			local v3 = part.TextureID ~= ""

			if v2 and not v3 then
				local textureContent = part.TextureContent
				v3 = textureContent.Uri ~= nil and textureContent.Uri ~= "" or textureContent.Object ~= nil
			end

			local surfaceAppearance = part:FindFirstChildWhichIsA("SurfaceAppearance")

			if v3 then
				if surfaceAppearance then
					object:fail(
						ErrorSourceStrings.Keys.SurfaceAppearance_TextureAndSABothDefined,
						{ MeshPartFullName = part:GetFullName() },
						part
					)
				end
			elseif not surfaceAppearance then
				object:fail(
					ErrorSourceStrings.Keys.SurfaceAppearance_MissingSA,
					{ MeshPartFullName = part:GetFullName() },
					part
				)
			end
		end
	end
}
