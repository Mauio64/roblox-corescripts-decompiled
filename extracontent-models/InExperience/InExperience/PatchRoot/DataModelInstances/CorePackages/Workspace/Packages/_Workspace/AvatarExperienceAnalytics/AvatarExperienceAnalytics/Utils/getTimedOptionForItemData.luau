local UnifiedEventLogEnums = require(script.Parent.Parent.UnifiedEventLogEnums)

local v = {
	[0] = UnifiedEventLogEnums.MarketplaceTimedOption.PERMANENT,
	[3] = UnifiedEventLogEnums.MarketplaceTimedOption.DAYS_3,
	[7] = UnifiedEventLogEnums.MarketplaceTimedOption.DAYS_7,
	[14] = UnifiedEventLogEnums.MarketplaceTimedOption.DAYS_14
}

function getTimedOptionForItemData(p)
	if not (p and p.timedOptions) then
		return UnifiedEventLogEnums.MarketplaceTimedOption.PERMANENT
	end

	for _, timedOption in p.timedOptions do
		if timedOption.selected then
			return v[timedOption.days]
		end
	end

	return UnifiedEventLogEnums.MarketplaceTimedOption.PERMANENT
end

return getTimedOptionForItemData
