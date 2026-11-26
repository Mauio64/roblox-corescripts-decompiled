local module = require("@luauforge/deferred/enn")

local module2 = require("@luauforge/deferred/eno")
local module3 = require("@luauforge/deferred/eom")

require("@luauforge/bundled/enl")

local function FriendsActivityFeedScreen(props)
	local v5 = module3({
		source = props.source,
		emptyStateDescription = props.emptyStateDescription or "When your friends update their avatars, play experiences, or earn badges, their activity will show up here.",
		isScrollEnabled = props.isScrollEnabled,
		layoutOrder = props.layoutOrder,
		onAvatarActivated = props.onAvatarActivated
	})

	return module.createElement(module2, v5)
end

return FriendsActivityFeedScreen
