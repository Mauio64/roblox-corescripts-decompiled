local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/React")
local ReactRoblox = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/ReactRoblox")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/Foundation")

local function fn(p2, p3)
	return React.createElement(Foundation.View, {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		ZIndex = 5,
		ref = p3,
		selectionGroup = {
			SelectionBehaviorUp = Enum.SelectionBehavior.Stop,
			SelectionBehaviorDown = Enum.SelectionBehavior.Stop,
			SelectionBehaviorLeft = Enum.SelectionBehavior.Stop,
			SelectionBehaviorRight = Enum.SelectionBehavior.Stop
		}
	}, p2)
end

local function wrapForReactPortal(p2, p3, p4)
	return ReactRoblox.createPortal(fn(p2, p4), p3)
end

return wrapForReactPortal
