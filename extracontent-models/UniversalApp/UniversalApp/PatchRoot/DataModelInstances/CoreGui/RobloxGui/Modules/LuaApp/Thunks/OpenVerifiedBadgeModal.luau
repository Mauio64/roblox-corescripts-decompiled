local CorePackages = game:GetService("CorePackages")
local Modules = script:FindFirstAncestor("Modules")
local NavigateDown = require(Modules.LuaApp.Thunks.NavigateDown)
local NavigateFromWebView = require(Modules.LuaApp.Thunks.NavigateFromWebView)
local NavigateBack = require(Modules.LuaApp.Thunks.NavigateBack)
local AppPage = require(Modules.LuaApp.AppPage)
local FFlagSignalsNavP3Dispatch = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSignalsNavP3Dispatch
local v8 = if not FFlagSignalsNavP3Dispatch then nil else require(CorePackages.Workspace.Packages.RobloxAppNavigation).NavigationCommands

return function() -- line: 16
	-- upvalues: FFlagSignalsNavP3Dispatch (copy), v8 (copy), NavigateBack (copy), AppPage (copy), NavigateFromWebView (copy), NavigateDown (copy)
	return function(p1) -- line: 17
		-- upvalues: FFlagSignalsNavP3Dispatch (copy), v8 (copy), NavigateBack (copy), AppPage (copy), NavigateFromWebView (copy), NavigateDown (copy)
		local function onClose() -- line: 18
			-- upvalues: FFlagSignalsNavP3Dispatch (copy), v8 (copy), p1 (copy), NavigateBack (copy)
			if FFlagSignalsNavP3Dispatch then
				v8.back()

				return
			end

			p1:dispatch(NavigateBack())
		end

		local t2 = {
			name = AppPage.VerifiedBadgeModal,
			extraProps = {
				onConfirm = function() -- line: 29
					-- upvalues: AppPage (copy), onClose (copy), FFlagSignalsNavP3Dispatch (copy), v8 (copy), p1 (copy), NavigateFromWebView (copy)
					local t1 = {
						detail = "https://en.help.roblox.com/hc/en-us/articles/7997207259156",
						name = AppPage.GenericWebPage,
						extraProps = {
							onClose = onClose
						}
					}

					if FFlagSignalsNavP3Dispatch then
						v8.fromWebView(v8.fromLegacyPage(t1))

						return
					end

					p1:dispatch(NavigateFromWebView(t1))
				end,
				onClose = onClose
			}
		}

		if FFlagSignalsNavP3Dispatch then
			v8.down(v8.fromLegacyPage(t2))

			return
		end

		p1:dispatch(NavigateDown(t2))
	end
end
