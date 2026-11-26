local UnifiedEventLogEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/UnifiedEventLogEnums")

local v5 = {
	[0] = UnifiedEventLogEnums.MarketplaceTimedOption.PERMANENT,
	[3] = UnifiedEventLogEnums.MarketplaceTimedOption.DAYS_3,
	[7] = UnifiedEventLogEnums.MarketplaceTimedOption.DAYS_7,
	[14] = UnifiedEventLogEnums.MarketplaceTimedOption.DAYS_14
}

function LUAUFORGE_MODULE_GLOBALS_ayN_getTimedOptionForItemData(p2)
	if not (p2 and p2.timedOptions) then
		return UnifiedEventLogEnums.MarketplaceTimedOption.PERMANENT
	end

	for k, timedOption in p2.timedOptions do
		if timedOption.selected then
			return v5[timedOption.days]
		end
	end

	return UnifiedEventLogEnums.MarketplaceTimedOption.PERMANENT
end

return LUAUFORGE_MODULE_GLOBALS_ayN_getTimedOptionForItemData
