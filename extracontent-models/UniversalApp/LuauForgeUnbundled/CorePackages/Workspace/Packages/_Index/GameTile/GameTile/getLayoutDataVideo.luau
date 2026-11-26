require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/GameTileTypes")

local fFlagLuaAppHomeMomentVideoPrecedence = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/SharedFlags").FFlagLuaAppHomeMomentVideoPrecedence
local fFlagLuaAppDiscoveryMomentVideoTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/SharedFlags").FFlagLuaAppDiscoveryMomentVideoTelemetry

local function isNonEmptyString(value): boolean
	return type(value) == "string" and value ~= ""
end

local function getMomentVideo(p2)
	local momentVideoAssetId = p2.momentVideoAssetId
	local v5 = type(momentVideoAssetId) == "string" and momentVideoAssetId ~= ""

	if not v5 then
		return nil
	end

	local momentVideoAssetAccessContext = p2.momentVideoAssetAccessContext
	local v6 = type(momentVideoAssetAccessContext) == "string" and momentVideoAssetAccessContext ~= ""

	if v6 then
		return {
			assetId = p2.momentVideoAssetId,
			accessContext = p2.momentVideoAssetAccessContext,
			isMoment = fFlagLuaAppDiscoveryMomentVideoTelemetry and true or nil
		}
	end

	return nil
end

local function getLayoutDataVideo(p2, p3)
	local primaryMediaAsset = p2 and p2.primaryMediaAsset

	if fFlagLuaAppHomeMomentVideoPrecedence then
		local v5

		if primaryMediaAsset then
			local momentVideoAssetId = primaryMediaAsset.momentVideoAssetId
			local v6 = type(momentVideoAssetId) == "string" and momentVideoAssetId ~= ""

			if v6 then
				local momentVideoAssetAccessContext = primaryMediaAsset.momentVideoAssetAccessContext
				v5 = type(momentVideoAssetAccessContext) == "string"
					and momentVideoAssetAccessContext ~= ""
					and {
						assetId = primaryMediaAsset.momentVideoAssetId,
						accessContext = primaryMediaAsset.momentVideoAssetAccessContext,
						isMoment = fFlagLuaAppDiscoveryMomentVideoTelemetry and true or nil
					}
					or nil
			end
		end

		if v5 then
			return v5
		end
	end

	if p3 then
		return { assetId = p3 }
	end

	if not primaryMediaAsset then
		return nil
	end

	if primaryMediaAsset.wideVideoAssetId then
		return { assetId = primaryMediaAsset.wideVideoAssetId }
	end

	if fFlagLuaAppHomeMomentVideoPrecedence then
		return nil
	end

	local momentVideoAssetId = primaryMediaAsset.momentVideoAssetId
	local v5 = type(momentVideoAssetId) == "string" and momentVideoAssetId ~= ""

	if not v5 then
		return nil
	end

	local momentVideoAssetAccessContext = primaryMediaAsset.momentVideoAssetAccessContext
	local v6 = type(momentVideoAssetAccessContext) == "string" and momentVideoAssetAccessContext ~= ""

	if v6 then
		return {
			assetId = primaryMediaAsset.momentVideoAssetId,
			accessContext = primaryMediaAsset.momentVideoAssetAccessContext,
			isMoment = fFlagLuaAppDiscoveryMomentVideoTelemetry and true or nil
		}
	end

	return nil
end

return getLayoutDataVideo
