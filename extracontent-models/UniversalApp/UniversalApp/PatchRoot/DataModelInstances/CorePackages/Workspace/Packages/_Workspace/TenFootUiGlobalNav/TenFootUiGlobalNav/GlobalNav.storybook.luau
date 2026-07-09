local TenFootUiGlobalNav = script:FindFirstAncestor("TenFootUiGlobalNav")
local TenFootUiGlobalNavParent = TenFootUiGlobalNav.Parent
local RoactCompat = require(TenFootUiGlobalNavParent.Dev.RoactCompat)
local React = require(TenFootUiGlobalNavParent.React)
local RobloxAppUIBloxConfig = require(TenFootUiGlobalNavParent.Dev.RobloxAppUIBloxConfig)
local UIBlox = require(TenFootUiGlobalNavParent.UIBlox)

UIBlox.init(RobloxAppUIBloxConfig)

local AppStyleProvider = UIBlox.App.Style.AppStyleProvider

RoactCompat.setGlobalConfig({
	elementTracing = true
})

local t1 = {
	themeName = "Light",
	fontName = "Gotham"
}
local t2 = {
	themeName = "Dark",
	fontName = "Gotham"
}
local t3 = {
	Default = t2,
	Light = t1,
	Dark = t2
}

return {
	name = "TenFootUIGlobalNav",
	storyRoots = { TenFootUiGlobalNav },
	roact = RoactCompat,
	mapStory = function(p1) -- line: 37
		-- upvalues: React (copy), AppStyleProvider (copy), t3 (copy)
		return function(p2) -- line: 38
			-- upvalues: React (copy), AppStyleProvider (copy), t3 (copy), p1 (copy)
			return React.createElement(AppStyleProvider, {
				style = p2 and t3[p2.theme] or t3.Default
			}, {
				Child = React.createElement(p1, p2)
			})
		end
	end
}
