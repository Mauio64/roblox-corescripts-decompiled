local UGCValidationService = game:GetService("UGCValidationService")

local parent = script.Parent.Parent

local util = parent.util
local ParseContentIds = require(util.ParseContentIds)

local flags = parent.flags
local getFFlagUGCValidateEmptySurfaceAppearance = require(flags.getFFlagUGCValidateEmptySurfaceAppearance)

local function findSurfaceAppearances(folder, flag: boolean)
	local descendants = folder:GetDescendants()
	table.insert(descendants, folder)
	local surfaceAppearances = {}
	local surfaceAppearances2 = {}

	for _, surfaceAppearance in descendants do
		if not surfaceAppearance:IsA("SurfaceAppearance") then
			continue
		end

		local propertyValue = UGCValidationService:GetPropertyValue(surfaceAppearance, "TexturePack")
		local v

		if propertyValue then
			v = ParseContentIds.tryGetAssetIdFromContentId(propertyValue)
		end

		if v then
			table.insert(surfaceAppearances, surfaceAppearance)
		elseif getFFlagUGCValidateEmptySurfaceAppearance() then
			local v2

			if
				surfaceAppearance.ColorMap and surfaceAppearance.ColorMap ~= ""
				or surfaceAppearance.MetalnessMap and surfaceAppearance.MetalnessMap ~= ""
				or surfaceAppearance.NormalMap and surfaceAppearance.NormalMap ~= ""
				or surfaceAppearance.RoughnessMap and surfaceAppearance.RoughnessMap ~= ""
			then
				v2 = true
			else
				v2 = surfaceAppearance.EmissiveMaskContent

				if v2 then
					if surfaceAppearance.EmissiveMaskContent.SourceType == Enum.ContentSourceType.Uri then
						v2 = surfaceAppearance.EmissiveMaskContent.Uri
							and surfaceAppearance.EmissiveMaskContent.Uri ~= ""
					else
						v2 = false
					end
				end
			end

			if v2 or not flag then
				table.insert(surfaceAppearances2, surfaceAppearance)
			end
		else
			table.insert(surfaceAppearances2, surfaceAppearance)
		end
	end

	return surfaceAppearances, surfaceAppearances2
end

local TexturePackUtils = {}

function TexturePackUtils.findSurfaceAppearancesMissingTexturePacks(p, flag: boolean)
	local _, surfaceAppearancesMissingTexturePacks = findSurfaceAppearances(p, flag)
	return surfaceAppearancesMissingTexturePacks
end

function TexturePackUtils.findSurfaceAppearancesWithTexturePacks(p)
	return (findSurfaceAppearances(p, false))
end

return TexturePackUtils
