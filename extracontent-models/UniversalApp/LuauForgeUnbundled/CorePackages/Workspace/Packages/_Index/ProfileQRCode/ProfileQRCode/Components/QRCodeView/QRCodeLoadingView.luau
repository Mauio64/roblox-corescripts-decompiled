local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileQRCode/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileQRCode/Foundation")
local radius = Foundation.Enums.Radius
local skeleton = Foundation.Skeleton

return function()
	return React.createElement(skeleton, {
		Size = UDim2.new(1, 0, 1, 0),
		radius = radius.None
	})
end
