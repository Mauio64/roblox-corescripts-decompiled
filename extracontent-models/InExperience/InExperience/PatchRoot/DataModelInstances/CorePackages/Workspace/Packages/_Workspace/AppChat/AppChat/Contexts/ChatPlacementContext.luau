local parent = script:FindFirstAncestor("AppChat").Parent

local React = require(parent.React)
local SharedFlags = require(parent.SharedFlags)
local FFlagExpChatEnableFriendsTab = SharedFlags.FFlagExpChatEnableFriendsTab

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
	if FFlagExpChatEnableFriendsTab and p == enum.InExperienceFriendsTab then
		return true
	end

	return p == enum.InExperienceDefault
end

return ChatPlacementContext
