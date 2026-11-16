local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/React")

local text = Foundation.Text
local view = Foundation.View

local useTokens = Foundation.Hooks.useTokens

local getFormatTime = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Utils/getFormatTime")

local DragHandle = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Enums/DragHandle")

return function(props)
	local v5 = useTokens()

	if
		props.activeHandle ~= DragHandle.LeftHandle and props.activeHandle ~= DragHandle.RightHandle
		or not props.timeLength
	then
		return nil
	end

	local v6

	if props.activeHandle == DragHandle.LeftHandle then
		v6 = props.leftHandlePosition
	elseif props.activeHandle == DragHandle.RightHandle then
		v6 = props.rightHandlePosition
	end

	if v6 == nil then
		return nil
	end

	local timeLength = props.timeLength

	return React.createElement(view, {
		tag = "col align-x-center align-y-bottom gap-xsmall anchor-bottom-center",
		Position = v6:map(function(p2)
			return UDim2.new(p2, 0, 0, -v5.Padding.Small)
		end)
	}, {
		TextContainer = React.createElement(
			view,
			{
				tag = "anchor-center-center size-1600-800 radius-small bg-system-contrast",
				LayoutOrder = 1
			},
			{
				TimeText = React.createElement(text, {
					tag = "position-center-center anchor-center-center auto-xy text-caption-medium content-inverse-default",
					Text = v6:map(function(p2)
						return getFormatTime(p2 * timeLength)
					end)
				})
			}
		),
		VerticalBar = React.createElement(view, {
			tag = "anchor-center-center size-50-300 bg-system-contrast",
			LayoutOrder = 2
		})
	})
end
