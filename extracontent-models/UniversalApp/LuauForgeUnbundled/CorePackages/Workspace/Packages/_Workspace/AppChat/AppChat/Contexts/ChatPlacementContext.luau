local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")

local v5 = {
	Unknown = "Unknown",
	ConnectTab = "ConnectTab",
	ChatTab = "ChatTab",
	InExperienceDefault = "InExperienceDefault",
	InExperienceFriendsTab = "InExperienceFriendsTab"
}

local context = React.createContext({ chatPlacement = v5.Unknown })

local provider = context.Provider
local consumer = context.Consumer

return {
	Provider = provider,
	Consumer = consumer,
	Context = context,
	Enum = v5,
	useChatPlacementContext = function()
		return React.useContext(context)
	end,
	withChatPlacementContext = function(callback)
		return React.createElement(consumer, {
			render = function(p2)
				return callback(p2)
			end
		})
	end,
	isPlacementInExperience = function(p2): boolean
		if p2 == v5.InExperienceFriendsTab then
			return true
		end

		return p2 == v5.InExperienceDefault
	end
}
