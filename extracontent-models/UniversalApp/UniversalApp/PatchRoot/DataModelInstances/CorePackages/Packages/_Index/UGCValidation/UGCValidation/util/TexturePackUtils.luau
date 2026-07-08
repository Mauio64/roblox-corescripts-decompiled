local UGCValidationService = game:GetService("UGCValidationService")
local ParentParent = script.Parent.Parent
local util = ParentParent.util
local ParseContentIds = require(util.ParseContentIds)
local flags = ParentParent.flags
local getFFlagUGCValidateEmptySurfaceAppearance = require(flags.getFFlagUGCValidateEmptySurfaceAppearance)
local t1 = {}

local function findSurfaceAppearances(p1, b1: boolean) -- line: 17
	-- upvalues: UGCValidationService (copy), ParseContentIds (copy), getFFlagUGCValidateEmptySurfaceAppearance (copy)
	local t2 = {}
	local t3 = {}
	local descendants = p1:GetDescendants()

	table.insert(descendants, p1)

	for _, v15 in descendants do
		if v15:IsA("SurfaceAppearance") then
			local PropertyValue = UGCValidationService:GetPropertyValue(v15, "TexturePack")

			if if not PropertyValue then nil else ParseContentIds.tryGetAssetIdFromContentId(PropertyValue) then
				table.insert(t2, v15)
			elseif getFFlagUGCValidateEmptySurfaceAppearance() then
				if v15.ColorMap and v15.ColorMap ~= "" or (v15.MetalnessMap and v15.MetalnessMap ~= "" or (v15.NormalMap and v15.NormalMap ~= "" or (v15.RoughnessMap and v15.RoughnessMap ~= "" or v15.EmissiveMaskContent and (v15.EmissiveMaskContent.SourceType == Enum.ContentSourceType.Uri and (v15.EmissiveMaskContent.Uri and v15.EmissiveMaskContent.Uri ~= ""))))) or not b1 then
					table.insert(t3, v15)
				end
			else
				table.insert(t3, v15)
			end
		end
	end

	return t2, t3
end

function t1.findSurfaceAppearancesMissingTexturePacks(p2, b2: boolean) -- line: 60
	-- upvalues: findSurfaceAppearances (copy)
	local _, v20 = findSurfaceAppearances(p2, b2)

	return v20
end
function t1.findSurfaceAppearancesWithTexturePacks(p3) -- line: 68
	-- upvalues: findSurfaceAppearances (copy)
	return (findSurfaceAppearances(p3, false))
end

return t1
