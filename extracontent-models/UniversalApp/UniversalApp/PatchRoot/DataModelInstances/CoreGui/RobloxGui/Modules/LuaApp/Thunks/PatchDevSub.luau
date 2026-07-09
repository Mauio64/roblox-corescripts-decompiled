local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local DevSubsPatchDevSub = require(Modules.LuaApp.Http.Requests.DevSubsPatchDevSub)
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch

return {
	Patch = function(p1, p2, p3) -- line: 11
		-- upvalues: PerformFetch (copy), DevSubsPatchDevSub (copy)
		return PerformFetch.Single("luaapp.devsubs.cancelsubscription", function(_) -- line: 12
			-- upvalues: DevSubsPatchDevSub (copy), p1 (copy), p2 (copy), p3 (copy)
			return DevSubsPatchDevSub(p1, p2, p3)
		end)
	end,
	GetPatchingStatus = function(p5) -- line: 17
		-- upvalues: PerformFetch (copy)
		return PerformFetch.GetStatus(p5, "luaapp.devsubs.cancelsubscription")
	end
}
