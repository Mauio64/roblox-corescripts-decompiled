local ParentParent = script.Parent.Parent
local React = require(ParentParent.React)
local Roact = require(ParentParent.Roact)
local UIBlox = require(ParentParent.UIBlox)
local SharedFlags = require(ParentParent.SharedFlags)
local Panel3D = UIBlox.Core.VR.Panel3D
local useIsFPSAtTarget = require(ParentParent.SplashScreenManager).useIsFPSAtTarget
local RoundedCornersFrame = require(script.Parent.RoundedCornersFrame)
local Object = require(ParentParent.LuauPolyfill).Object
local useIsSpatial = require(ParentParent.Responsive).useIsSpatial
local GetFFlagEnableVRWrapperTransparency = SharedFlags.GetFFlagEnableVRWrapperTransparency
local ROUNDED_CORNER_RADIUS = require(script.Parent.Constants).ROUNDED_CORNER_RADIUS

return function(t1: {[any]: any}) -- line: 36
	-- upvalues: useIsFPSAtTarget (copy), Object (copy), useIsSpatial (copy), Roact (copy), RoundedCornersFrame (copy), ROUNDED_CORNER_RADIUS (copy), GetFFlagEnableVRWrapperTransparency (copy), React (copy), Panel3D (copy)
	local v14 = useIsFPSAtTarget()
	local v15 = Object.assign({}, t1.vrProps, {
		hidden = t1.vrProps.hidden or not v14
	})

	if useIsSpatial() then
		local v16 = if not v15.roundedCornersFrameColor then t1[Roact.Children] else {
			RoundedFrame = Roact.createElement(RoundedCornersFrame, {
				cornerRadius = ROUNDED_CORNER_RADIUS / (384 / (v15.virtualScreenSize.X / v15.partSize.X)),
				backgroundColor = v15.roundedCornersFrameColor,
				backgroundTransparency = not GetFFlagEnableVRWrapperTransparency() and 0 or (v15.backgroundTransparency or 0)
			}, t1[Roact.Children])
		}

		return React.createElement(Panel3D, v15, v16)
	end

	return React.createElement(t1.component, t1.props, t1[Roact.Children])
end
