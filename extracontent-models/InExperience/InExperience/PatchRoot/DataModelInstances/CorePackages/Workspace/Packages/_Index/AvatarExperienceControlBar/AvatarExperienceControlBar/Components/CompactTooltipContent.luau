local parent = script:FindFirstAncestor("AvatarExperienceControlBar").Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local InputHandlers = require(parent.InputHandlers)
local ReactFocusNavigation = require(parent.ReactFocusNavigation)
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum

local selection = { Selectable = false }
local navigateBacks = {
	[Enum.KeyCode.ButtonB] = FocusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = FocusNavigationEventNameEnum.NavigateBack
}

local function CompactTooltipContent(p)
	local v = Foundation.Hooks.useTokens()
	local v2 = Foundation.Hooks.useScaledValue(296)
	local v3 = p.onDismiss ~= nil
	local v4 = not v3 and 0 or v.Size.Size_800
	local v5 = not v3 and 0 or v.Gap.XSmall
	local v6 = v2 - v.Padding.Medium * 2 - v4 - v5
	local sizeConstraint = React.useMemo(function()
		return { MaxSize = Vector2.new(v6, 1e999) }
	end, { v6 })
	local v7 = React.useMemo(function()
		return {
			[FocusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(object)
					if p.onDismiss then
						p.onDismiss()
						object:cancel()
					end
				end)
			}
		}
	end, { p.onDismiss })
	local v8 = ReactFocusNavigation.useEventMap(navigateBacks)
	local ref = ReactFocusNavigation.useEventHandlerMap(v7, v8)

	local createElement = React.createElement
	local view = Foundation.View

	local v9 = {
		Body = React.createElement(Foundation.Text, {
			LayoutOrder = 1,
			Text = p.bodyText,
			tag = "auto-xy text-body-medium text-wrap text-align-x-left content-inverse-default",
			sizeConstraint = sizeConstraint
		}),
		CloseSlot = 0
	}
	local closeSlot

	if v3 then
		closeSlot = React.createElement(Foundation.View, {
			LayoutOrder = 2,
			Size = UDim2.fromOffset(v4, v.Size.Size_500 + v.Size.Size_50)
		}, {
			Close = React.createElement(Foundation.View, {
				onActivated = p.onDismiss,
				tag = "position-center-center anchor-center-center size-800-800 radius-medium",
				stateLayer = { mode = Foundation.Enums.StateLayerMode.Inverse },
				selection = { Selectable = true },
				testId = "--control-bar-tooltip-close"
			}, {
				Icon = React.createElement(Foundation.Icon, {
					name = Foundation.Enums.IconName.X,
					size = Foundation.Enums.IconSize.Medium,
					style = v.Inverse.Content.Emphasis,
					Position = UDim2.fromScale(0.5, 0.5),
					AnchorPoint = Vector2.new(0.5, 0.5)
				})
			})
		})
	end

	v9.CloseSlot = closeSlot
	return createElement(view, {
		ref = ref,
		selectionGroup = false,
		selection = selection,
		tag = "row align-y-center gap-xsmall auto-xy padding-medium",
		testId = "--control-bar-compact-tooltip"
	}, v9)
end

return CompactTooltipContent
