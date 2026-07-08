local Parent = script:FindFirstAncestor("ExpChat").Parent
local React = require(Parent.React)

require(script.Parent.Constants)

local useLayoutMode = require(script.Parent.useLayoutMode)
local usePresetSurfaceAvailable = require(script.Parent.usePresetSurfaceAvailable)

local function PresetChatGate(t1: {[any]: any}) -- line: 27
	-- upvalues: usePresetSurfaceAvailable (copy), useLayoutMode (copy), React (copy)
	local v7 = usePresetSurfaceAvailable(t1.targetTextChannel)
	local v8 = useLayoutMode()

	if not v7 then
		return nil
	end

	if t1.layoutMode ~= nil and v8 ~= t1.layoutMode then
		return nil
	end

	return React.createElement(React.Fragment, nil, t1.children)
end

return React.memo(PresetChatGate)
