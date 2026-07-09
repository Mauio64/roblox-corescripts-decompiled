local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local t = require(CorePackages.Packages.t)
local Modules = CoreGui.RobloxGui.Modules
local AppPage = require(Modules.LuaApp.AppPage)
local NavigateDown = require(Modules.LuaApp.Thunks.NavigateDown)

return function(p1) -- line: 11
	-- upvalues: t (copy), NavigateDown (copy), AppPage (copy)
	assert(t.callback(p1) or t.none(p1))

	return NavigateDown({
		name = AppPage.Chat,
		extraProps = {
			onClose = p1
		}
	})
end
