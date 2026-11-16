local CorePackages = game:GetService("CorePackages")
local Packages = CorePackages.Packages
local React = require(Packages.React)

local UIBlox = require(Packages.UIBlox)
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel

local useCameraOn = require(script.Parent.Parent.Hooks.useCameraOn)

local udim = UDim2.fromScale(1, 1)

local function CameraStatusIcon(p)
	local v = useCameraOn()

	return React.createElement("Frame", { BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1) }, {
		Icon = React.createElement(ImageSetLabel, {
			BackgroundTransparency = 1,
			Image = v and Images["icons/controls/video"] or Images["icons/controls/videoOff"],
			Size = p.iconSize or udim,
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5),
			ImageTransparency = p.transparency or 0
		})
	})
end

return CameraStatusIcon
