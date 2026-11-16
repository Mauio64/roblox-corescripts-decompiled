local parent = script.Parent.Parent.Parent

require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)
local FetchAllDesiredData = require(parent.validationSystem.dataFetchModules.FetchAllDesiredData)

local v = { ColorMap = true, NormalMap = true }

local SurfaceAppearanceOpacityValid = {}

SurfaceAppearanceOpacityValid.categories = { ValidationEnums.UploadCategory.RIGID_ACCESSORY }

SurfaceAppearanceOpacityValid.requiredData = {}
SurfaceAppearanceOpacityValid.conditionalData = { ValidationEnums.SharedDataMember.meshTextures }

SurfaceAppearanceOpacityValid.expectedFailures = {}

local function getIsOpaque(editable): boolean
	local pixelsBuffer = editable:ReadPixelsBuffer(Vector2.new(0, 0), editable.Size)

	for i = 0, buffer.len(pixelsBuffer) - 1, 4 do
		if buffer.readu8(pixelsBuffer, i + 3) < 255 then
			return false
		end
	end

	return true
end

function SurfaceAppearanceOpacityValid.run(object, p)
	local rootInstance = p.rootInstance
	local meshTextures = p.meshTextures

	if not meshTextures or meshTextures == FetchAllDesiredData.DATA_FETCH_FAILURE then
		object:fetchError("Failed to load texture data for surface appearance opacity check")
		return
	end

	local descendants = rootInstance:GetDescendants()
	table.insert(descendants, rootInstance)

	for _, part in descendants do
		if not part:IsA("MeshPart") then
			continue
		end

		local surfaceAppearance = part:FindFirstChildWhichIsA("SurfaceAppearance")

		if not surfaceAppearance then
			continue
		end

		if surfaceAppearance.AlphaMode ~= Enum.AlphaMode.Overlay then
			object:fail(
				ErrorSourceStrings.Keys.SAOpacity_InvalidAlphaMode,
				{ FullName = part:GetFullName() },
				surfaceAppearance
			)
		end

		local meshTexture = meshTextures[part.Name]

		if not (meshTexture and meshTexture.isPBR) then
			continue
		end

		for k, _ in v do
			local v2 = meshTexture[k]

			if not v2 then
				continue
			end

			if v2.editable then
				if not getIsOpaque(v2.editable) then
					object:fail(ErrorSourceStrings.Keys.SAOpacity_TextureNotOpaque, {
						FullName = surfaceAppearance:GetFullName() .. "." .. k
					}, surfaceAppearance)
				end
			else
				object:fail(
					ErrorSourceStrings.Keys.SAOpacity_FailedToLoadTexture,
					{
						FullName = surfaceAppearance:GetFullName(),
						FieldName = k
					},
					surfaceAppearance
				)
			end
		end
	end
end

return SurfaceAppearanceOpacityValid
