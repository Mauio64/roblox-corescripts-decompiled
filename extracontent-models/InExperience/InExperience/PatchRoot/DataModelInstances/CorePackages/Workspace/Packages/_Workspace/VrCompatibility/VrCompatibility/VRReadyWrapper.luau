local parent = script.Parent.Parent

local React = require(parent.React)
local Roact = require(parent.Roact)
local UIBlox = require(parent.UIBlox)
local SharedFlags = require(parent.SharedFlags)
local Panel3D = UIBlox.Core.VR.Panel3D
local SplashScreenManager = require(parent.SplashScreenManager)
local useIsFPSAtTarget = SplashScreenManager.useIsFPSAtTarget

local RoundedCornersFrame = require(script.Parent.RoundedCornersFrame)
local LuauPolyfill = require(parent.LuauPolyfill)
local Object = LuauPolyfill.Object
local Responsive = require(parent.Responsive)
local useIsSpatial = Responsive.useIsSpatial
local GetFFlagEnableVRWrapperTransparency = SharedFlags.GetFFlagEnableVRWrapperTransparency

local Constants = require(script.Parent.Constants)
local ROUNDED_CORNER_RADIUS = Constants.ROUNDED_CORNER_RADIUS

return function(props)
	local v = useIsFPSAtTarget()
	local v2 = Object.assign({}, props.vrProps, {
		hidden = props.vrProps.hidden or not v
	})

	if not useIsSpatial() then
		return React.createElement(props.component, props.props, props[Roact.Children])
	end

	local v3

	if v2.roundedCornersFrameColor then
		v3 = {
			RoundedFrame = Roact.createElement(RoundedCornersFrame, {
				cornerRadius = ROUNDED_CORNER_RADIUS / (384 / (v2.virtualScreenSize.X / v2.partSize.X)),
				backgroundColor = v2.roundedCornersFrameColor,
				backgroundTransparency = GetFFlagEnableVRWrapperTransparency() and v2.backgroundTransparency or 0
			}, props[Roact.Children])
		}
	else
		v3 = props[Roact.Children]
	end

	return React.createElement(Panel3D, v2, v3)
end
