local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent
local Logger = require(AppChat.Logger)
local UIBlox = require(parent.UIBlox)
local RobloxAppUIBloxConfig = require(parent.Dev.RobloxAppUIBloxConfig)

UIBlox.init(RobloxAppUIBloxConfig)

local Roact = require(parent.Roact)
local Cryo = require(parent.Cryo)

local MockProviders = require(AppChat.Components.MockProviders)

local v = {
	Default = { themeName = "Light", fontName = "Gotham" },
	Light = { themeName = "Light", fontName = "Gotham" },
	Dark = { themeName = "Dark", fontName = "Gotham" }
}

local Loggers = require(parent.Loggers)
local logger = Loggers.Logger
logger:addSink({
	maxLevel = logger.Levels.fromString("trace"),
	log = function(_, p, _)
		print(p)
	end
})

Logger:setParent(logger)

return {
	roact = Roact,
	mapStory = function(p)
		return function(p2)
			local props = p2 and p2.definition and p2.definition.props or {}
			local v2 = p2 and v[p2.theme] or v.Default

			return Roact.createElement(MockProviders, {
				rodux = props.rodux,
				themeName = v2.themeName
			}, {
				story = Roact.createElement(p, Cryo.Dictionary.union(props, p2))
			})
		end
	end
}
