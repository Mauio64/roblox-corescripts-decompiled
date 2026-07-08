local Parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent
local React = require(Parent.React)
local AnimatedFrame = require(Parent.UIBlox).Utility.SpringAnimatedItem.AnimatedFrame
local Dash = require(Parent.Dash)
local t1 = {
	dampingRatio = 1,
	frequency = 3.5
}

local function ExpandingFrame(t2: {[any]: any}) -- line: 38
	-- upvalues: React (copy), AnimatedFrame (copy), t1 (copy)
	return React.createElement(AnimatedFrame, {
		regularProps = {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = t2.LayoutOrder,
			ClipsDescendants = true,
			ref = t2.frameRef,
			NextSelectionUp = t2.NextSelectionUp,
			NextSelectionDown = t2.NextSelectionDown,
			NextSelectionLeft = t2.NextSelectionLeft,
			NextSelectionRight = t2.NextSelectionRight,
			[React.Change.AbsoluteSize] = t2.onAbsoluteSizeChanged
		},
		animatedValues = {
			yOffset = not t2.isExpanded and 0 or t2.Size.Y.Offset,
			yScale = not t2.isExpanded and 0 or t2.Size.Y.Scale
		},
		mapValuesToProps = function(p1) -- line: 58
			-- upvalues: t2 (copy)
			return {
				Size = UDim2.new(t2.Size.X.Scale, t2.Size.X.Offset, p1.yScale, p1.yOffset)
			}
		end,
		springOptions = t1
	}, t2.children)
end

return React.forwardRef(function(p2, p3) -- line: 68
	-- upvalues: React (copy), ExpandingFrame (copy), Dash (copy)
	return React.createElement(ExpandingFrame, Dash.join(p2, {
		frameRef = p3
	}))
end)
