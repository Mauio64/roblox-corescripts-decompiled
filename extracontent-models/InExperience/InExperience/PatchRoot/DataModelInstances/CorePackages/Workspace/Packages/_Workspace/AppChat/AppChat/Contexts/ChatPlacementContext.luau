local Parent = script:FindFirstAncestor("AppChat").Parent
local React = require(Parent.React)
local FFlagExpChatEnableFriendsTab = require(Parent.SharedFlags).FFlagExpChatEnableFriendsTab
local t1 = {
	Unknown = "Unknown",
	ConnectTab = "ConnectTab",
	ChatTab = "ChatTab",
	InExperienceDefault = "InExperienceDefault",
	InExperienceFriendsTab = "InExperienceFriendsTab"
}
local v5 = React.createContext({
	chatPlacement = t1.Unknown
})
local Provider = v5.Provider
local Consumer = v5.Consumer

return {
	Provider = Provider,
	Consumer = Consumer,
	Context = v5,
	Enum = t1,
	useChatPlacementContext = function() -- line: 42
		-- upvalues: React (copy), v5 (copy)
		return React.useContext(v5)
	end,
	withChatPlacementContext = function(p1: ((...any) -> ...any)) -- line: 45
		-- upvalues: React (copy), Consumer (copy)
		return React.createElement(Consumer, {
			render = function(p2) -- line: 47
				-- upvalues: p1 (copy)
				return p1(p2)
			end
		})
	end,
	isPlacementInExperience = function(p3) -- line: 52
		-- upvalues: FFlagExpChatEnableFriendsTab (copy), t1 (copy)
		if FFlagExpChatEnableFriendsTab and p3 == t1.InExperienceFriendsTab then
			return true
		end

		return p3 == t1.InExperienceDefault
	end
}
