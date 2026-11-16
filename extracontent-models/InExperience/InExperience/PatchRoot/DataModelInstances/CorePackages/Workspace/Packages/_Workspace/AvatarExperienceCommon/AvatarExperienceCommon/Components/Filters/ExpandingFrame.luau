local parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent

local React = require(parent.React)
local UIBlox = require(parent.UIBlox)
local AnimatedFrame = UIBlox.Utility.SpringAnimatedItem.AnimatedFrame
local Dash = require(parent.Dash)

local springOptions = { dampingRatio = 1, frequency = 3.5 }

local function ExpandingFrame(props)
	return React.createElement(AnimatedFrame, {
		regularProps = {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = props.LayoutOrder,
			ClipsDescendants = true,
			ref = props.frameRef,
			NextSelectionUp = props.NextSelectionUp,
			NextSelectionDown = props.NextSelectionDown,
			NextSelectionLeft = props.NextSelectionLeft,
			NextSelectionRight = props.NextSelectionRight,
			[React.Change.AbsoluteSize] = props.onAbsoluteSizeChanged
		},
		animatedValues = {
			yOffset = not props.isExpanded and 0 or props.Size.Y.Offset,
			yScale = not props.isExpanded and 0 or props.Size.Y.Scale
		},
		mapValuesToProps = function(p)
			return {
				Size = UDim2.new(props.Size.X.Scale, props.Size.X.Offset, p.yScale, p.yOffset)
			}
		end,
		springOptions = springOptions
	}, props.children)
end

return React.forwardRef(function(p, frameRef)
	return React.createElement(ExpandingFrame, Dash.join(p, { frameRef = frameRef }))
end)
