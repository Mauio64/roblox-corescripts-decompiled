local LocalizationService = game:GetService("LocalizationService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Localization/React")

local ArgCheck = require("@game/CorePackages/Workspace/Packages/_Workspace/Localization/ArgCheck")
local RobloxLocaleIdKey = require("@game/CorePackages/Workspace/Packages/_Workspace/Localization/Localization/RobloxLocaleIdKey")
local LocalizationRoactContext = require("@game/CorePackages/Workspace/Packages/_Workspace/Localization/Localization/LocalizationRoactContext")
local localizeStrings = require("@game/CorePackages/Workspace/Packages/_Workspace/Localization/Localization/localizeStrings")

local extended = React.Component:extend("LocalizationConsumer")

function extended:init()
	local localization = self.props.localization

	if localization == nil then
		error("LocalizationConsumer must be below a LocalizationProvider.")
	end

	self.state = { locale = LocalizationService.RobloxLocaleId }

	function self.updateLocalization(p2)
		local locale = localization:GetLocale()

		if locale ~= self.state.locale then
			self:setState({ locale = locale })
		end
	end

	self.connections = { localization.changed:connect(self.updateLocalization) }
end

function extended.willUnmount(p2)
	for k, connection in pairs(p2.connections) do
		connection:disconnect()
	end
end

function extended.render(p2)
	local localization = p2.props.localization

	local render = p2.props.render
	local stringsToBeLocalized = p2.props.stringsToBeLocalized

	ArgCheck.isType(render, "function", "LocalizationConsumer.props.render")
	ArgCheck.isType(stringsToBeLocalized, "table", "LocalizationConsumer.props.stringsToBeLocalized")

	local localesByModule = localizeStrings(localization, stringsToBeLocalized)
	localesByModule[RobloxLocaleIdKey] = p2.state.locale

	return render(localesByModule)
end

local function LocalizationContextConsumer(p2)
	return React.createElement(LocalizationRoactContext.Consumer, {
		render = function(p3)
			return React.createElement(extended, {
				localization = p3,
				render = p2.render,
				stringsToBeLocalized = p2.stringsToBeLocalized
			})
		end
	})
end

return LocalizationContextConsumer
