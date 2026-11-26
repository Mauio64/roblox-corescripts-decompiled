local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/React")
local useAXAnimateScrollFrame = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Components/AnimatedScrollingFrame/useAXAnimateScrollFrame")

local function AnimatedScrollingFrame(p2, callback)
	local ref = React.useRef(nil)
	useAXAnimateScrollFrame(ref)
	local v5 = React.useCallback(function(current)
		ref.current = current

		if typeof(callback) == "table" then
			callback.current = current
		elseif typeof(callback) == "function" then
			callback(current)
		end
	end, { callback })

	local clone = table.clone(p2)
	clone.children = nil
	clone.ref = v5
	return React.createElement("ScrollingFrame", clone, p2.children)
end

return React.forwardRef(AnimatedScrollingFrame)
