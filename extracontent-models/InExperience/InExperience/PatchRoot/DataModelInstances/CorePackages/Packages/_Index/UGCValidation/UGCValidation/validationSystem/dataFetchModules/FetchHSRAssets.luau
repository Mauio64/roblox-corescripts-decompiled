local parent = script.Parent.Parent.Parent

local ParseContentIds = require(parent.util.ParseContentIds)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
require(parent.util.Types)

local getFFlagUGCValidateVersionedContentIds = require(parent.flags.getFFlagUGCValidateVersionedContentIds)

return {
	getData = function(folder, p)
		if p.consumerEnv == ValidationEnums.ConsumerEnv.IEC then
			return {}
		end

		local descendants = folder:GetDescendants()
		table.insert(descendants, folder)
		local result = {}

		for _, wrapLayer in descendants do
			if not wrapLayer:IsA("WrapLayer") then
				continue
			end

			local hsrAssetId = wrapLayer.HSRAssetId

			if not (hsrAssetId and hsrAssetId ~= "") then
				continue
			end

			local v

			if getFFlagUGCValidateVersionedContentIds() then
				local v2, v3 = ParseContentIds.tryParseContentId(hsrAssetId)

				if v2 then
					v = ParseContentIds.getReferenceKey(v2, v3)
				end
			else
				v = ParseContentIds.tryGetAssetIdFromContentId(hsrAssetId)
			end

			if not v or result[v] then
				continue
			end

			local preloadedHsrAsset = p.preloadedHsrAssets[v]

			if preloadedHsrAsset then
				result[v] = preloadedHsrAsset
			else
				local success, result2 = pcall(function()
					return game:GetObjectsAllOrNone(hsrAssetId)
				end)

				if not success then
					return nil
				end

				result[v] = result2 or {}
			end
		end

		return result
	end
}
