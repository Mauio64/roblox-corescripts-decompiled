local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local Logger = require(AppChat.Logger)
local UIBlox = require(AppChatParent.UIBlox)
local RobloxAppUIBloxConfig = require(AppChatParent.Dev.RobloxAppUIBloxConfig)

UIBlox.init(RobloxAppUIBloxConfig)

local Roact = require(AppChatParent.Roact)
local Cryo = require(AppChatParent.Cryo)
local MockProviders = require(AppChat.Components.MockProviders)
local t1 = {
	Default = {
		themeName = "Light",
		fontName = "Gotham"
	},
	Light = {
		themeName = "Light",
		fontName = "Gotham"
	},
	Dark = {
		themeName = "Dark",
		fontName = "Gotham"
	}
}
local Logger2 = require(AppChatParent.Loggers).Logger

Logger2:addSink({
	maxLevel = Logger2.Levels.fromString("trace"),
	log = function(_, p2, _) -- line: 38
		print(p2)
	end
})
Logger:setParent(Logger2)

return {
	roact = Roact,
	mapStory = function(p4) -- line: 47
		-- upvalues: t1 (copy), Roact (copy), MockProviders (copy), Cryo (copy)
		return function(p5) -- line: 48
			-- upvalues: t1 (copy), Roact (copy), MockProviders (copy), p4 (copy), Cryo (copy)
			local v16 = p5 and (not not p5.definition and p5.definition.props) or {}
			local v17 = p5 and t1[p5.theme] or t1.Default

			return Roact.createElement(MockProviders, {
				rodux = v16.rodux,
				themeName = v17.themeName
			}, {
				story = Roact.createElement(p4, Cryo.Dictionary.union(v16, p5))
			})
		end
	end
}
