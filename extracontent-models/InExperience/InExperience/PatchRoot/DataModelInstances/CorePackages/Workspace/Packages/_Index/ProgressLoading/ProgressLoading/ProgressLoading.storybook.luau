local ProgressLoading = script:FindFirstAncestor("ProgressLoading")
local ProgressLoadingParent = ProgressLoading.Parent
local Foundation = require(ProgressLoadingParent.Foundation)
local React = require(ProgressLoadingParent.React)
local ReactRoblox = require(ProgressLoadingParent.ReactRoblox)
local FoundationProvider = Foundation.FoundationProvider
local t1 = {
	Default = Foundation.Enums.Theme.Dark,
	Light = Foundation.Enums.Theme.Light,
	Dark = Foundation.Enums.Theme.Dark
}
local t2 = {
	Default = "Desktop",
	Desktop = "Desktop",
	Console = "Console"
}

return {
	name = "ProgressLoading",
	storyRoot = ProgressLoading,
	roact = React,
	reactRoblox = ReactRoblox,
	mapStory = function(p1) -- line: 22
		-- upvalues: React (copy), FoundationProvider (copy), t1 (copy), t2 (copy)
		return function(p2) -- line: 23
			-- upvalues: React (copy), FoundationProvider (copy), t1 (copy), t2 (copy), p1 (copy)
			return React.createElement(FoundationProvider, {
				theme = p2 and t1[p2.theme] or t1.Default,
				device = p2 and t2[p2.platform] or t2.Default
			}, {
				Story = React.createElement(p1, p2)
			})
		end
	end
}
