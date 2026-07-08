local Parent = script:FindFirstAncestor("SocialCommon").Parent
local React = require(Parent.React)
local UIBlox = require(Parent.UIBlox)
local RoactUtils = require(Parent.RoactUtils)
local useStyle = UIBlox.Core.Style.useStyle
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector

return function() -- line: 16
	-- upvalues: useStyle (copy), useSelector (copy), React (copy)
	local v7 = useStyle()
	local v8 = useSelector(function(p1) -- line: 18
		if p1.GlobalGuiInset then
			return p1.GlobalGuiInset.bottom
		end

		return 0
	end)

	return React.createElement("Frame", {
		BorderSizePixel = 0,
		ZIndex = 3,
		BackgroundColor3 = v7.Theme.BackgroundDefault.Color,
		BackgroundTransparency = v7.Theme.BackgroundDefault.Transparency,
		Position = UDim2.new(0, 0, 1, 0),
		Size = UDim2.new(1, 0, 0, v8)
	})
end
