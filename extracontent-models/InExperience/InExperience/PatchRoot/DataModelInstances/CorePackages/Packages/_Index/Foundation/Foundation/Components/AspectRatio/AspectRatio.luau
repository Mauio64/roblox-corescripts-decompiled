local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local ReactIs = require(FoundationParent.ReactIs)
local getTestIdTag = require(Foundation.Utility.getTestIdTag)

require(Foundation.Components.Types)

local function getAspectRatio(p1) -- line: 14
	-- upvalues: ReactIs (copy)
	if ReactIs.isBinding(p1) or typeof(p1) == "number" then
		return {
			AspectType = nil,
			DominantAxis = nil,
			AspectRatio = p1
		}
	end

	return {
		AspectRatio = p1.AspectRatio,
		AspectType = p1.AspectType,
		DominantAxis = p1.DominantAxis
	}
end
local function AspectRatio(t1: {[any]: any}) -- line: 41
	-- upvalues: getAspectRatio (copy), React (copy), getTestIdTag (copy)
	local v10 = getAspectRatio(t1.value)

	return React.createElement("UIAspectRatioConstraint", {
		AspectRatio = v10.AspectRatio,
		AspectType = v10.AspectType,
		DominantAxis = v10.DominantAxis,
		[React.Tag] = getTestIdTag(t1.testId)
	})
end

return React.memo(AspectRatio)
