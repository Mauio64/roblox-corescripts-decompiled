local ChatLineReporting = script:FindFirstAncestor("ChatLineReporting")
local parent = ChatLineReporting.Parent
local Cryo = require(parent.Cryo)
local React = require(parent.React)
local ReactRoblox = require(parent.Dev.ReactRoblox)

local MockProviders = require(script.Parent.MockProviders)

local Dictionary = Cryo.Dictionary

return {
	roact = React,
	reactRoblox = ReactRoblox,
	mapStory = function(p)
		return function(p2)
			local union = Dictionary.union(p2, p2.definition and p2.definition.props or {})
			return React.createElement(MockProviders, {}, { story = React.createElement(p, union) })
		end
	end,
	storyRoots = { ChatLineReporting }
}
