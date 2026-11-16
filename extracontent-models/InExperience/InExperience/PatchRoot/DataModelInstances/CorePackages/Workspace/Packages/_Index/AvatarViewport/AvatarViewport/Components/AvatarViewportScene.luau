local AvatarViewport = script:FindFirstAncestor("AvatarViewport")
local parent = AvatarViewport.Parent

local React = require(parent.React)

local Constants = require(AvatarViewport.Constants)
require(AvatarViewport.Types)

local function bindCurrentCamera(current, currentCamera) -- 2 equivalent calls inferred from this helper
	if current and currentCamera then
		current.CurrentCamera = currentCamera
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

	local ref = React.useCallback(function(current)
		refs.viewportFrame.current = current
		bindCurrentCamera(current, refs.camera.current) -- inferred equivalent call
	end, { refs })

	local ref2 = React.useCallback(function(current)
		refs.camera.current = current
		bindCurrentCamera(refs.viewportFrame.current, current) -- inferred equivalent call
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
		ref = ref
	}, {
		WorldModel = React.createElement("WorldModel", { ref = refs.worldModel }),
		Camera = React.createElement("Camera", {
			CameraType = Enum.CameraType.Scriptable,
			ref = ref2
		})
	})
end

return AvatarViewportScene
