local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local t = require(CorePackages.Packages.t)
local Modules = CoreGui.RobloxGui.Modules
local AppPage = require(Modules.LuaApp.AppPage)
local NavigateDown = require(Modules.LuaApp.Thunks.NavigateDown)

return function(p1, p2) -- line: 11
	-- upvalues: t (copy), NavigateDown (copy), AppPage (copy)
	assert(t.string(p1))
	assert(t.callback(p2) or t.none(p2))

	return NavigateDown({
		name = AppPage.SdkShare,
		extraProps = {
			context = "AddFriendsTile",
			userId = p1,
			onClose = p2
		}
	})
end
