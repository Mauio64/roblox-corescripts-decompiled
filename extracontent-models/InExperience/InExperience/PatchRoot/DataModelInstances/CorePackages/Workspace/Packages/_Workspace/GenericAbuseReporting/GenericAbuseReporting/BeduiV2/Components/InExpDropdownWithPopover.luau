local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local parent = GenericAbuseReporting.Parent

local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local Foundation = require(parent.Foundation)
local InputHandlers = require(parent.InputHandlers)
local React = require(parent.React)
require(parent.ReactFocusNavigation)

local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local FocusRoot = FocusNavigationUtils.FocusRoot
local Icon = Foundation.Icon
local IconName = Foundation.Enums.IconName
local Popover = Foundation.Popover
local PopoverAlign = Foundation.Enums.PopoverAlign
local PopoverSide = Foundation.Enums.PopoverSide
local Radius = Foundation.Enums.Radius
local Text = Foundation.Text
local View = Foundation.View

local SideModalDropdownButton = require(GenericAbuseReporting.Common.SideModalDropdownButton)

local side = { position = PopoverSide.Bottom, offset = 5 }

local function InExpDropdownWithPopover(props)
	local state, setState = React.useState(false)
	local ref = React.useRef(nil)
	local state2, setState2 = React.useState(0)

	local onOpenChange = props.onOpenChange
	local v = React.useCallback(function(flag: boolean)
		if onOpenChange then
			onOpenChange(flag)
		end

		setState(flag)
	end, { onOpenChange })

	local v2 = React.useMemo(function()
		if props.value == nil then
			return nil
		end

		for _, item in props.items do
			if item.id == props.value then
				return item
			end
		end

		return nil
	end, { props.items, props.value })

	local onActivated = React.useCallback(function()
		v(not state)
	end, { state, v })

	local onPressedOutside = React.useCallback(function()
		v(false)
	end, { v })

	local eventHandlers = React.useMemo(function()
		return {
			[FocusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(onPressedOutside)
			}
		}
	end, { onPressedOutside })
	local text

	if v2 then
		text = v2.text
	else
		text = props.placeholder or ""
	end

	local items = props.items
	local onItemChanged = props.onItemChanged
	local value = props.value
	local v3 = React.useMemo(function()
		local children = {}

		for k, item in items do
			local id = item.id
			local bgshift = id == value
			children[`item-{tostring(id)}`] = React.createElement(View, {
				LayoutOrder = k,
				onActivated = function()
					v(false)
					onItemChanged(id)
				end,
				selection = { Selectable = true },
				tag = {
					["row flex-between size-full-0 auto-y padding-small radius-medium"] = true,
					["bg-shift-200"] = bgshift
				}
			}, {
				Text = React.createElement(Text, {
					Text = item.text,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextWrapped = true,
					tag = "auto-xy",
					LayoutOrder = 1
				}),
				Check = bgshift and React.createElement(Icon, {
					name = IconName.CheckLarge,
					LayoutOrder = 2
				}) or nil
			})
		end

		return children
	end, { items, value, onItemChanged, v })

	return React.createElement(View, {
		tag = "size-full-0 auto-y padding-top-xxsmall",
		ref = ref,
		onAbsoluteSizeChanged = function(p)
			setState2(p.AbsoluteSize.X)
		end,
		LayoutOrder = props.LayoutOrder
	}, {
		Popover = React.createElement(Popover.Root, { isOpen = state }, {
			Trigger = React.createElement(SideModalDropdownButton, {
				onActivated = onActivated,
				text = text
			}),
			Anchor = React.createElement(Popover.Anchor, { anchorRef = ref }),
			Menu = React.createElement(Popover.Content, {
				align = PopoverAlign.End,
				side = side,
				hasArrow = false,
				onPressedOutside = onPressedOutside,
				radius = Radius.Medium
			}, React.createElement(FocusRoot, {
				surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.ModerationOverlay,
				isFocusable = state,
				isAutoFocusRoot = state,
				isIsolated = state,
				eventHandlers = eventHandlers
			}, {
				Menu = React.createElement(View, {
					Size = UDim2.new(0, state2 - 2, 0, -2),
					tag = "col align-x-center align-y-center gap-xsmall auto-y padding-xsmall stroke-default radius-medium"
				}, v3)
			}))
		})
	})
end

return React.memo(InExpDropdownWithPopover)
