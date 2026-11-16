local AvatarExperienceAnalytics = script:FindFirstAncestor("AvatarExperienceAnalytics")

local UnifiedEventLogConstants = require(AvatarExperienceAnalytics.UnifiedEventLogConstants)

local function getDeferredPurchaseSourceTile(items, p, p2: string?, p3: number?)
	if p2 == nil then
		return nil
	end

	local v = UnifiedEventLogConstants.ATTRIBUTE_PREFIX .. "itemId"
	local v2 = UnifiedEventLogConstants.ATTRIBUTE_PREFIX .. "itemType"
	local v3 = nil

	for _, guiObject in items do
		if not (guiObject ~= p and tostring(guiObject:GetAttribute(v)) == tostring(p2)) then
			continue
		end

		if tostring(guiObject:GetAttribute(v2)) ~= tostring(p3) then
			continue
		end

		local v4 = guiObject:GetAttribute(UnifiedEventLogConstants.SKIP_IMPRESSION_DETECTION) == true
		local v5 = guiObject:IsA("GuiObject")

		if v5 then
			if guiObject.AbsoluteSize.X > 0 then
				v5 = guiObject.AbsoluteSize.Y > 0
			else
				v5 = false
			end
		end

		if v4 and v5 then
			return guiObject
		end

		if v3 == nil then
			v3 = guiObject
		end
	end

	return v3
end

return getDeferredPurchaseSourceTile
