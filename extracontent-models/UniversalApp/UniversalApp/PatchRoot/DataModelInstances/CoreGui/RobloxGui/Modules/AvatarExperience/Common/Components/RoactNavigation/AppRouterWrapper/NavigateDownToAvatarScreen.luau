local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Cryo = require(CorePackages.Packages.Cryo)
local AppPage = require(Modules.LuaApp.AppPage)
local AvatarScreenProperties = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).AvatarRoute.AvatarScreenProperties
local NavigateDown = require(Modules.LuaApp.Thunks.NavigateDown)
local FFlagSignalsNavP3Dispatch = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSignalsNavP3Dispatch
local v8 = if not FFlagSignalsNavP3Dispatch then nil else require(CorePackages.Workspace.Packages.RobloxAppNavigation).NavigationCommands

local function NavigateDownToAvatarScreen(s1: string, s2: string?, p1) -- line: 21
	-- upvalues: AvatarScreenProperties (copy), AppPage (copy), Cryo (copy), FFlagSignalsNavP3Dispatch (copy), v8 (copy), NavigateDown (copy)
	local v13 = AvatarScreenProperties[s1]
	local v14 = v13 and v13.isTransparent

	return function(p2) -- line: 24
		-- upvalues: v14 (copy), AppPage (copy), s2 (copy), s1 (copy), Cryo (copy), p1 (copy), FFlagSignalsNavP3Dispatch (copy), v8 (copy), NavigateDown (copy)
		local t1 = {
			name = v14 and AppPage.AvatarExperienceWrapperTransparent or AppPage.AvatarExperienceWrapper,
			detail = s2,
			extraProps = {
				routeName = s1,
				params = Cryo.Dictionary.join(p1 or {}, {
					detail = s2
				})
			}
		}

		if FFlagSignalsNavP3Dispatch then
			v8.down(v8.fromLegacyPage(t1))

			return
		end

		return p2:dispatch(NavigateDown(t1))
	end
end

return NavigateDownToAvatarScreen
