local AvatarExperience = script:FindFirstAncestor("AvatarExperience")
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local ReactRoblox = require(CorePackages.Packages.ReactRoblox)
local Foundation = require(CorePackages.Packages.Foundation)
local FoundationProvider = Foundation.FoundationProvider
local Theme = Foundation.Enums.Theme
local Device = Foundation.Enums.Device
local t1 = {
	Light = Theme.Light,
	Dark = Theme.Dark
}
local t2 = {
	Console = Device.Console,
	Desktop = Device.Desktop
}

return {
	name = AvatarExperience.Name,
	roact = React,
	reactRoblox = ReactRoblox,
	storyRoots = { AvatarExperience },
	mapStory = function(p1) -- line: 22
		-- upvalues: t1 (copy), React (copy), FoundationProvider (copy), t2 (copy)
		return function(p2) -- line: 23
			-- upvalues: t1 (copy), React (copy), FoundationProvider (copy), t2 (copy), p1 (copy)
			local v13 = t1[p2.theme]

			return React.createElement("Frame", {
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.fromScale(1, 0)
			}, {
				UIPadding = React.createElement("UIPadding", {
					PaddingTop = UDim.new(0, 10),
					PaddingBottom = UDim.new(0, 10),
					PaddingLeft = UDim.new(0, 10),
					PaddingRight = UDim.new(0, 10)
				}),
				FoundationContext = React.createElement(FoundationProvider, {
					theme = v13,
					device = t2[p2.platform],
					preferences = p2.settings
				}, {
					Child = React.createElement(p1, p2)
				})
			})
		end
	end
}
