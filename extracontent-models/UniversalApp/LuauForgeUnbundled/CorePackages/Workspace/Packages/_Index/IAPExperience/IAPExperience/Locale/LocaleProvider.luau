local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/Roact")
local t = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/t")

local LocaleRoactContext = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Locale/LocaleRoactContext")

local localization = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/RobloxAppLocales").Localization

local extended = Roact.Component:extend("LocaleProvider")

extended.validateProps = t.interface({ locale = t.string })

function extended.render(p2)
	local v5 = localization.new(p2.props.locale)
	return Roact.createElement(LocaleRoactContext.Provider, { value = v5 }, p2.props[Roact.Children])
end

return extended
