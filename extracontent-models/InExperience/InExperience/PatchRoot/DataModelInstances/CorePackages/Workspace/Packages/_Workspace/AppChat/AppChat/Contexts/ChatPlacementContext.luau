local Parent = script:FindFirstAncestor("AppChat").Parent
local React = require(Parent.React)
local t1 = {
	Unknown = "Unknown",
	ConnectTab = "ConnectTab",
	ChatTab = "ChatTab",
	InExperienceDefault = "InExperienceDefault"
}
local v4 = React.createContext({
	chatPlacement = t1.Unknown
})
local Provider = v4.Provider
local Consumer = v4.Consumer

return {
	Provider = Provider,
	Consumer = Consumer,
	Context = v4,
	Enum = t1,
	useChatPlacementContext = function() -- line: 38
		-- upvalues: React (copy), v4 (copy)
		return React.useContext(v4)
	end,
	withChatPlacementContext = function(p1: ((...any) -> ...any)) -- line: 41
		-- upvalues: React (copy), Consumer (copy)
		return React.createElement(Consumer, {
			render = function(p2) -- line: 43
				-- upvalues: p1 (copy)
				return p1(p2)
			end
		})
	end,
	isPlacementInExperience = function(p3) -- line: 48
		-- upvalues: t1 (copy)
		return p3 == t1.InExperienceDefault
	end
}
