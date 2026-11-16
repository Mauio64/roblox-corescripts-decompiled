local Graphing = script:FindFirstAncestor("Graphing")
local parent = Graphing.Parent
local React = require(parent.React)
local ReactRoblox = require(parent.ReactRoblox)

return {
	name = "Graphing Examples",
	storyRoots = { Graphing.Stories },
	roact = React,
	reactRoblox = ReactRoblox
}
