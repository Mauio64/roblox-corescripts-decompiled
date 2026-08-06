local AvatarExperienceAnalytics = script:FindFirstAncestor("AvatarExperienceAnalytics")
local UnifiedEventLogConstants = require(AvatarExperienceAnalytics.UnifiedEventLogConstants)

local function getDeferredPurchaseSourceTile(t1: {[any]: any}, p1, p2, p3) -- line: 22
	-- upvalues: UnifiedEventLogConstants (copy)
	if p2 == nil then
		return nil
	end

	local v8 = UnifiedEventLogConstants.ATTRIBUTE_PREFIX .. "itemId"
	local v9 = UnifiedEventLogConstants.ATTRIBUTE_PREFIX .. "itemType"
	local v10 = nil

	for _, v12 in t1 do
		if v12 == p1 or tostring(v12:GetAttribute(v8)) ~= tostring(p2) or tostring(v12:GetAttribute(v9)) ~= tostring(p3) then
			continue
		end

		local v13 = v12:GetAttribute(UnifiedEventLogConstants.SKIP_IMPRESSION_DETECTION) == true
		local v14 = v12:IsA("GuiObject") and (v12.AbsoluteSize.X > 0 and v12.AbsoluteSize.Y > 0)

		if v13 and v14 then
			return v12
		end

		if v10 == nil then
			v10 = v12
		end
	end

	return v10
end

return getDeferredPurchaseSourceTile
