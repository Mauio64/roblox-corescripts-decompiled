local scriptParent = script.Parent
local ParentParent = scriptParent.Parent.Parent
local Roact = require(ParentParent.Roact)
local t = require(ParentParent.t)
local LocaleRoactContext = require(scriptParent.LocaleRoactContext)
local Localization = require(ParentParent.RobloxAppLocales).Localization
local v7 = Roact.Component:extend("LocaleProvider")

v7.validateProps = t.interface({
	locale = t.string
})

function v7.render(p1) -- line: 19
	-- upvalues: Localization (copy), Roact (copy), LocaleRoactContext (copy)
	local v9 = Localization.new(p1.props.locale)

	return Roact.createElement(LocaleRoactContext.Provider, {
		value = v9
	}, p1.props[Roact.Children])
end

return v7
