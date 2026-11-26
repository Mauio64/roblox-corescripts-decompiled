local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Localization/React")
local ArgCheck = require("@game/CorePackages/Workspace/Packages/_Workspace/Localization/ArgCheck")
local LocalizationConsumer = require("@game/CorePackages/Workspace/Packages/_Workspace/Localization/Localization/LocalizationConsumer")

local function withLocalization(p2)
	ArgCheck.isType(p2, "table", "stringsToBeLocalized passed to withLocalization()")

	return function(p3)
		ArgCheck.isType(p3, "function", "render passed to withLocalization()")

		return React.createElement(LocalizationConsumer, { render = p3, stringsToBeLocalized = p2 })
	end
end

return withLocalization
