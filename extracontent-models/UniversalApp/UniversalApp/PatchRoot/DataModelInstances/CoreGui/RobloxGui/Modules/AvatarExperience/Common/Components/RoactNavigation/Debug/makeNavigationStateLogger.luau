local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local dumpNavigationHierarchy = require(Modules.AvatarExperience.Common.Components.RoactNavigation.Debug.dumpNavigationHierarchy)
local v4 = require(CorePackages.Workspace.Packages.AppDebug).LogTree.logger("ax.rn.state")

return function(s1: string, b1: boolean?) -- line: 20
	-- upvalues: v4 (copy), dumpNavigationHierarchy (copy)
	if b1 == nil then
		b1 = v4.active[v4.Levels.Trace]
	end

	if not b1 then
		return function(_, _, _) -- line: 26
		end
	end

	local u7 = nil

	return function(_, p5, p6) -- line: 31
		-- upvalues: dumpNavigationHierarchy (copy), s1 (copy), u7 (ref)
		local v14 = dumpNavigationHierarchy(p5)

		print(string.format("[%s] action: %s\n%s", s1, tostring(p6.type), if v14 ~= u7 then v14 else ""))
		u7 = v14
	end
end
