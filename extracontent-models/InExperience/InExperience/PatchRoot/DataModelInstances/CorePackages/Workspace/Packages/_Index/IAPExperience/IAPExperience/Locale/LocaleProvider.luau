local parent = script.Parent
local parent2 = parent.Parent.Parent
local Roact = require(parent2.Roact)
local t = require(parent2.t)

local LocaleRoactContext = require(parent.LocaleRoactContext)

local RobloxAppLocales = require(parent2.RobloxAppLocales)
local Localization = RobloxAppLocales.Localization

local extended = Roact.Component:extend("LocaleProvider")

extended.validateProps = t.interface({ locale = t.string })

function extended.render(p)
	local v = Localization.new(p.props.locale)
	return Roact.createElement(LocaleRoactContext.Provider, { value = v }, p.props[Roact.Children])
end

return extended
