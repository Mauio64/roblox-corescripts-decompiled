local SocialTab = script:FindFirstAncestor("SocialTab")
local Logger = require(SocialTab.Logger)
local StyleSwapper = require(SocialTab.Storybook.temp.StyleSwapper)
local v4 = require(SocialTab.devDependencies).Lumberyak.Logger.new()

v4:addSink({
	maxLevel = v4.Levels.fromString("info"),
	log = function(_, p2, _) -- line: 14
		if not _G.__TESTEZ_RUNNING_TEST__ then
			print(p2)
		end
	end
})
Logger:setParent(v4)

return {
	name = "UserCarousel",
	storyRoot = SocialTab.UserCarousel.Components,
	middleware = StyleSwapper()
}
