local SocialTab = script:FindFirstAncestor("SocialTab")
local dependencies = require(SocialTab.dependencies)
local Roact = dependencies.Roact
local styleWrapper = require(script.Parent.temp.styleWrapper)
local mockLocale = require(script.Parent.temp.mockLocale)
local Logger = require(SocialTab.Logger)
local v7 = dependencies.Lumberyak.Logger.new()

v7:addSink({
	maxLevel = v7.Levels.fromString("info"),
	log = function(_, p2, _) -- line: 20
		print(p2)
	end
})
Logger:setParent(v7)

return {
	storyRoots = { SocialTab.UserCarousel.Components },
	roact = Roact,
	mapStory = function(p4) -- line: 30
		-- upvalues: mockLocale (copy), styleWrapper (copy)
		return function(p5) -- line: 31
			-- upvalues: mockLocale (copy), styleWrapper (copy), p4 (copy)
			return mockLocale(styleWrapper(p4, p5))
		end
	end
}
