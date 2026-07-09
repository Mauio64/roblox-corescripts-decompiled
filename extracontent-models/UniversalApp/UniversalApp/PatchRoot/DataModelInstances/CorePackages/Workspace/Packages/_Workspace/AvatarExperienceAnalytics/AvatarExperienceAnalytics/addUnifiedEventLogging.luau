local CollectionService = game:GetService("CollectionService")
local Parent = script:FindFirstAncestor("AvatarExperienceAnalytics").Parent
local UnifiedEventLogConstants = require(script.Parent.UnifiedEventLogConstants)
local FFlagAXMISEnableMultiShoppingUnifiedEvents = require(Parent.AvatarExperienceFlags).FFlagAXMISEnableMultiShoppingUnifiedEvents
local t1 = {
	table = true,
	string = true,
	number = true,
	boolean = true
}

return function(t2: {[any]: any}, t3: {[any]: any}, t4: {[any]: any}?) -- line: 23
	-- upvalues: CollectionService (copy), UnifiedEventLogConstants (copy), FFlagAXMISEnableMultiShoppingUnifiedEvents (copy), t1 (copy)
	if not t2.current then
		return
	end

	CollectionService:AddTag(t2.current, UnifiedEventLogConstants.TAG_NAME)

	if t4 and t4.hasDeferredActions then
		t2.current:SetAttribute(UnifiedEventLogConstants.HAS_DEFERRED_ACTION, true)
	end

	if FFlagAXMISEnableMultiShoppingUnifiedEvents and t4 and t4.isSelected ~= nil then
		t2.current:SetAttribute(UnifiedEventLogConstants.IS_SELECTED, t4.isSelected)
	end

	if t4 and t4.sessionTagName then
		t2.current:SetAttribute(UnifiedEventLogConstants.SESSION_TAG_NAME, t4.sessionTagName)
	end

	if t3 then
		for v9, _ in t3 do
			if t1[type(t3[v9])] then
				local v11 = if type(t3[v9]) ~= "table" then t3[v9] else table.concat(t3[v9], ",")

				t2.current:SetAttribute(UnifiedEventLogConstants.ATTRIBUTE_PREFIX .. v9, v11)
			end
		end
	end
end
