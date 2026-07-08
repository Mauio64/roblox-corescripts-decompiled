local ParentParent = script.Parent.Parent.Parent.Parent
local Roact = require(ParentParent.Roact)
local Foundation = require(ParentParent.Foundation)
local Loading = Foundation.Loading
local IconSize = Foundation.Enums.IconSize
local v6 = Roact.PureComponent:extend("LoadingStatePage")

function v6.render(_) -- line: 13
	-- upvalues: Roact (copy), Loading (copy), IconSize (copy)
	return Roact.createElement(Loading, {
		size = IconSize.Medium,
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5)
	})
end

return v6
