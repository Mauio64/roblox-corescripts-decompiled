local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local parent = GenericAbuseReporting.Parent
local Cryo = require(parent.Cryo)
local Foundation = require(parent.Foundation)
local React = require(parent.React)
local ReactRoblox = require(parent.Dev.ReactRoblox)

local FoundationProvider = Foundation.FoundationProvider

local MockProviders = require(script.Parent.MockProviders)

local Dictionary = Cryo.Dictionary

local Logger = require(GenericAbuseReporting.Logger)
Logger:addSink({
	maxLevel = Logger.Levels.fromString("trace"),
	log = function(_, p, p2)
		print(`[{p2.loggerName}] {p}`)
	end
})

return {
	roact = React,
	reactRoblox = ReactRoblox,
	mapStory = function(p)
		return function(props)
			local union = Dictionary.union(props, props.definition and props.definition.props or {})
			return React.createElement(MockProviders, {}, {
				FoundationProvider = React.createElement(
					FoundationProvider,
					{ colorMode = "Dark", preferences = props.settings, overlayGui = props.focus },
					{ story = React.createElement(p, union) }
				)
			})
		end
	end,
	storyRoots = { GenericAbuseReporting }
}
