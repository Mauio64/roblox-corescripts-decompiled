local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local MomentsCreationParent = MomentsCreation.Parent
local Foundation = require(MomentsCreationParent.Foundation)
local React = require(MomentsCreationParent.React)
local FoundationText = Foundation.Text
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens
local getFormatTime = require(MomentsCreation.Utils.getFormatTime)
local DragHandle = require(MomentsCreation.Enums.DragHandle)

return function(t1: {[any]: any}) -- line: 30
	-- upvalues: useTokens (copy), DragHandle (copy), React (copy), View (copy), FoundationText (copy), getFormatTime (copy)
	local v11 = useTokens()

	if t1.activeHandle ~= DragHandle.LeftHandle and t1.activeHandle ~= DragHandle.RightHandle or not t1.timeLength then
		return nil
	end

	local v12 = if t1.activeHandle ~= DragHandle.LeftHandle then if t1.activeHandle ~= DragHandle.RightHandle then nil else t1.rightHandlePosition else t1.leftHandlePosition

	if v12 == nil then
		return nil
	end

	local timeLength = t1.timeLength

	return React.createElement(View, {
		tag = "col align-x-center align-y-bottom gap-xsmall anchor-bottom-center",
		Position = v12:map(function(n1: number) -- line: 52
			-- upvalues: v11 (copy)
			return UDim2.new(n1, 0, 0, -v11.Padding.Small)
		end)
	}, {
		TextContainer = React.createElement(View, {
			tag = "anchor-center-center size-1600-800 radius-small bg-system-contrast",
			LayoutOrder = 1
		}, {
			TimeText = React.createElement(FoundationText, {
				tag = "position-center-center anchor-center-center auto-xy text-caption-medium content-inverse-default",
				Text = v12:map(function(n2: number) -- line: 62
					-- upvalues: getFormatTime (copy), timeLength (copy)
					return getFormatTime(n2 * timeLength)
				end)
			})
		}),
		VerticalBar = React.createElement(View, {
			tag = "anchor-center-center size-50-300 bg-system-contrast",
			LayoutOrder = 2
		})
	})
end
