local CorePackages = game:GetService("CorePackages")

local module = require("@luauforge/bundled/dHr")

local Cryo = require(CorePackages.Packages.Cryo)
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local module2 = require("@luauforge/bundled/dHs")
local module3 = require("@luauforge/bundled/dCo")
local module4 = require("@luauforge/bundled/dwA")
require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local fFlagSignalsNavP2NavigationPrimitives = SharedFlags.FFlagSignalsNavP2NavigationPrimitives
local fFlagEnableArgus = SharedFlags.FFlagEnableArgus
local navigationCommands

if fFlagSignalsNavP2NavigationPrimitives then
	navigationCommands = require("@luauforge/bundled/dCu").NavigationCommands
else
	navigationCommands = nil
end

local function getDefaultRoute()
	return {
		{ name = module3.GetDefaultAppPage(), rnKey = module3.GetDefaultAppPage() }
	}
end

local module6 = require("@luauforge/bundled/dHt")
local module7 = require("@luauforge/bundled/dCp")
local v5, v6 = module6()

local function isSwitchMember(p2)
	if p2 == module7.Moments then
		return fFlagEnableArgus
	end

	return v6[p2] ~= nil
end

return function(p2, list)
	if fFlagSignalsNavP2NavigationPrimitives then
		return function()
			local v7 = p2

			if list ~= nil then
				v7 = list[#list]
			end

			if v7 == nil or #v7 == 0 then
				v7 = getDefaultRoute()
			end

			assert(v7, "not nil")

			local v8 = {}

			for k, v9 in v7 do
				table.insert(v8, navigationCommands.fromLegacyPage(v9))
			end

			navigationCommands.resetStack(v8, {
				wrapAction = function(p3, p4)
					local routeName = p4.routeName
					local v9 = if routeName == module7.Moments then fFlagEnableArgus else v6[routeName] ~= nil

					if v9 then
						return RoactNavigation.Actions.navigate({
							routeName = module4.TempRnSwitchNavigatorName,
							action = p3,
							key = module4.TempRnSwitchNavigatorName
						})
					end

					return nil
				end
			}, true)
		end
	end

	return module2.new("ResetNavigationHistory", function(object, callback)
		local v7 = p2

		if list ~= nil then
			v7 = list[#list]
		end

		if v7 == nil or #v7 == 0 then
			v7 = getDefaultRoute()
		end

		assert(v7, "not nil")

		local v8 = {}

		for i, v9 in ipairs(v7) do
			local navigate = RoactNavigation.Actions.navigate({
				routeName = v9.name,
				params = Cryo.Dictionary.join(v9, {
					name = Cryo.None,
					rnKey = Cryo.None
				}),
				key = v9.rnKey
			})

			local name = v9.name
			local v10 = if name == module7.Moments then fFlagEnableArgus else v6[name] ~= nil

			if v10 then
				table.insert(
					v8,
					RoactNavigation.Actions.navigate({
						routeName = module4.TempRnSwitchNavigatorName,
						action = navigate,
						key = module4.TempRnSwitchNavigatorName
					})
				)
			else
				table.insert(v8, navigate)
			end
		end

		object:dispatch(module(true))
		callback(RoactNavigation.StackActions.reset({
			index = #v8,
			actions = v8
		}))
	end)
end
