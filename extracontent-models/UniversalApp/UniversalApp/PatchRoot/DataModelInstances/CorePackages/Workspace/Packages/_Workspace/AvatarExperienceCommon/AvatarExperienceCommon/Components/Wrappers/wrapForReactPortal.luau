local Parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent
local React = require(Parent.React)
local ReactRoblox = require(Parent.ReactRoblox)
local Foundation = require(Parent.Foundation)

local function v5(p1, p2) -- line: 8
	-- upvalues: React (copy), Foundation (copy)
	return React.createElement(Foundation.View, {
		BackgroundTransparency = 1,
		ZIndex = 5,
		Size = UDim2.new(1, 0, 1, 0),
		ref = p2,
		selectionGroup = {
			SelectionBehaviorUp = Enum.SelectionBehavior.Stop,
			SelectionBehaviorDown = Enum.SelectionBehavior.Stop,
			SelectionBehaviorLeft = Enum.SelectionBehavior.Stop,
			SelectionBehaviorRight = Enum.SelectionBehavior.Stop
		}
	}, p1)
end
local function wrapForReactPortal(p3, p4, p5) -- line: 23
	-- upvalues: ReactRoblox (copy), v5 (copy)
	return ReactRoblox.createPortal(v5(p3, p5), p4)
end

return wrapForReactPortal
