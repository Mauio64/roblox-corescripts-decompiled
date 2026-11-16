local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local module = require("@luauforge/bundled/dCp")
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local accountSettingsUpsell = require("@luauforge/bundled/eeI").AccountSettingsUpsell
local module2 = require("@luauforge/bundled/eee")
local module3 = require("@luauforge/bundled/fsq")
local Cryo = require(CorePackages.Packages.Cryo)
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSignalsNavP3Dispatch
local navigationCommands

if fFlagSignalsNavP3Dispatch then
	navigationCommands = require("@luauforge/bundled/dCu").NavigationCommands
else
	navigationCommands = nil
end

return function(options)
	local v5 = useDispatch()
	local function fn(p2)
		local v6 = {
			name = module.GenericWebPage,
			detail = module3.static.settings.account(),
			extraProps = { title = p2 }
		}

		if fFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v6))
		else
			v5(module2(v6))
		end
	end

	local joined = Cryo.Dictionary.join(options or {}, { openAccountSettings = fn })
	return React.createElement(accountSettingsUpsell, joined)
end
