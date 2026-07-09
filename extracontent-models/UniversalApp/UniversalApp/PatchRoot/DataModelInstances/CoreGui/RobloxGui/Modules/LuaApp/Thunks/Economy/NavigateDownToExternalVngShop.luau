local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local AppPage = require(Modules.LuaApp.AppPage)
local NavigateDown = require(Modules.LuaApp.Thunks.NavigateDown)
local SetCentralOverlay = require(Modules.LuaApp.Actions.SetCentralOverlay)
local ApiFetchVngShopUrl = require(Modules.LuaApp.Thunks.Economy.ApiFetchVngShopUrl)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local GetFStringVNGWebshopUrl = SharedFlags.GetFStringVNGWebshopUrl
local FFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local v10 = if not FFlagSignalsNavP3Dispatch then nil else require(CorePackages.Workspace.Packages.RobloxAppNavigation).NavigationCommands

return function(p1, p2) -- line: 18
	-- upvalues: ApiFetchVngShopUrl (copy), GetFStringVNGWebshopUrl (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v10 (copy), NavigateDown (copy), SetCentralOverlay (copy)
	return function(p3) -- line: 19
		-- upvalues: ApiFetchVngShopUrl (copy), p2 (copy), GetFStringVNGWebshopUrl (copy), AppPage (copy), p1 (copy), FFlagSignalsNavP3Dispatch (copy), v10 (copy), NavigateDown (copy), SetCentralOverlay (copy)
		p3:dispatch(ApiFetchVngShopUrl(p2)):andThen(function(p4) -- line: 22
			-- upvalues: GetFStringVNGWebshopUrl (copy), AppPage (copy), p1 (copy), FFlagSignalsNavP3Dispatch (copy), v10 (copy), p3 (copy), NavigateDown (copy), SetCentralOverlay (copy)
			local v15 = p4.vngShopRedirectUrl or GetFStringVNGWebshopUrl()
			local t1 = {
				name = AppPage.GenericWebPage,
				detail = v15,
				extraProps = {
					onClose = p1
				}
			}

			if FFlagSignalsNavP3Dispatch then
				v10.down(v10.fromLegacyPage(t1))
			else
				p3:dispatch(NavigateDown(t1))
			end

			p3:dispatch(SetCentralOverlay())
		end):catch(function(_) -- line: 38
			-- upvalues: GetFStringVNGWebshopUrl (copy), AppPage (copy), p1 (copy), FFlagSignalsNavP3Dispatch (copy), v10 (copy), p3 (copy), NavigateDown (copy), SetCentralOverlay (copy)
			local v18 = GetFStringVNGWebshopUrl()
			local t2 = {
				name = AppPage.GenericWebPage,
				detail = v18,
				extraProps = {
					onClose = p1
				}
			}

			if FFlagSignalsNavP3Dispatch then
				v10.down(v10.fromLegacyPage(t2))
			else
				p3:dispatch(NavigateDown(t2))
			end

			p3:dispatch(SetCentralOverlay())
		end)
	end
end
