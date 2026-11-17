local parent = script:FindFirstAncestor("AppChat").Parent

local React = require(parent.React)

local enum = {
	Unknown = "Unknown",
	ConnectTab = "ConnectTab",
	ChatTab = "ChatTab",
	InExperienceDefault = "InExperienceDefault",
	InExperienceFriendsTab = "InExperienceFriendsTab"
}

local context = React.createContext({ chatPlacement = enum.Unknown })

local provider = context.Provider
local consumer = context.Consumer
local ChatPlacementContext = {}
ChatPlacementContext.Provider = provider
ChatPlacementContext.Consumer = consumer
ChatPlacementContext.Context = context
ChatPlacementContext.Enum = enum

function ChatPlacementContext.useChatPlacementContext()
	return React.useContext(context)
end

function ChatPlacementContext.withChatPlacementContext(callback)
	return React.createElement(consumer, {
		render = function(p)
			return callback(p)
		end
	})
end

function ChatPlacementContext.isPlacementInExperience(p): boolean
	return p == enum.InExperienceFriendsTab or p == enum.InExperienceDefault
end

return ChatPlacementContext
