local Foundation = script:FindFirstAncestor("Foundation")

local parent = Foundation.Parent
local React = require(parent.React)
local ReactIs = require(parent.ReactIs)

require(Foundation.Components.Types)

local function getOriginalBackgroundStyle(color, object)
	if ReactIs.isBinding(color) and ReactIs.isBinding(object) then
		return React.joinBindings({ Color3 = color, Transparency = object })
	end

	if ReactIs.isBinding(color) then
		return color:map(function(color2)
			return { Color3 = color2, Transparency = object }
		end)
	end

	if ReactIs.isBinding(object) then
		return object:map(function(transparency)
			return { Color3 = color, Transparency = transparency }
		end)
	end

	return { Color3 = color, Transparency = object }
end

return getOriginalBackgroundStyle
