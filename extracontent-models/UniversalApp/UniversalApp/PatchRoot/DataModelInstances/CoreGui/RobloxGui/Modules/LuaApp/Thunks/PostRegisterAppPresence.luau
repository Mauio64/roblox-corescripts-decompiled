local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local PostRegisterAppPresence = require(Modules.LuaApp.Http.Requests.PostRegisterAppPresence)
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch

local function postKeymapper() -- line: 6
	return "luaapp.presenceapi.register-app-presence"
end

return function(p1, p2) -- line: 10
	-- upvalues: PerformFetch (copy), PostRegisterAppPresence (copy)
	assert(type(p2) == "string", string.format("PostRegisterAppPresence thunk expects locationId to be a string, was %s", (type(p2))))

	return PerformFetch.Single("luaapp.presenceapi.register-app-presence", function(_) -- line: 16
		-- upvalues: PostRegisterAppPresence (copy), p1 (copy), p2 (copy)
		return PostRegisterAppPresence(p1, p2)
	end)
end
