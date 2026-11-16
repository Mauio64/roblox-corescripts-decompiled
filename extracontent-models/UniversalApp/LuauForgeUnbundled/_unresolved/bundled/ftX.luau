local module = require("@luauforge/bundled/dCp")
local module2 = require("@luauforge/bundled/eee")

return function()
	return module2({
		name = module.AddFriendsPage,
		extraProps = { titleKey = "Feature.Friends.Feature.Friends.Heading.AddFriends" }
	})
end
