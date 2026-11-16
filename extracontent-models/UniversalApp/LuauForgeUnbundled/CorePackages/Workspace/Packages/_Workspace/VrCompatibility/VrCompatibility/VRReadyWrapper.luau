local React = require("@game/CorePackages/Workspace/Packages/_Workspace/VrCompatibility/React")
local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/VrCompatibility/Roact")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/VrCompatibility/UIBlox")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/VrCompatibility/SharedFlags")
local panel3D = UIBlox.Core.VR.Panel3D
local useIsFPSAtTarget = require("@game/CorePackages/Workspace/Packages/_Workspace/VrCompatibility/SplashScreenManager").useIsFPSAtTarget

local RoundedCornersFrame = require("@game/CorePackages/Workspace/Packages/_Workspace/VrCompatibility/VrCompatibility/RoundedCornersFrame")
local object = require("@game/CorePackages/Workspace/Packages/_Workspace/VrCompatibility/LuauPolyfill").Object
local useIsSpatial = require("@game/CorePackages/Workspace/Packages/_Workspace/VrCompatibility/Responsive").useIsSpatial
local getFFlagEnableVRWrapperTransparency = SharedFlags.GetFFlagEnableVRWrapperTransparency

local ROUNDED_CORNER_RADIUS = require("@game/CorePackages/Workspace/Packages/_Workspace/VrCompatibility/VrCompatibility/Constants").ROUNDED_CORNER_RADIUS

return function(props)
	local v5 = useIsFPSAtTarget()
	local v6 = object.assign({}, props.vrProps, {
		hidden = props.vrProps.hidden or not v5
	})

	if not useIsSpatial() then
		return React.createElement(props.component, props.props, props[Roact.Children])
	end

	local v7 = if v6.roundedCornersFrameColor then {
		RoundedFrame = Roact.createElement(RoundedCornersFrame, {
			cornerRadius = ROUNDED_CORNER_RADIUS / (384 / (v6.virtualScreenSize.X / v6.partSize.X)),
			backgroundColor = v6.roundedCornersFrameColor,
			backgroundTransparency = getFFlagEnableVRWrapperTransparency() and v6.backgroundTransparency or 0
		}, props[Roact.Children])
	} else props[Roact.Children]

	return React.createElement(panel3D, v6, v7)
end
