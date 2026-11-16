local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)
local ReactIs = require(parent.ReactIs)

local getTestIdTag = require(Foundation.Utility.getTestIdTag)

require(Foundation.Components.Types)

local function getAspectRatio(aspectRatio)
	if ReactIs.isBinding(aspectRatio) or typeof(aspectRatio) == "number" then
		return { AspectRatio = aspectRatio, AspectType = nil, DominantAxis = nil }
	end

	return {
		AspectRatio = aspectRatio.AspectRatio,
		AspectType = aspectRatio.AspectType,
		DominantAxis = aspectRatio.DominantAxis
	}
end

local function AspectRatio(p)
	local aspectRatio = getAspectRatio(p.value)
	return React.createElement("UIAspectRatioConstraint", {
		AspectRatio = aspectRatio.AspectRatio,
		AspectType = aspectRatio.AspectType,
		DominantAxis = aspectRatio.DominantAxis,
		[React.Tag] = getTestIdTag(p.testId)
	})
end

return React.memo(AspectRatio)
