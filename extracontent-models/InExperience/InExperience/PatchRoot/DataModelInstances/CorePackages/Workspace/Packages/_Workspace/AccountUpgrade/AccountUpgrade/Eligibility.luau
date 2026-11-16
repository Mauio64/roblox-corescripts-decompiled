local parent = script:FindFirstAncestor("AccountUpgrade").Parent

local AmpUpsell = require(parent.AmpUpsell)

local getAvailability = require(script.getAvailability)

return {
	AccessResponseEnum = AmpUpsell.AmpEnums.AccessResponseEnum,
	getAvailability = getAvailability
}
