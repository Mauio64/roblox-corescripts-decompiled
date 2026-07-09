local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local AppPage = require(Modules.LuaApp.AppPage)
local ArgCheck = require(Modules.LuaApp.ArgCheck)
local NavigateDown = require(Modules.LuaApp.Thunks.NavigateDown)
local FFlagSignalsNavP3Dispatch = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSignalsNavP3Dispatch
local v7 = if not FFlagSignalsNavP3Dispatch then nil else require(CorePackages.Workspace.Packages.RobloxAppNavigation).NavigationCommands

if require(Modules.LuaApp.Flags.GetFFlagLuaAppUseWithLocalization)() then
	return function(p1, p2) -- line: 15
		-- upvalues: ArgCheck (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v7 (copy), NavigateDown (copy)
		ArgCheck.isType(p1, "string", "url")
		ArgCheck.isType(p2, "string", "titleKey")

		return function(p3) -- line: 19
			-- upvalues: AppPage (copy), p1 (copy), p2 (copy), FFlagSignalsNavP3Dispatch (copy), v7 (copy), NavigateDown (copy)
			local t1 = {
				name = AppPage.GenericWebPage,
				detail = p1,
				extraProps = {
					titleKey = p2
				}
			}

			if FFlagSignalsNavP3Dispatch then
				v7.down(v7.fromLegacyPage(t1))

				return
			end

			p3:dispatch(NavigateDown(t1))
		end
	end
end

return function(p4, p5) -- line: 35
	-- upvalues: AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v7 (copy), NavigateDown (copy)
	assert(type(p4) == "string", string.format("OpenWebview thunk expects url to be a string, was %s", (type(p4))))
	assert(type(p5) == "string", string.format("OpenWebview thunk expects title to be a string, was %s", (type(string))))

	return function(p6) -- line: 42
		-- upvalues: AppPage (copy), p4 (copy), p5 (copy), FFlagSignalsNavP3Dispatch (copy), v7 (copy), NavigateDown (copy)
		local t2 = {
			name = AppPage.GenericWebPage,
			detail = p4,
			extraProps = {
				title = p5
			}
		}

		if FFlagSignalsNavP3Dispatch then
			v7.down(v7.fromLegacyPage(t2))

			return
		end

		p6:dispatch(NavigateDown(t2))
	end
end
