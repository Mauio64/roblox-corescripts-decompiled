local Parent = script:FindFirstAncestor("ProfileQRCode").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local EnumsRadius = Foundation.Enums.Radius
local Skeleton = Foundation.Skeleton

return function() -- line: 10
	-- upvalues: React (copy), Skeleton (copy), EnumsRadius (copy)
	return React.createElement(Skeleton, {
		Size = UDim2.new(1, 0, 1, 0),
		radius = EnumsRadius.None
	})
end
