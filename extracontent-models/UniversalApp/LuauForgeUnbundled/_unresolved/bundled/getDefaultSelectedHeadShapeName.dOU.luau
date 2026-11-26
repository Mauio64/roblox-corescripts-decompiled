local module = require("@luauforge/bundled/dOT")

local headShape = require("@luauforge/bundled/dLc").Enums.HeadShape

local function isClassicFaceEquipped(p2): boolean
	return #module(p2, (tostring(Enum.AssetType.Face.Value))) > 0
end

local function getDefaultSelectedHeadShapeName(data)
	local isTryingOnItems = data.isTryingOnItems
	local defaultHeadShapeName

	if #module(data.equippedAssets, (tostring(Enum.AssetType.Face.Value))) > 0 then
		defaultHeadShapeName = data.defaultHeadShapeName
	end

	if isTryingOnItems then
		return data.lastTryOnHeadShapeName
			or data.defaultHeadShapeName
			or data.equippedHeadShapeName
			or defaultHeadShapeName
	end

	return data.equippedHeadShapeName or headShape.Default
end

return getDefaultSelectedHeadShapeName
