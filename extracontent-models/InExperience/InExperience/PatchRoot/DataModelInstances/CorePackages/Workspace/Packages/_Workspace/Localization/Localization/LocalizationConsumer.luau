local parent = script:FindFirstAncestor("Localization").Parent
local LocalizationService = game:GetService("LocalizationService")

local React = require(parent.React)

local ArgCheck = require(parent.ArgCheck)
local RobloxLocaleIdKey = require(script.Parent.RobloxLocaleIdKey)
local LocalizationRoactContext = require(script.Parent.LocalizationRoactContext)
local localizeStrings = require(script.Parent.localizeStrings)

local extended = React.Component:extend("LocalizationConsumer")

function extended:init()
	local localization = self.props.localization

	if localization == nil then
		error("LocalizationConsumer must be below a LocalizationProvider.")
	end

	self.state = { locale = LocalizationService.RobloxLocaleId }

	function self.updateLocalization(_)
		local locale = localization:GetLocale()

		if locale ~= self.state.locale then
			self:setState({ locale = locale })
		end
	end

	self.connections = { localization.changed:connect(self.updateLocalization) }
end

function extended.willUnmount(p)
	for _, connection in pairs(p.connections) do
		connection:disconnect()
	end
end

function extended.render(p)
	local localization = p.props.localization

	local render = p.props.render
	local stringsToBeLocalized = p.props.stringsToBeLocalized

	ArgCheck.isType(render, "function", "LocalizationConsumer.props.render")
	ArgCheck.isType(stringsToBeLocalized, "table", "LocalizationConsumer.props.stringsToBeLocalized")

	local localesByRobloxLocaleIdKey = localizeStrings(localization, stringsToBeLocalized)
	localesByRobloxLocaleIdKey[RobloxLocaleIdKey] = p.state.locale

	return render(localesByRobloxLocaleIdKey)
end

local function LocalizationContextConsumer(p)
	return React.createElement(LocalizationRoactContext.Consumer, {
		render = function(localization)
			return React.createElement(extended, {
				localization = localization,
				render = p.render,
				stringsToBeLocalized = p.stringsToBeLocalized
			})
		end
	})
end

return LocalizationContextConsumer
