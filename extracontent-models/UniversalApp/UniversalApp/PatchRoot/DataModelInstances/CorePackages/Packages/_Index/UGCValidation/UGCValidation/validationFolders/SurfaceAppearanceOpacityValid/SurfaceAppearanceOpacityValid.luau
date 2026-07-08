local ParentParent = script.Parent.Parent.Parent

require(ParentParent.util.Types)

local ValidationEnums = require(ParentParent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(ParentParent.validationSystem.ErrorSourceStrings)
local FetchAllDesiredData = require(ParentParent.validationSystem.dataFetchModules.FetchAllDesiredData)
local getFFlagUGCValidateMigrateTextureTransparency = require(ParentParent.flags.getFFlagUGCValidateMigrateTextureTransparency)
local t1 = {
	ColorMap = true,
	NormalMap = true
}
local t2 = {
	categories = { ValidationEnums.UploadCategory.RIGID_ACCESSORY },
	requiredData = {},
	conditionalData = { ValidationEnums.SharedDataMember.meshTextures },
	fflag = getFFlagUGCValidateMigrateTextureTransparency,
	expectedFailures = {}
}

local function getIsOpaque(p1) -- line: 30
	local v10 = p1:ReadPixelsBuffer(Vector2.new(0, 0), p1.Size)

	for i = 0, buffer.len(v10) - 1, 4 do
		if buffer.readu8(v10, i + 3) < 255 then
			return false
		end
	end

	return true
end

function t2.run(p2, p3) -- line: 41
	-- upvalues: FetchAllDesiredData (copy), ErrorSourceStrings (copy), t1 (copy), getIsOpaque (copy)
	local rootInstance = p3.rootInstance
	local meshTextures = p3.meshTextures

	if not meshTextures or meshTextures == FetchAllDesiredData.DATA_FETCH_FAILURE then
		p2:fetchError("Failed to load texture data for surface appearance opacity check")

		return
	end

	local descendants = rootInstance:GetDescendants()

	table.insert(descendants, rootInstance)

	for _, v18 in descendants do
		if v18:IsA("MeshPart") then
			local SurfaceAppearance = v18:FindFirstChildWhichIsA("SurfaceAppearance")

			if SurfaceAppearance then
				if SurfaceAppearance.AlphaMode ~= Enum.AlphaMode.Overlay then
					p2:fail(ErrorSourceStrings.Keys.SAOpacity_InvalidAlphaMode, {
						FullName = v18:GetFullName()
					}, SurfaceAppearance)
				end

				local v20 = meshTextures[v18.Name]

				if v20 and v20.isPBR then
					for v21, _ in t1 do
						local v23 = v20[v21]

						if v23 then
							if not v23.editable then
								p2:fail(ErrorSourceStrings.Keys.SAOpacity_FailedToLoadTexture, {
									FullName = SurfaceAppearance:GetFullName(),
									FieldName = v21
								}, SurfaceAppearance)
							elseif not getIsOpaque(v23.editable) then
								p2:fail(ErrorSourceStrings.Keys.SAOpacity_TextureNotOpaque, {
									FullName = SurfaceAppearance:GetFullName() .. "." .. v21
								}, SurfaceAppearance)
							end
						end
					end
				end
			end
		end
	end
end

return t2
