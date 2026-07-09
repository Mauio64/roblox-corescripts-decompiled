local Modules = game:GetService("CoreGui").RobloxGui.Modules
local AppPage = require(Modules.LuaApp.AppPage)
local NavigateDown = require(Modules.LuaApp.Thunks.NavigateDown)

return function(t1: {[any]: any}) -- line: 8
	-- upvalues: NavigateDown (copy), AppPage (copy)
	return NavigateDown({
		extraProps = {
			postId = t1.postId,
			userId = t1.userId
		},
		name = AppPage.ContentFeed
	})
end
