local Parent = script:FindFirstAncestor("Localization").Parent
local LocalizationService = game:GetService("LocalizationService")
local React = require(Parent.React)
local ArgCheck = require(Parent.ArgCheck)
local RobloxLocaleIdKey = require(script.Parent.RobloxLocaleIdKey)
local LocalizationRoactContext = require(script.Parent.LocalizationRoactContext)
local localizeStrings = require(script.Parent.localizeStrings)
local v8 = React.Component:extend("LocalizationConsumer")

function v8.init(p1) -- line: 14
	-- upvalues: LocalizationService (copy)
	local localization = p1.props.localization

	if localization == nil then
		error("LocalizationConsumer must be below a LocalizationProvider.")
	end

	p1.state = {
		locale = LocalizationService.RobloxLocaleId
	}

	function p1.updateLocalization(_) -- line: 25
		-- upvalues: localization (copy), p1 (copy)
		local Locale = localization:GetLocale()

		if Locale ~= p1.state.locale then
			p1:setState({
				locale = Locale
			})
		end
	end

	p1.connections = { localization.changed:connect(p1.updateLocalization) }
end
function v8.willUnmount(p3) -- line: 39
	for _, v in pairs(p3.connections) do
		v:disconnect()
	end
end
function v8.render(p4) -- line: 45
	-- upvalues: ArgCheck (copy), localizeStrings (copy), RobloxLocaleIdKey (copy)
	local localization = p4.props.localization
	local render = p4.props.render
	local stringsToBeLocalized = p4.props.stringsToBeLocalized

	ArgCheck.isType(render, "function", "LocalizationConsumer.props.render")
	ArgCheck.isType(stringsToBeLocalized, "table", "LocalizationConsumer.props.stringsToBeLocalized")

	local v19 = localizeStrings(localization, stringsToBeLocalized)

	v19[RobloxLocaleIdKey] = p4.state.locale

	return render(v19)
end

local function LocalizationContextConsumer(p5) -- line: 60
	-- upvalues: React (copy), LocalizationRoactContext (copy), v8 (copy)
	return React.createElement(LocalizationRoactContext.Consumer, {
		render = function(p6) -- line: 62
			-- upvalues: React (copy), v8 (copy), p5 (copy)
			return React.createElement(v8, {
				localization = p6,
				render = p5.render,
				stringsToBeLocalized = p5.stringsToBeLocalized
			})
		end
	})
end

return LocalizationContextConsumer
