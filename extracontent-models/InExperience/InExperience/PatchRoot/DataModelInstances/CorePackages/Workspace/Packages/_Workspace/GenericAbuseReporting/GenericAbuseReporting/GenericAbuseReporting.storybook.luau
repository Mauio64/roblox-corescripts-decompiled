local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local GenericAbuseReportingParent = GenericAbuseReporting.Parent
local Cryo = require(GenericAbuseReportingParent.Cryo)
local Foundation = require(GenericAbuseReportingParent.Foundation)
local React = require(GenericAbuseReportingParent.React)
local ReactRoblox = require(GenericAbuseReportingParent.Dev.ReactRoblox)
local FoundationProvider = Foundation.FoundationProvider
local MockProviders = require(script.Parent.MockProviders)
local Dictionary = Cryo.Dictionary
local Logger = require(GenericAbuseReporting.Logger)

Logger:addSink({
	maxLevel = Logger.Levels.fromString("trace"),
	log = function(_, p2, p3) -- line: 17
		print(`[{ p3.loggerName }] { p2 }`)
	end
})

return {
	roact = React,
	reactRoblox = ReactRoblox,
	mapStory = function(p4) -- line: 25
		-- upvalues: Dictionary (copy), React (copy), MockProviders (copy), FoundationProvider (copy)
		return function(p5) -- line: 26
			-- upvalues: Dictionary (copy), React (copy), MockProviders (copy), FoundationProvider (copy), p4 (copy)
			local v16 = Dictionary.union(p5, p5.definition and p5.definition.props or {})

			return React.createElement(MockProviders, {}, {
				FoundationProvider = React.createElement(FoundationProvider, {
					theme = "Dark",
					preferences = p5.settings,
					overlayGui = p5.focus
				}, {
					story = React.createElement(p4, v16)
				})
			})
		end
	end,
	storyRoots = { GenericAbuseReporting }
}
