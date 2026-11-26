local UnifiedEventLogConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/UnifiedEventLogConstants")

local function getDeferredPurchaseSourceTile(items, p2, p3, p4)
	if p3 == nil then
		return nil
	end

	local v5 = UnifiedEventLogConstants.ATTRIBUTE_PREFIX .. "itemId"
	local v6 = UnifiedEventLogConstants.ATTRIBUTE_PREFIX .. "itemType"
	local v7 = nil

	for k, guiObject in items do
		if not (guiObject ~= p2 and tostring(guiObject:GetAttribute(v5)) == tostring(p3)) then
			continue
		end

		if tostring(guiObject:GetAttribute(v6)) ~= tostring(p4) then
			continue
		end

		local v8 = guiObject:GetAttribute(UnifiedEventLogConstants.SKIP_IMPRESSION_DETECTION) == true
		local v9 = guiObject:IsA("GuiObject")

		if v9 then
			v9 = guiObject.AbsoluteSize.X > 0 and guiObject.AbsoluteSize.Y > 0
		end

		if v8 and v9 then
			return guiObject
		end

		if v7 == nil then
			v7 = guiObject
		end
	end

	return v7
end

return getDeferredPurchaseSourceTile
