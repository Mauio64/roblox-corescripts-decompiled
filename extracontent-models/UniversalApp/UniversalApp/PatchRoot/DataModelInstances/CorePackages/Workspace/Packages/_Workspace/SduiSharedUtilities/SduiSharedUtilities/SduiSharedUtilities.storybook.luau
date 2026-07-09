local Parent = script:FindFirstAncestor("SduiSharedUtilities").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local FoundationProvider = Foundation.FoundationProvider
local Theme = Foundation.Enums.Theme
local Device = Foundation.Enums.Device
local ReactRoblox = require(Parent.ReactRoblox)
local t1 = {
	Light = Theme.Light,
	Dark = Theme.Dark
}

return {
	name = "SduiSharedUtilities",
	roact = React,
	reactRoblox = ReactRoblox,
	mapStory = function(p1) -- line: 15
		-- upvalues: React (copy), FoundationProvider (copy), t1 (copy), Device (copy)
		return function(p2) -- line: 16
			-- upvalues: React (copy), FoundationProvider (copy), t1 (copy), Device (copy), p1 (copy)
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
					theme = t1[p2.theme],
					device = Device[p2.platform],
					preferences = p2.settings,
					scale = p2.settings and p2.settings.scale
				}, {
					Child = React.createElement(p1, p2)
				})
			})
		end
	end
}
