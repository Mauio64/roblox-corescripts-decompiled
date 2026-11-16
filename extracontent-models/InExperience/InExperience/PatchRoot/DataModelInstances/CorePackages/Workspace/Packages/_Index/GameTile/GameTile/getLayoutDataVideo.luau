local GameTile = script:FindFirstAncestor("GameTile")
local parent = GameTile.Parent

require(GameTile.GameTileTypes)

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppHomeMomentVideoPrecedence = SharedFlags.FFlagLuaAppHomeMomentVideoPrecedence
local SharedFlags2 = require(parent.SharedFlags)
local FFlagLuaAppDiscoveryMomentVideoTelemetry = SharedFlags2.FFlagLuaAppDiscoveryMomentVideoTelemetry

local function isNonEmptyString(value): boolean -- 2 equivalent calls inferred from this helper
	return type(value) == "string" and value ~= ""
end

local function getMomentVideo(primaryMediaAsset) -- 2 equivalent calls inferred from this helper
	if
		isNonEmptyString(primaryMediaAsset.momentVideoAssetId) -- inferred equivalent call
		and isNonEmptyString(primaryMediaAsset.momentVideoAssetAccessContext) -- inferred equivalent call
	then
		return {
			assetId = primaryMediaAsset.momentVideoAssetId,
			accessContext = primaryMediaAsset.momentVideoAssetAccessContext,
			isMoment = FFlagLuaAppDiscoveryMomentVideoTelemetry and true or nil
		}
	end

	return nil
end

local function getLayoutDataVideo(p, assetId: string?)
	local primaryMediaAsset = p and p.primaryMediaAsset

	if FFlagLuaAppHomeMomentVideoPrecedence then
		local v

		if primaryMediaAsset then
			v = getMomentVideo(primaryMediaAsset) -- inferred equivalent call
		end

		if v then
			return v
		end
	end

	if assetId then
		return { assetId = assetId }
	end

	if not primaryMediaAsset then
		return nil
	end

	if primaryMediaAsset.wideVideoAssetId then
		return { assetId = primaryMediaAsset.wideVideoAssetId }
	end

	if FFlagLuaAppHomeMomentVideoPrecedence then
		return nil
	end

	return getMomentVideo(primaryMediaAsset) -- inferred equivalent call
end

return getLayoutDataVideo
