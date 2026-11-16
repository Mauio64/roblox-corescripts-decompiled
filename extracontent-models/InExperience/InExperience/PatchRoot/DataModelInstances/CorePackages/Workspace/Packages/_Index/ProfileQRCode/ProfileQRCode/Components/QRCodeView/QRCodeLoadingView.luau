local parent = script:FindFirstAncestor("ProfileQRCode").Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Radius = Foundation.Enums.Radius
local Skeleton = Foundation.Skeleton

return function()
	return React.createElement(Skeleton, { Size = UDim2.new(1, 0, 1, 0), radius = Radius.None })
end
