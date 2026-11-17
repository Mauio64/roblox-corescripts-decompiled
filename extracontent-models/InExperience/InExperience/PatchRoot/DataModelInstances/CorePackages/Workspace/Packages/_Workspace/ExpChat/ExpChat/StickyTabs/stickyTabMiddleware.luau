local ExpChat = script:FindFirstAncestor("ExpChat")

local FriendsChatChannelAdded = require(ExpChat.Actions.FriendsChatChannelAdded)
local LocalTextChannelParticipantAdded = require(ExpChat.Actions.LocalTextChannelParticipantAdded)
local UniverseChatChannelAdded = require(ExpChat.Actions.UniverseChatChannelAdded)
local StickyTabObserver = require(script.Parent.StickyTabObserver)
require(script.Parent.StickyTabsStore)

local v = {
	[LocalTextChannelParticipantAdded.name] = function(p)
		return p.textChannel.Name
	end,
	[UniverseChatChannelAdded.name] = function(p)
		return p.channelName
	end,
	[FriendsChatChannelAdded.name] = function(p)
		return p.channelName
	end
}

local function stickyTabMiddleware(callback, object)
	return function(p)
		local v2 = callback(p)
		local kind

		if type(p) == "table" then
			kind = p.type
		end

		local v3

		if type(kind) == "string" then
			v3 = v[kind]
		end

		if not v3 then
			return v2
		end

		local v4 = v3(p)

		local channelTabs = object:getState().ChannelTabs

		if channelTabs and channelTabs.allChannelTabs[v4] then
			StickyTabObserver:goToStickyTab(v4)
		end

		return v2
	end
end

return stickyTabMiddleware
