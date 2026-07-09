local ChatLineReporting = script:FindFirstAncestor("ChatLineReporting")
local ChatLineReportingParent = ChatLineReporting.Parent
local Cryo = require(ChatLineReportingParent.Cryo)
local React = require(ChatLineReportingParent.React)
local ReactRoblox = require(ChatLineReportingParent.Dev.ReactRoblox)
local MockProviders = require(script.Parent.MockProviders)
local Dictionary = Cryo.Dictionary

return {
	roact = React,
	reactRoblox = ReactRoblox,
	mapStory = function(p1) -- line: 14
		-- upvalues: Dictionary (copy), React (copy), MockProviders (copy)
		return function(p2) -- line: 15
			-- upvalues: Dictionary (copy), React (copy), MockProviders (copy), p1 (copy)
			local v10 = Dictionary.union(p2, p2.definition and p2.definition.props or {})

			return React.createElement(MockProviders, {}, {
				story = React.createElement(p1, v10)
			})
		end
	end,
	storyRoots = { ChatLineReporting }
}
