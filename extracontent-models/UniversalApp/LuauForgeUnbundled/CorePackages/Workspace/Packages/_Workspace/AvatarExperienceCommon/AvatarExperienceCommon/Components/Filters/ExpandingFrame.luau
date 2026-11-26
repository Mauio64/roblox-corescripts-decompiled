local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/React")
local animatedFrame = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/UIBlox").Utility.SpringAnimatedItem.AnimatedFrame
local Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/Dash")

local v5 = { dampingRatio = 1, frequency = 3.5 }

local function ExpandingFrame(props)
	return React.createElement(animatedFrame, {
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
		mapValuesToProps = function(p2)
			return {
				Size = UDim2.new(props.Size.X.Scale, props.Size.X.Offset, p2.yScale, p2.yOffset)
			}
		end,
		springOptions = v5
	}, props.children)
end

return React.forwardRef(function(p2, p3)
	return React.createElement(ExpandingFrame, Dash.join(p2, { frameRef = p3 }))
end)
