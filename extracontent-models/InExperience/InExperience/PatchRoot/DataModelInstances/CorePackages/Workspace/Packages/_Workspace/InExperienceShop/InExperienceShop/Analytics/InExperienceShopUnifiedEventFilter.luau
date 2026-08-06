local Parent = script:FindFirstAncestor("InExperienceShop").Parent
local UnifiedEventLogEnums = require(Parent.AvatarExperienceAnalytics).UnifiedEventLogEnums
local MarketplaceUnifiedAction = UnifiedEventLogEnums.MarketplaceUnifiedAction
local MarketplaceUnifiedItemType = UnifiedEventLogEnums.MarketplaceUnifiedItemType
local UnifiedLoggingSurface = require(Parent.AvatarExperienceNavigation).Enums.UnifiedLoggingSurface
local t1 = {}
local t2 = {
	[UnifiedLoggingSurface.IN_EXPERIENCE_SHOP_HOME] = true,
	[UnifiedLoggingSurface.IN_EXPERIENCE_SHOP_DETAILS] = true,
	[UnifiedLoggingSurface.IN_EXPERIENCE_SHOP_SEARCH] = true
}
local t3 = {
	[MarketplaceUnifiedItemType.GAME_PASS] = true,
	[MarketplaceUnifiedItemType.DEVELOPER_PRODUCT] = true,
	[MarketplaceUnifiedItemType.ROBUX] = true,
	[MarketplaceUnifiedItemType.ROBUX_WITH_BONUS] = true
}

function t1.hasItemId(p1) -- line: 27
	local itemId = p1.itemId

	return itemId ~= nil and itemId ~= ""
end
function t1.hasValidItemType(p2) -- line: 32
	-- upvalues: t3 (copy)
	return t3[p2.itemType] == true
end
function t1.hasValidAction(p3) -- line: 36
	-- upvalues: MarketplaceUnifiedAction (copy)
	local action = p3.action

	return action ~= nil and action ~= MarketplaceUnifiedAction.UNDEFINED_ACTION
end
function t1.hasValidSurface(p4) -- line: 41
	-- upvalues: t2 (copy)
	return t2[p4.surface] == true
end
function t1.hasValidSizeAndPosition(p5) -- line: 45
	-- upvalues: MarketplaceUnifiedAction (copy)
	local action = p5.action

	if action ~= MarketplaceUnifiedAction.ITEM_IMPRESSION and (action ~= MarketplaceUnifiedAction.ITEM_SELECTED and action ~= MarketplaceUnifiedAction.ITEM_DESELECTED and action ~= MarketplaceUnifiedAction.PURCHASE_SUCCESS) then
		return true
	end

	local v17 = p5.screenSizeWidth or 0
	local v18 = p5.screenSizeHeight or 0
	local v19 = p5.elementSizeWidth or 0
	local v20 = p5.elementSizeHeight or 0
	local v21 = p5.gridPositionRow or 0
	local v22 = p5.gridPositionColumn or 0

	return v17 > 0 and (v18 > 0 and (v19 > 0 and (v20 > 0 and (v21 > 0 and v22 > 0))))
end
function t1.hasUniverseId(p6) -- line: 71
	local universeId = p6.universeId

	if typeof(universeId) == "number" then
		return universeId > 0
	end

	if typeof(universeId) == "string" then
		return universeId ~= ""
	end

	return false
end
function t1.filter(p7) -- line: 82
	-- upvalues: t1 (copy)
	local v26 = t1.hasItemId(p7)
	local v27 = t1.hasValidItemType(p7)
	local v28 = t1.hasValidAction(p7)
	local v29 = t1.hasValidSurface(p7)
	local v30 = t1.hasValidSizeAndPosition(p7)
	local v31 = t1.hasUniverseId(p7)
	local v32 = v26 and (v27 and (v28 and (v29 and (v30 and v31))))

	if not v32 then
		local s1 = ""

		if not v26 then
			s1 ..= "hasItemId "
		end

		if not v27 then
			s1 ..= "hasValidItemType "
		end

		if not v28 then
			s1 ..= "hasValidAction "
		end

		if not v29 then
			s1 ..= "hasValidSurface "
		end

		if not v30 then
			s1 ..= "hasValidSizeAndPosition "
		end

		if not v31 then
			s1 ..= "hasUniverseId "
		end

		warn("Failed to send in-experience shop unified event. Failing Check(s): " .. s1)
	end

	return v32
end

return t1
