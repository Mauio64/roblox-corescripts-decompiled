local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarViewport/React")

local Constants = require("@game/CorePackages/Workspace/Packages/_Index/AvatarViewport/AvatarViewport/Constants")
require("@game/CorePackages/Workspace/Packages/_Index/AvatarViewport/AvatarViewport/Types")

local function bindCurrentCamera(p2, currentCamera)
	if p2 and currentCamera then
		p2.CurrentCamera = currentCamera
	end
end

local function AvatarViewportScene(props)
	local refs = props.refs
	local inputHandlers = props.inputHandlers
	local lighting = props.lighting
		or {
			ambient = Constants.DefaultAmbient,
			lightColor = Constants.DefaultLightColor,
			lightDirection = Constants.DefaultLightDirection
		}

	local v5 = React.useCallback(function(current)
		refs.viewportFrame.current = current
		local current2 = refs.camera.current

		if current and current2 then
			current.CurrentCamera = current2
		end
	end, { refs })

	local v6 = React.useCallback(function(p2)
		refs.camera.current = p2
		local current = refs.viewportFrame.current

		if current and p2 then
			current.CurrentCamera = p2
		end
	end, { refs })

	return React.createElement("ViewportFrame", {
		Size = props.size,
		BackgroundColor3 = props.backgroundColor3,
		BackgroundTransparency = props.backgroundTransparency or 0,
		BorderSizePixel = 0,
		Ambient = lighting.ambient,
		LightColor = lighting.lightColor,
		LightDirection = lighting.lightDirection,
		Active = inputHandlers ~= nil,
		Selectable = false,
		[React.Event.InputBegan] = inputHandlers and inputHandlers.onInputBegan,
		[React.Event.InputChanged] = inputHandlers and inputHandlers.onInputChanged,
		[React.Event.InputEnded] = inputHandlers and inputHandlers.onInputEnded,
		[React.Event.TouchPinch] = inputHandlers and inputHandlers.onTouchPinch,
		ref = v5
	}, {
		WorldModel = React.createElement("WorldModel", { ref = refs.worldModel }),
		Camera = React.createElement("Camera", {
			CameraType = Enum.CameraType.Scriptable,
			ref = v6
		})
	})
end

return AvatarViewportScene
