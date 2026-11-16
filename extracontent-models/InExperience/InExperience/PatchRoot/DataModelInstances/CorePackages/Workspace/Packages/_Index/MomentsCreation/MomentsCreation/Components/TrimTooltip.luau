local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local parent = MomentsCreation.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

local Text = Foundation.Text
local View = Foundation.View

local useTokens = Foundation.Hooks.useTokens

local getFormatTime = require(MomentsCreation.Utils.getFormatTime)

local DragHandle = require(MomentsCreation.Enums.DragHandle)

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

	if v2 == nil then
		return nil
	end

	local timeLength = props.timeLength

	return React.createElement(View, {
		tag = "col align-x-center align-y-bottom gap-xsmall anchor-bottom-center",
		Position = v2:map(function(p: number)
			return UDim2.new(p, 0, 0, -v.Padding.Small)
		end)
	}, {
		TextContainer = React.createElement(
			View,
			{
				tag = "anchor-center-center size-1600-800 radius-small bg-system-contrast",
				LayoutOrder = 1
			},
			{
				TimeText = React.createElement(Text, {
					tag = "position-center-center anchor-center-center auto-xy text-caption-medium content-inverse-default",
					Text = v2:map(function(p: number)
						return getFormatTime(p * timeLength)
					end)
				})
			}
		),
		VerticalBar = React.createElement(View, {
			tag = "anchor-center-center size-50-300 bg-system-contrast",
			LayoutOrder = 2
		})
	})
end
