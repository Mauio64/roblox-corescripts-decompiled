local Packages = game:GetService("CorePackages").Packages
local React = require(Packages.React)
local UIBlox = require(Packages.UIBlox)
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local useCameraOn = require(script.Parent.Parent.Hooks.useCameraOn)
local uDim2 = UDim2.fromScale(1, 1)

local function CameraStatusIcon(t1: {[any]: any}) -- line: 18
	-- upvalues: useCameraOn (copy), React (copy), ImageSetLabel (copy), Images (copy), uDim2 (copy)
	local v10 = useCameraOn()

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1)
	}, {
		Icon = React.createElement(ImageSetLabel, {
			BackgroundTransparency = 1,
			Image = v10 and Images["icons/controls/video"] or Images["icons/controls/videoOff"],
			Size = t1.iconSize or uDim2,
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5),
			ImageTransparency = t1.transparency or 0
		})
	})
end

return CameraStatusIcon
