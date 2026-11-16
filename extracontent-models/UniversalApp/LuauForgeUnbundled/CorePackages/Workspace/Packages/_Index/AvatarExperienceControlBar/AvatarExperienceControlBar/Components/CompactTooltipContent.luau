local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceControlBar/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceControlBar/Foundation")
local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceControlBar/FocusNavigationUtils")
local InputHandlers = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceControlBar/InputHandlers")
local ReactFocusNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceControlBar/ReactFocusNavigation")
local focusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum

local v5 = { Selectable = false }
local navigateBacks = {
	[Enum.KeyCode.ButtonB] = focusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = focusNavigationEventNameEnum.NavigateBack
}

local function CompactTooltipContent(p2)
	local v6 = Foundation.Hooks.useTokens()
	local v7 = Foundation.Hooks.useScaledValue(296)
	local v8 = p2.onDismiss ~= nil
	local v9 = not v8 and 0 or v6.Size.Size_800
	local v10 = not v8 and 0 or v6.Gap.XSmall
	local v11 = v7 - v6.Padding.Medium * 2 - v9 - v10
	local v12 = React.useMemo(function()
		return { MaxSize = Vector2.new(v11, 1e999) }
	end, { v11 })
	local v13 = React.useMemo(function()
		return {
			[focusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(object)
					if p2.onDismiss then
						p2.onDismiss()
						object:cancel()
					end
				end)
			}
		}
	end, { p2.onDismiss })
	local v14 = ReactFocusNavigation.useEventMap(navigateBacks)
	local v15 = ReactFocusNavigation.useEventHandlerMap(v13, v14)

	local createElement = React.createElement
	local view = Foundation.View

	local v17 = {
		Body = React.createElement(Foundation.Text, {
			LayoutOrder = 1,
			Text = p2.bodyText,
			tag = "auto-xy text-body-medium text-wrap text-align-x-left content-inverse-default",
			sizeConstraint = v12
		}),
		CloseSlot = 0
	}

	local v18 = if v8 then React.createElement(Foundation.View, {
		LayoutOrder = 2,
		Size = UDim2.fromOffset(v9, v6.Size.Size_500 + v6.Size.Size_50)
	}, {
		Close = React.createElement(Foundation.View, {
			onActivated = p2.onDismiss,
			tag = "position-center-center anchor-center-center size-800-800 radius-medium",
			stateLayer = { mode = Foundation.Enums.StateLayerMode.Inverse },
			selection = { Selectable = true },
			testId = "--control-bar-tooltip-close"
		}, {
			Icon = React.createElement(Foundation.Icon, {
				name = Foundation.Enums.IconName.X,
				size = Foundation.Enums.IconSize.Medium,
				style = v6.Inverse.Content.Emphasis,
				Position = UDim2.fromScale(0.5, 0.5),
				AnchorPoint = Vector2.new(0.5, 0.5)
			})
		})
	}) else nil
	v17.CloseSlot = v18
	return createElement(view, {
		ref = v15,
		selectionGroup = false,
		selection = v5,
		tag = "row align-y-center gap-xsmall auto-xy padding-medium",
		testId = "--control-bar-compact-tooltip"
	}, v17)
end

return CompactTooltipContent
