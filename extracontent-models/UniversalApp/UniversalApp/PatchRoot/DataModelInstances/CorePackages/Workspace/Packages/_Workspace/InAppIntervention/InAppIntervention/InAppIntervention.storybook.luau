local InAppIntervention = script:FindFirstAncestor("InAppIntervention")
local InAppInterventionParent = InAppIntervention.Parent
local Cryo = require(InAppInterventionParent.Cryo)
local React = require(InAppInterventionParent.React)
local ReactRoblox = require(InAppInterventionParent.Dev.ReactRoblox)
local UIBlox = require(InAppInterventionParent.UIBlox)
local RobloxAppUIBloxConfig = require(InAppInterventionParent.Dev.RobloxAppUIBloxConfig)

UIBlox.init(RobloxAppUIBloxConfig)

local MockProviders = require(script.Parent.MockProviders)
local Dictionary = Cryo.Dictionary
local Logger = require(InAppIntervention.Logger)

Logger:addSink({
	maxLevel = Logger.Levels.fromString("trace"),
	log = function(_, p2, p3) -- line: 19
		print(`[{ p3.loggerName }] { p2 }`)
	end
})

return {
	roact = React,
	reactRoblox = ReactRoblox,
	mapStory = function(p4) -- line: 27
		-- upvalues: Dictionary (copy), React (copy), MockProviders (copy)
		return function(p5) -- line: 28
			-- upvalues: Dictionary (copy), React (copy), MockProviders (copy), p4 (copy)
			local v16 = Dictionary.union(p5, p5.definition and p5.definition.props or {})

			return React.createElement(MockProviders, {}, {
				story = React.createElement(p4, v16)
			})
		end
	end,
	storyRoots = { InAppIntervention }
}
