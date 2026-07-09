local ParentParent = script.Parent.Parent.Parent
local dependencies = require(ParentParent.dependencies)
local React = dependencies.React
local UIBlox = dependencies.UIBlox
local useLocalization = dependencies.Hooks.useLocalization
local TooltipCallout = UIBlox.App.Dialog.TooltipCallout
local TooltipOrientation = UIBlox.App.Dialog.Enum.TooltipOrientation
local TextKeys = require(ParentParent.Common.TextKeys)

return function(t1: {[any]: any}) -- line: 15
	-- upvalues: React (copy), UIBlox (copy), useLocalization (copy), TextKeys (copy), TooltipOrientation (copy), TooltipCallout (copy)
	local v10, v11 = React.useState(0)
	local v12 = UIBlox.Core.Style.useStyle()
	local v13 = useLocalization({
		findFriendsTitle = TextKeys.FindFriendsTooltipTitle,
		findFriendsBody = TextKeys.FindFriendsTooltipBody
	})
	local t2 = {
		distanceOffset = -12,
		headerText = v13.findFriendsTitle,
		bodyText = v13.findFriendsBody,
		orientation = TooltipOrientation.Right,
		triggerPointCenter = Vector2.new(0, 50),
		canvasBackground = v12.Theme.BackgroundDefault,
		contentOffsetVector = Vector2.zero,
		triggerPointRadius = Vector2.zero
	}

	return React.createElement("Frame", {
		LayoutOrder = t1.LayoutOrder,
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		[React.Change.AbsoluteSize] = function(p1) -- line: 42
			-- upvalues: v11 (copy)
			v11((math.max(0, p1.AbsoluteSize.Y - 100)))
		end,
		Position = UDim2.new(0, 0, 0, v10)
	}, {
		Tooltip = React.createElement(TooltipCallout, t2)
	})
end
