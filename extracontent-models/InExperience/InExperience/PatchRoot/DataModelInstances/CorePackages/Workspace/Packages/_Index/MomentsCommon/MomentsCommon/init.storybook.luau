local MomentsCommon = script:FindFirstAncestor("MomentsCommon")
local MomentsCommonParent = MomentsCommon.Parent
local Foundation = require(MomentsCommonParent.Foundation)
local React = require(MomentsCommonParent.React)
local ReactRoblox = require(MomentsCommonParent.Dev.ReactRoblox)
local t1 = {
	Default = Foundation.Enums.Theme.Dark,
	Light = Foundation.Enums.Theme.Light,
	Dark = Foundation.Enums.Theme.Dark
}

return {
	name = MomentsCommon.Name,
	roact = React,
	reactRoblox = ReactRoblox,
	storyRoot = MomentsCommon,
	mapStory = function(p1) -- line: 19
		-- upvalues: t1 (copy), React (copy), Foundation (copy)
		return function(p2) -- line: 20
			-- upvalues: t1 (copy), React (copy), Foundation (copy), p1 (copy)
			local v9 = p2 and t1[p2.theme] or t1.Default

			return React.createElement(Foundation.FoundationProvider, {
				theme = v9
			}, {
				Child = React.createElement(p1, p2)
			})
		end
	end
}
