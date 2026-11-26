local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/FocusNavigationUtils")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/Foundation")
local InputHandlers = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/InputHandlers")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/React")
require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/ReactFocusNavigation")

local focusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local focusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local focusRoot = FocusNavigationUtils.FocusRoot
local icon = Foundation.Icon
local iconName = Foundation.Enums.IconName
local popover = Foundation.Popover
local popoverAlign = Foundation.Enums.PopoverAlign
local popoverSide = Foundation.Enums.PopoverSide
local radius = Foundation.Enums.Radius
local text = Foundation.Text
local view = Foundation.View

local SideModalDropdownButton = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Common/SideModalDropdownButton")

local v5 = { position = popoverSide.Bottom, offset = 5 }

local function InExpDropdownWithPopover(props)
	local state, setState = React.useState(false)
	local ref = React.useRef(nil)
	local state2, setState2 = React.useState(0)

	local onOpenChange = props.onOpenChange
	local v6 = React.useCallback(function(p2)
		if onOpenChange then
			onOpenChange(p2)
		end

		setState(p2)
	end, { onOpenChange })

	local v7 = React.useMemo(function()
		if props.value == nil then
			return nil
		end

		for k, item in props.items do
			if item.id == props.value then
				return item
			end
		end

		return nil
	end, { props.items, props.value })

	local v8 = React.useCallback(function()
		v6(not state)
	end, { state, v6 })

	local v9 = React.useCallback(function()
		v6(false)
	end, { v6 })

	local v10 = React.useMemo(function()
		return {
			[focusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(v9)
			}
		}
	end, { v9 })

	local v11 = if v7 then v7.text else props.placeholder or ""

	local items = props.items
	local onItemChanged = props.onItemChanged
	local value = props.value
	local v12 = React.useMemo(function()
		local children = {}

		for k, item in items do
			local id = item.id
			local v13 = id == value
			children[`item-{tostring(id)}`] = React.createElement(view, {
				LayoutOrder = k,
				onActivated = function()
					v6(false)
					onItemChanged(id)
				end,
				selection = { Selectable = true },
				tag = {
					["row flex-between size-full-0 auto-y padding-small radius-medium"] = true,
					["bg-shift-200"] = v13
				}
			}, {
				Text = React.createElement(text, {
					Text = item.text,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextWrapped = true,
					tag = "auto-xy",
					LayoutOrder = 1
				}),
				Check = v13 and React.createElement(icon, {
					name = iconName.CheckLarge,
					LayoutOrder = 2
				}) or nil
			})
		end

		return children
	end, { items, value, onItemChanged, v6 })

	return React.createElement(view, {
		tag = "size-full-0 auto-y padding-top-xxsmall",
		ref = ref,
		onAbsoluteSizeChanged = function(p2)
			setState2(p2.AbsoluteSize.X)
		end,
		LayoutOrder = props.LayoutOrder
	}, {
		Popover = React.createElement(popover.Root, { isOpen = state }, {
			Trigger = React.createElement(SideModalDropdownButton, { onActivated = v8, text = v11 }),
			Anchor = React.createElement(popover.Anchor, { anchorRef = ref }),
			Menu = React.createElement(popover.Content, {
				align = popoverAlign.End,
				side = v5,
				hasArrow = false,
				onPressedOutside = v9,
				radius = radius.Medium
			}, React.createElement(focusRoot, {
				surfaceIdentifier = focusNavigableSurfaceIdentifierEnum.ModerationOverlay,
				isFocusable = state,
				isAutoFocusRoot = state,
				isIsolated = state,
				eventHandlers = v10
			}, {
				Menu = React.createElement(view, {
					Size = UDim2.new(0, state2 - 2, 0, -2),
					tag = "col align-x-center align-y-center gap-xsmall auto-y padding-xsmall stroke-default radius-medium"
				}, v12)
			}))
		})
	})
end

return React.memo(InExpDropdownWithPopover)
