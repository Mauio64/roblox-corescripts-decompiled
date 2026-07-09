local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local SetNavigationLocked = require(Modules.LuaApp.Thunks.SetNavigationLocked)
local Cryo = require(CorePackages.Packages.Cryo)
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local RNAdapterThunk = require(Modules.LuaApp.Thunks.RNAdapterThunk)
local FlagSettings = require(Modules.LuaApp.FlagSettings)
local Constants = require(Modules.LuaApp.Constants)

require(CorePackages.Workspace.Packages.NavigationRodux)

local FFlagSignalsNavP2NavigationPrimitives = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSignalsNavP2NavigationPrimitives
local v10 = if not FFlagSignalsNavP2NavigationPrimitives then nil else require(CorePackages.Workspace.Packages.RobloxAppNavigation).NavigationCommands

local function getDefaultRoute() -- line: 18
	-- upvalues: FlagSettings (copy)
	return {{
		name = FlagSettings.GetDefaultAppPage(),
		rnKey = FlagSettings.GetDefaultAppPage()
	}}
end

local _, v13 = require(Modules.LuaApp.Components.AppNav.GetIABottomBarItems)()

return function(p1, p2) -- line: 30
	-- upvalues: FFlagSignalsNavP2NavigationPrimitives (copy), getDefaultRoute (copy), v10 (copy), v13 (copy), RoactNavigation (copy), Constants (copy), RNAdapterThunk (copy), Cryo (copy), SetNavigationLocked (copy)
	if FFlagSignalsNavP2NavigationPrimitives then
		return function() -- line: 33
			-- upvalues: p1 (copy), p2 (copy), getDefaultRoute (copy), v10 (copy), v13 (copy), RoactNavigation (copy), Constants (copy)
			local v16 = p1

			if p2 ~= nil then
				v16 = p2[#p2]
			end

			if v16 == nil or #v16 == 0 then
				v16 = getDefaultRoute()
			end

			assert(v16, "not nil")

			local t1 = {}

			for _, v19 in v16 do
				table.insert(t1, v10.fromLegacyPage(v19))
			end

			v10.resetStack(t1, {
				wrapAction = function(p3, p4) -- line: 50
					-- upvalues: v13 (copy), RoactNavigation (copy), Constants (copy)
					if v13[p4.routeName] ~= nil then
						return RoactNavigation.Actions.navigate({
							routeName = Constants.TempRnSwitchNavigatorName,
							action = p3,
							key = Constants.TempRnSwitchNavigatorName
						})
					end

					return nil
				end
			}, true)
		end
	end

	return RNAdapterThunk.new("ResetNavigationHistory", function(p5, p6) -- line: 65
		-- upvalues: p1 (copy), p2 (copy), getDefaultRoute (copy), RoactNavigation (copy), Cryo (copy), v13 (copy), Constants (copy), SetNavigationLocked (copy)
		local v22 = p1

		if p2 ~= nil then
			v22 = p2[#p2]
		end

		if v22 == nil or #v22 == 0 then
			v22 = getDefaultRoute()
		end

		assert(v22, "not nil")

		local t2 = {}

		for _, v in ipairs(v22) do
			local v26 = RoactNavigation.Actions.navigate({
				routeName = v.name,
				params = Cryo.Dictionary.join(v, {
					name = Cryo.None,
					rnKey = Cryo.None
				}),
				key = v.rnKey
			})

			if v13[v.name] ~= nil then
				table.insert(t2, RoactNavigation.Actions.navigate({
					routeName = Constants.TempRnSwitchNavigatorName,
					action = v26,
					key = Constants.TempRnSwitchNavigatorName
				}))
			else
				table.insert(t2, v26)
			end
		end

		p5:dispatch(SetNavigationLocked(true))
		p6(RoactNavigation.StackActions.reset({
			index = #t2,
			actions = t2
		}))
	end)
end
