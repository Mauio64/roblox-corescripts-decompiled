local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local UserInputService = game:GetService("UserInputService")
local AppPage = require(Modules.LuaApp.AppPage)
local CloseCentralOverlay = require(Modules.LuaApp.Thunks.CloseCentralOverlay)
local ApiFetchIAPProducts = require(Modules.LuaApp.Thunks.ApiFetchIAPProducts)
local OpenNativePurchase = require(Modules.LuaApp.Thunks.Economy.OpenNativePurchase)
local NavigateDown = require(Modules.LuaApp.Thunks.NavigateDown)
local SetCentralOverlay = require(Modules.LuaApp.Actions.SetCentralOverlay)
local FFlagSignalsNavP3Dispatch = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSignalsNavP3Dispatch
local v11 = if not FFlagSignalsNavP3Dispatch then nil else require(CorePackages.Workspace.Packages.RobloxAppNavigation).NavigationCommands

return function(p1) -- line: 18
	-- upvalues: SetCentralOverlay (copy), ApiFetchIAPProducts (copy), CloseCentralOverlay (copy), UserInputService (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v11 (copy), NavigateDown (copy), OpenNativePurchase (copy)
	return {
		dispatchCentralOverlay = function(p2, p3) -- line: 20
			-- upvalues: p1 (copy), SetCentralOverlay (copy)
			return p1(SetCentralOverlay(p2, p3))
		end,
		dispatchFetchIAPProducts = function(p4) -- line: 23
			-- upvalues: p1 (copy), ApiFetchIAPProducts (copy)
			p1(ApiFetchIAPProducts.Fetch(p4))
		end,
		closeCentralOverlay = function() -- line: 26
			-- upvalues: p1 (copy), CloseCentralOverlay (copy)
			p1(CloseCentralOverlay())
		end,
		promptPremium = function(p5, p6) -- line: 29
			-- upvalues: UserInputService (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v11 (copy), p1 (copy), NavigateDown (copy), OpenNativePurchase (copy)
			local Platform = UserInputService:GetPlatform()

			if Platform == Enum.Platform.Windows or Platform == Enum.Platform.OSX then
				local t1 = {
					name = AppPage.BuildersClub
				}

				if FFlagSignalsNavP3Dispatch then
					v11.down(v11.fromLegacyPage(t1))

					return
				end

				p1(NavigateDown(t1))

				return
			end

			p1(OpenNativePurchase(p5, p6))
		end
	}
end
