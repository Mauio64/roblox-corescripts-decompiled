local CorePackages = game:GetService("CorePackages")
local Modules = script:FindFirstAncestor("Modules")
local React = require(CorePackages.Packages.React)
local AppPage = require(Modules.LuaApp.AppPage)
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local AccountSettingsUpsell = require(CorePackages.Workspace.Packages.AmpUpsell).AccountSettingsUpsell
local NavigateDown = require(Modules.LuaApp.Thunks.NavigateDown)
local UrlBuilder = require(Modules.LuaApp.Http.UrlBuilder)
local Cryo = require(CorePackages.Packages.Cryo)
local FFlagSignalsNavP3Dispatch = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSignalsNavP3Dispatch
local v11 = if not FFlagSignalsNavP3Dispatch then nil else require(CorePackages.Workspace.Packages.RobloxAppNavigation).NavigationCommands

return function(p1) -- line: 17
	-- upvalues: useDispatch (copy), AppPage (copy), UrlBuilder (copy), FFlagSignalsNavP3Dispatch (copy), v11 (copy), NavigateDown (copy), Cryo (copy), React (copy), AccountSettingsUpsell (copy)
	local v13 = useDispatch()
	local v14 = Cryo.Dictionary.join(p1 or {}, {
		openAccountSettings = function(p2) -- line: 19
			-- upvalues: AppPage (copy), UrlBuilder (copy), FFlagSignalsNavP3Dispatch (copy), v11 (copy), v13 (copy), NavigateDown (copy)
			local t1 = {
				name = AppPage.GenericWebPage,
				detail = UrlBuilder.static.settings.account(),
				extraProps = {
					title = p2
				}
			}

			if FFlagSignalsNavP3Dispatch then
				v11.down(v11.fromLegacyPage(t1))

				return
			end

			v13(NavigateDown(t1))
		end
	})

	return React.createElement(AccountSettingsUpsell, v14)
end
