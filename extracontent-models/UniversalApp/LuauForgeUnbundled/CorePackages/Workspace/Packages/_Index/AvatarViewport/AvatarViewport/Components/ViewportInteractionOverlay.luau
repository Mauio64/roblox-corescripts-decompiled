local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarViewport/React")

require("@game/CorePackages/Workspace/Packages/_Index/AvatarViewport/AvatarViewport/Types")

local function ViewportInteractionOverlay(props)
	return React.createElement("Frame", {
		Name = props.name or "InteractionOverlay",
		Size = props.size,
		Position = props.position,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Active = true,
		Selectable = false,
		ZIndex = props.zIndex,
		[React.Event.InputBegan] = props.inputHandlers.onInputBegan,
		[React.Event.InputChanged] = props.inputHandlers.onInputChanged,
		[React.Event.InputEnded] = props.inputHandlers.onInputEnded,
		[React.Event.TouchPinch] = props.inputHandlers.onTouchPinch
	})
end

return ViewportInteractionOverlay
