local SocialTab = script:FindFirstAncestor("SocialTab")
local SocialTabParent = SocialTab.Parent

require(SocialTabParent.UIBlox).init(require(SocialTabParent.Dev.RobloxAppUIBloxConfig))

local dependencies = require(SocialTab.dependencies)
local Roact = dependencies.Roact
local mockLocale = require(script.Parent.temp.mockLocale)
local styleWrapper = require(script.Parent.temp.styleWrapper)
local Logger = require(SocialTab.Logger)
local v8 = dependencies.Lumberyak.Logger.new()

v8:addSink({
	maxLevel = v8.Levels.fromString("info"),
	log = function(_, p2, _) -- line: 26
		print(p2)
	end
})
Logger:setParent(v8)

return {
	storyRoots = { SocialTab.Components },
	roact = Roact,
	mapStory = function(p4) -- line: 36
		-- upvalues: mockLocale (copy), styleWrapper (copy)
		return function(p5) -- line: 37
			-- upvalues: mockLocale (copy), styleWrapper (copy), p4 (copy)
			return mockLocale(styleWrapper(p4, p5))
		end
	end
}
