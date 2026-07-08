local ParentParent = script.Parent.Parent
local Foundation = require(ParentParent.Foundation)
local React = require(ParentParent.React)
local FoundationProvider = Foundation.FoundationProvider
local Theme = Foundation.Enums.Theme
local Device = Foundation.Enums.Device

local function StoryMiddleware(p1) -- line: 19
	-- upvalues: Theme (copy), React (copy), FoundationProvider (copy), Device (copy)
	return function(t1: {[any]: any}) -- line: 21
		-- upvalues: Theme (copy), React (copy), FoundationProvider (copy), Device (copy), p1 (copy)
		local v10 = Theme[t1.theme]

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
				theme = v10,
				device = Device[t1.platform],
				preferences = t1.settings
			}, {
				Child = React.createElement(p1, t1)
			})
		})
	end
end

return StoryMiddleware
