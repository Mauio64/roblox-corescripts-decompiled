local parent = script:FindFirstAncestor("ExpChat").Parent
local React = require(parent.React)

require(script.Parent.Constants)
local useLayoutMode = require(script.Parent.useLayoutMode)
local usePresetSurfaceAvailable = require(script.Parent.usePresetSurfaceAvailable)

local function PresetChatGate(props)
	local v = usePresetSurfaceAvailable(props.targetTextChannel)
	local v2 = useLayoutMode()

	if not v then
		return nil
	end

	if props.layoutMode == nil or v2 == props.layoutMode then
		return React.createElement(React.Fragment, nil, props.children)
	end

	return nil
end

return React.memo(PresetChatGate)
