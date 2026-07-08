local MomentsCreationFlow = script:FindFirstAncestor("MomentsCreationFlow")
local MomentsCreationFlowParent = MomentsCreationFlow.Parent
local Foundation = require(MomentsCreationFlowParent.Foundation)
local MomentsCommon = require(MomentsCreationFlowParent.MomentsCommon)
local React = require(MomentsCreationFlowParent.React)
local FoundationText = Foundation.Text
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens
local getFormatTime = MomentsCommon.Utils.getFormatTime
local DragHandle = require(MomentsCreationFlow.Enums.DragHandle)

return function(t1: {[any]: any}) -- line: 27
	-- upvalues: useTokens (copy), DragHandle (copy), React (copy), View (copy), FoundationText (copy), getFormatTime (copy)
	local v12 = useTokens()

	if t1.activeHandle ~= DragHandle.LeftHandle and t1.activeHandle ~= DragHandle.RightHandle or not t1.timeLength then
		return nil
	end

	local v13 = if t1.activeHandle ~= DragHandle.LeftHandle then if t1.activeHandle ~= DragHandle.RightHandle then nil else t1.rightHandlePosition else t1.leftHandlePosition

	return React.createElement(View, {
		tag = "align-x-center align-y-bottom anchor-bottom-center col gap-xsmall",
		Position = v13:map(function(p1) -- line: 44
			-- upvalues: v12 (copy)
			return UDim2.new(p1, 0, 0, -v12.Padding.Small)
		end)
	}, {
		TextContainer = React.createElement(View, {
			tag = "anchor-center-center bg-system-contrast size-1600-800 radius-small",
			LayoutOrder = 1
		}, {
			TimeText = React.createElement(FoundationText, {
				tag = "anchor-center-center auto-xy content-inverse-default position-center-center text-caption-medium",
				Text = v13:map(function(p2) -- line: 54
					-- upvalues: getFormatTime (copy), t1 (copy)
					return getFormatTime(p2 * t1.timeLength)
				end)
			})
		}),
		VerticalBar = React.createElement(View, {
			tag = "anchor-center-center bg-system-contrast size-50-300",
			LayoutOrder = 2
		})
	})
end
