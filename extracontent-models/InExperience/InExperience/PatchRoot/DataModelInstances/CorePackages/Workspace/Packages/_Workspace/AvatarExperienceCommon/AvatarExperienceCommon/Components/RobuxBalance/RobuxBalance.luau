local Parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local AvatarExperienceFlags = require(Parent.AvatarExperienceFlags)
local CursorType = Foundation.Enums.CursorType
local useCursor = Foundation.Hooks.useCursor
local FFlagAXResetAvatarButton = AvatarExperienceFlags.FFlagAXResetAvatarButton

return (React.forwardRef(function(t1: {[any]: any}, p1) -- line: 21
	-- upvalues: Foundation (copy), useCursor (copy), CursorType (copy), React (copy), FFlagAXResetAvatarButton (copy)
	local v10 = Foundation.Hooks.useTokens()
	local v11 = useCursor(CursorType.SmallPill)
	local v12, v13 = React.useBinding(false)
	local v14 = React.useCallback(function(p2) -- line: 28
		-- upvalues: Foundation (copy), v13 (copy)
		if p2 == Foundation.Enums.ControlState.Default then
			v13(false)

			return
		end

		if p2 == Foundation.Enums.ControlState.Hover then
			v13(true)
		end
	end, {})

	return React.createElement(Foundation.View, {
		testId = "RobuxBalance",
		tag = not FFlagAXResetAvatarButton and "row auto-xy align-y-center radius-circle padding-x-large gap-xsmall size-0-1100" or "row auto-xy align-y-center radius-circle padding-x-large gap-xsmall size-0-1000",
		ref = p1,
		onActivated = t1.onActivated,
		onStateChanged = v14,
		backgroundStyle = v12:map(function(p3) -- line: 46
			-- upvalues: v10 (copy)
			if p3 then
				return v10.Color.Shift.Shift_200
			end

			return v10.Color.Surface.Surface_0
		end),
		stateLayer = {
			affordance = Foundation.Enums.StateLayerAffordance.None
		},
		selection = {
			Selectable = true,
			SelectionImageObject = v11,
			NextSelectionLeft = t1.NextSelectionLeft
		}
	}, {
		RobuxBalanceIcon = React.createElement(Foundation.Icon, {
			name = "robux",
			LayoutOrder = 1,
			testId = "RobuxBalanceIcon",
			style = v10.Color.ActionStandard.Foreground,
			size = Foundation.Enums.IconSize.Small
		}),
		RobuxBalanceText = React.createElement(Foundation.Text, {
			tag = "auto-xy",
			testId = "RobuxBalanceText",
			LayoutOrder = 2,
			Text = t1.text,
			textStyle = v10.Color.Content.Emphasis,
			fontStyle = v10.Typography.LabelMedium,
			selection = {
				Selectable = false
			}
		})
	})
end))
