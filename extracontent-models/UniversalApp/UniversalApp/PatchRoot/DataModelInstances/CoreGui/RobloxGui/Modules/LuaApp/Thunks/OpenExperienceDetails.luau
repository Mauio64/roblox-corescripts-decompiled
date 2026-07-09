local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local AppPage = require(Modules.LuaApp.AppPage)
local NavigateDown = require(Modules.LuaApp.Thunks.NavigateDown)
local FFlagSignalsNavP3Dispatch = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSignalsNavP3Dispatch
local v7 = if not FFlagSignalsNavP3Dispatch then nil else require(CorePackages.Workspace.Packages.RobloxAppNavigation).NavigationCommands

local function openExperienceDetailsPage(p1, p2) -- line: 12
	-- upvalues: FFlagSignalsNavP3Dispatch (copy), v7 (copy), NavigateDown (copy)
	if FFlagSignalsNavP3Dispatch then
		v7.down(v7.fromLegacyPage(p2))

		return
	end

	p1:dispatch(NavigateDown(p2))
end

return function(p3, p4) -- line: 20
	-- upvalues: AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v7 (copy), NavigateDown (copy)
	return function(p5) -- line: 21
		-- upvalues: AppPage (copy), p3 (copy), p4 (copy), FFlagSignalsNavP3Dispatch (copy), v7 (copy), NavigateDown (copy)
		local t1 = {
			name = AppPage.ExperienceDetail,
			detail = tostring(p3),
			extraProps = p4
		}

		if FFlagSignalsNavP3Dispatch then
			v7.down(v7.fromLegacyPage(t1))

			return
		end

		p5:dispatch(NavigateDown(t1))
	end
end
