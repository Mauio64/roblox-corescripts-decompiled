local module = require("@luauforge/bundled/dwM")
return require("@game/CoreGui/RobloxGui/Modules/PlayerList/ActionCreator")("SetHumanoidDescriptionProperties", function(items)
	module.isType(
		items,
		"table",
		"tableOfHumanoidDescriptionProperties passed into SetHumanoidDescriptionProperties"
	)

	for k, item in pairs(items) do
		module.isNonEmptyString(k, "tableOfHumanoidDescriptionProperties's key (outfitId)")
		module.isType(
			item,
			"table",
			"tableOfHumanoidDescriptionProperties's value (table of HumanoidDescription properties)"
		)
	end

	return { tableOfHumanoidDescriptionProperties = items }
end)
