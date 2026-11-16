local parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent

local React = require(parent.React)
local ReactRoblox = require(parent.ReactRoblox)
local Foundation = require(parent.Foundation)

local function fn(p, ref)
	return React.createElement(Foundation.View, {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		ZIndex = 5,
		ref = ref,
		selectionGroup = {
			SelectionBehaviorUp = Enum.SelectionBehavior.Stop,
			SelectionBehaviorDown = Enum.SelectionBehavior.Stop,
			SelectionBehaviorLeft = Enum.SelectionBehavior.Stop,
			SelectionBehaviorRight = Enum.SelectionBehavior.Stop
		}
	}, p)
end

local function wrapForReactPortal(p, p2, ref)
	return ReactRoblox.createPortal(fn(p, ref), p2)
end

return wrapForReactPortal
