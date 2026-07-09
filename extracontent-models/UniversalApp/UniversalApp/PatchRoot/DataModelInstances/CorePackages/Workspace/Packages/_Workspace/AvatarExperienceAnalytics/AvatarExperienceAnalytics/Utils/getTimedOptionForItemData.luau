local UnifiedEventLogEnums = require(script.Parent.Parent.UnifiedEventLogEnums)
local t1 = {
	[0] = UnifiedEventLogEnums.MarketplaceTimedOption.PERMANENT,
	[3] = UnifiedEventLogEnums.MarketplaceTimedOption.DAYS_3,
	[7] = UnifiedEventLogEnums.MarketplaceTimedOption.DAYS_7,
	[14] = UnifiedEventLogEnums.MarketplaceTimedOption.DAYS_14
}

function getTimedOptionForItemData(p1) -- line: 10
	-- upvalues: t1 (copy), UnifiedEventLogEnums (copy)
	if p1 and p1.timedOptions then
		for _, v5 in p1.timedOptions do
			if v5.selected then
				return t1[v5.days]
			end
		end

		return UnifiedEventLogEnums.MarketplaceTimedOption.PERMANENT
	end

	return UnifiedEventLogEnums.MarketplaceTimedOption.PERMANENT
end

return getTimedOptionForItemData
