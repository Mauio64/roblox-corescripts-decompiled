local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Localization/React")
local LocalizationRoactContext = require("@game/CorePackages/Workspace/Packages/_Workspace/Localization/Localization/LocalizationRoactContext")

local function LocalizationProvider(p2)
	return React.createElement(LocalizationRoactContext.Provider, { value = p2.localization }, p2.children)
end

return LocalizationProvider
