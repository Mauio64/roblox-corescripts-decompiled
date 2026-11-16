local AmpUpsell = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AmpUpsell")

local module2 = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AccountUpgrade/Eligibility/getAvailability")

return {
	AccessResponseEnum = AmpUpsell.AmpEnums.AccessResponseEnum,
	getAvailability = module2
}
