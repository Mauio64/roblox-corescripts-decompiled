local ParentParent = script.Parent.Parent.Parent

require(ParentParent.util.Types)

local ValidationEnums = require(ParentParent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(ParentParent.validationSystem.ErrorSourceStrings)
local getFFlagUGCValidateMigrateSurfaceAppearanceMeshQuality = require(ParentParent.flags.getFFlagUGCValidateMigrateSurfaceAppearanceMeshQuality)
local t1 = {
	InExpServer = true,
	InExpClient = true
}

return {
	fflag = getFFlagUGCValidateMigrateSurfaceAppearanceMeshQuality,
	categories = {
		ValidationEnums.UploadCategory.TORSO_AND_LIMBS,
		ValidationEnums.UploadCategory.DYNAMIC_HEAD,
		ValidationEnums.UploadCategory.RIGID_ACCESSORY
	},
	requiredData = {},
	expectedFailures = {},
	run = function(p1, p2) -- line: 39
		-- upvalues: t1 (copy), ErrorSourceStrings (copy)
		local rootInstance = p2.rootInstance
		local v9 = t1[p2.consumerConfig.source] == true
		local descendants = rootInstance:GetDescendants()

		table.insert(descendants, rootInstance)

		for _, v12 in descendants do
			if v12:IsA("MeshPart") then
				local v13 = v12.TextureID ~= ""

				if v9 and not v13 then
					local TextureContent = v12.TextureContent

					v13 = TextureContent.Uri ~= nil and TextureContent.Uri ~= "" or TextureContent.Object ~= nil
				end

				local SurfaceAppearance = v12:FindFirstChildWhichIsA("SurfaceAppearance")

				if v13 then
					if SurfaceAppearance then
						p1:fail(ErrorSourceStrings.Keys.SurfaceAppearance_TextureAndSABothDefined, {
							MeshPartFullName = v12:GetFullName()
						}, v12)
					end
				elseif not SurfaceAppearance then
					p1:fail(ErrorSourceStrings.Keys.SurfaceAppearance_MissingSA, {
						MeshPartFullName = v12:GetFullName()
					}, v12)
				end
			end
		end
	end
}
