local ParentParent = script.Parent.Parent
local Cryo = require(ParentParent.Cryo)
local React = require(ParentParent.React)

return function(t1: {[any]: any}) -- line: 13
	-- upvalues: React (copy), Cryo (copy)
	return React.createElement("Frame", {
		BackgroundColor3 = t1.backgroundColor,
		BackgroundTransparency = t1.backgroundTransparency,
		Size = UDim2.new(1, 0, 1, 0)
	}, Cryo.Dictionary.join({
		Padding = React.createElement("UIPadding", {
			PaddingRight = UDim.new(0, t1.cornerRadius),
			PaddingLeft = UDim.new(0, t1.cornerRadius),
			PaddingTop = UDim.new(0, t1.cornerRadius),
			PaddingBottom = UDim.new(0, t1.cornerRadius)
		}),
		Corner = React.createElement("UICorner", {
			CornerRadius = UDim.new(0, t1.cornerRadius)
		})
	}, t1.children))
end
