local module = require("@luauforge/deferred/ejR")

local module2 = require("@luauforge/deferred/ejS")
local module3 = require("@luauforge/deferred/ekQ")

require("@luauforge/bundled/ejP")

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
