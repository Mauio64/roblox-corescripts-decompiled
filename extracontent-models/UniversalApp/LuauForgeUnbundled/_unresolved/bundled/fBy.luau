local module = require("@luauforge/bundled/dFu")
local module2 = require("@luauforge/bundled/ehB")

return function()
	return module2({
		name = module.AddFriendsPage,
		extraProps = { titleKey = "Feature.Friends.Feature.Friends.Heading.AddFriends" }
	})
end
