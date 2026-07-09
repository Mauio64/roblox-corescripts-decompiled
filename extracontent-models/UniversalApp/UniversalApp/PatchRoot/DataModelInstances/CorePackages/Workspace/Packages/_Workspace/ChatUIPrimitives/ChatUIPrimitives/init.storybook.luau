local ChatUIPrimitives = script:FindFirstAncestor("ChatUIPrimitives")
local ChatUIPrimitivesParent = ChatUIPrimitives.Parent
local React = require(ChatUIPrimitivesParent.React)
local ReactRoblox = require(ChatUIPrimitivesParent.Dev.ReactRoblox)
local FoundationProvider = require(ChatUIPrimitivesParent.Foundation).FoundationProvider

return {
	name = ChatUIPrimitives.Name,
	roact = React,
	reactRoblox = ReactRoblox,
	storyRoots = { ChatUIPrimitives },
	mapStory = function(p1) -- line: 17
		-- upvalues: React (copy), FoundationProvider (copy)
		return function(p2) -- line: 18
			-- upvalues: React (copy), FoundationProvider (copy), p1 (copy)
			return React.createElement(FoundationProvider, {
				theme = p2 and p2.theme,
				device = p2 and p2.platform
			}, React.createElement(p1, p2))
		end
	end
}
