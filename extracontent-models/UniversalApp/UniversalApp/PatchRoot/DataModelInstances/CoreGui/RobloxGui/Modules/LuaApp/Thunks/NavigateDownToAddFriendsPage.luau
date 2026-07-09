local Modules = game:GetService("CoreGui").RobloxGui.Modules
local AppPage = require(Modules.LuaApp.AppPage)
local NavigateDown = require(Modules.LuaApp.Thunks.NavigateDown)

return function() -- line: 8
	-- upvalues: NavigateDown (copy), AppPage (copy)
	return NavigateDown({
		name = AppPage.AddFriendsPage,
		extraProps = {
			titleKey = "Feature.Friends.Feature.Friends.Heading.AddFriends"
		}
	})
end
