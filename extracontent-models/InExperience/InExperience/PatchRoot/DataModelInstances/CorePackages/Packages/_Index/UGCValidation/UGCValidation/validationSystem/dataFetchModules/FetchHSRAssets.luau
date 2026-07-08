local ParentParent = script.Parent.Parent.Parent
local ParseContentIds = require(ParentParent.util.ParseContentIds)
local ValidationEnums = require(ParentParent.validationSystem.ValidationEnums)

require(ParentParent.util.Types)

return {
	getData = function(p1, p2) -- line: 9
		-- upvalues: ValidationEnums (copy), ParseContentIds (copy)
		if p2.consumerEnv == ValidationEnums.ConsumerEnv.IEC then
			return {}
		end

		local t1 = {}
		local descendants = p1:GetDescendants()

		table.insert(descendants, p1)

		for _, v9 in descendants do
			if not v9:IsA("WrapLayer") then
				continue
			end

			local HSRAssetId = v9.HSRAssetId

			if not HSRAssetId or HSRAssetId == "" then
				continue
			end

			local v11 = ParseContentIds.tryGetAssetIdFromContentId(HSRAssetId)

			if not v11 or t1[v11] then
				continue
			end

			local v12 = p2.preloadedHsrAssets[v11]

			if not v12 then
				local ok, result = pcall(function() -- line: 48
					-- upvalues: HSRAssetId (copy)
					return game:GetObjectsAllOrNone(HSRAssetId)
				end)

				if not ok then
					return nil
				end

				t1[v11] = result or {}

				continue
			end

			t1[v11] = v12
		end

		return t1
	end
}
