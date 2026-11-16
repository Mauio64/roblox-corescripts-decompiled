local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/Foundation")
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceFlags")

local cursorType = Foundation.Enums.CursorType
local useCursor = Foundation.Hooks.useCursor

local fFlagAXResetAvatarButton = AvatarExperienceFlags.FFlagAXResetAvatarButton

return (React.forwardRef(function(props, p2)
	local v5 = Foundation.Hooks.useTokens()

	local v6 = useCursor(cursorType.SmallPill)
	local v7, v8 = React.useBinding(false)

	local v9 = React.useCallback(function(p3)
		if p3 == Foundation.Enums.ControlState.Default then
			v8(false)
		elseif p3 == Foundation.Enums.ControlState.Hover then
			v8(true)
		end
	end, {})

	return React.createElement(Foundation.View, {
		tag = fFlagAXResetAvatarButton and "row auto-xy align-y-center radius-circle padding-x-large gap-xsmall size-0-1000" or "row auto-xy align-y-center radius-circle padding-x-large gap-xsmall size-0-1100",
		testId = "RobuxBalance",
		ref = p2,
		onActivated = props.onActivated,
		onStateChanged = v9,
		backgroundStyle = v7:map(function(p3)
			if p3 then
				return v5.Color.Shift.Shift_200
			end

			return v5.Color.Surface.Surface_0
		end),
		stateLayer = { affordance = Foundation.Enums.StateLayerAffordance.None },
		selection = {
			Selectable = true,
			SelectionImageObject = v6,
			NextSelectionLeft = props.NextSelectionLeft
		}
	}, {
		RobuxBalanceIcon = React.createElement(Foundation.Icon, {
			name = "robux",
			style = v5.Color.ActionStandard.Foreground,
			size = Foundation.Enums.IconSize.Small,
			LayoutOrder = 1,
			testId = "RobuxBalanceIcon"
		}),
		RobuxBalanceText = React.createElement(Foundation.Text, {
			tag = "auto-xy",
			testId = "RobuxBalanceText",
			Text = props.text,
			textStyle = v5.Color.Content.Emphasis,
			fontStyle = v5.Typography.LabelMedium,
			LayoutOrder = 2,
			selection = { Selectable = false }
		})
	})
end))
