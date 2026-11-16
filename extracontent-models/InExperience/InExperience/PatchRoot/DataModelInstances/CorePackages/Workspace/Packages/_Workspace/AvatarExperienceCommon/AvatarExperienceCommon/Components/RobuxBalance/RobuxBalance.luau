local parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)

local CursorType = Foundation.Enums.CursorType
local useCursor = Foundation.Hooks.useCursor

local FFlagAXResetAvatarButton = AvatarExperienceFlags.FFlagAXResetAvatarButton

return (React.forwardRef(function(props, ref)
	local v = Foundation.Hooks.useTokens()

	local selectionImageObject = useCursor(CursorType.SmallPill)
	local v2, v3 = React.useBinding(false)

	local onStateChanged = React.useCallback(function(p)
		if p == Foundation.Enums.ControlState.Default then
			v3(false)
		elseif p == Foundation.Enums.ControlState.Hover then
			v3(true)
		end
	end, {})

	return React.createElement(Foundation.View, {
		tag = FFlagAXResetAvatarButton and "row auto-xy align-y-center radius-circle padding-x-large gap-xsmall size-0-1000" or "row auto-xy align-y-center radius-circle padding-x-large gap-xsmall size-0-1100",
		testId = "RobuxBalance",
		ref = ref,
		onActivated = props.onActivated,
		onStateChanged = onStateChanged,
		backgroundStyle = v2:map(function(p)
			if p then
				return v.Color.Shift.Shift_200
			end

			return v.Color.Surface.Surface_0
		end),
		stateLayer = { affordance = Foundation.Enums.StateLayerAffordance.None },
		selection = {
			Selectable = true,
			SelectionImageObject = selectionImageObject,
			NextSelectionLeft = props.NextSelectionLeft
		}
	}, {
		RobuxBalanceIcon = React.createElement(Foundation.Icon, {
			name = "robux",
			style = v.Color.ActionStandard.Foreground,
			size = Foundation.Enums.IconSize.Small,
			LayoutOrder = 1,
			testId = "RobuxBalanceIcon"
		}),
		RobuxBalanceText = React.createElement(Foundation.Text, {
			tag = "auto-xy",
			testId = "RobuxBalanceText",
			Text = props.text,
			textStyle = v.Color.Content.Emphasis,
			fontStyle = v.Typography.LabelMedium,
			LayoutOrder = 2,
			selection = { Selectable = false }
		})
	})
end))
