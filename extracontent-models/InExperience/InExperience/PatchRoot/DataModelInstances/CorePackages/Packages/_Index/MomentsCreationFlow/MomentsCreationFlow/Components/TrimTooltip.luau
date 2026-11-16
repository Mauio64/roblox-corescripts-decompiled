local MomentsCreationFlow = script:FindFirstAncestor("MomentsCreationFlow")
local parent = MomentsCreationFlow.Parent

local Foundation = require(parent.Foundation)
local MomentsCommon = require(parent.MomentsCommon)
local React = require(parent.React)

local Text = Foundation.Text
local View = Foundation.View

local useTokens = Foundation.Hooks.useTokens

local getFormatTime = MomentsCommon.Utils.getFormatTime

local DragHandle = require(MomentsCreationFlow.Enums.DragHandle)

return function(props)
	local v = useTokens()

	if
		props.activeHandle ~= DragHandle.LeftHandle and props.activeHandle ~= DragHandle.RightHandle
		or not props.timeLength
	then
		return nil
	end

	local v2

	if props.activeHandle == DragHandle.LeftHandle then
		v2 = props.leftHandlePosition
	elseif props.activeHandle == DragHandle.RightHandle then
		v2 = props.rightHandlePosition
	end

	return React.createElement(View, {
		tag = "align-x-center align-y-bottom anchor-bottom-center col gap-xsmall",
		Position = v2:map(function(p)
			return UDim2.new(p, 0, 0, -v.Padding.Small)
		end)
	}, {
		TextContainer = React.createElement(
			View,
			{
				tag = "anchor-center-center bg-system-contrast size-1600-800 radius-small",
				LayoutOrder = 1
			},
			{
				TimeText = React.createElement(Text, {
					tag = "anchor-center-center auto-xy content-inverse-default position-center-center text-caption-medium",
					Text = v2:map(function(p)
						return getFormatTime(p * props.timeLength)
					end)
				})
			}
		),
		VerticalBar = React.createElement(View, {
			tag = "anchor-center-center bg-system-contrast size-50-300",
			LayoutOrder = 2
		})
	})
end
