local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local GenericAbuseReportingParent = GenericAbuseReporting.Parent
local FocusNavigationUtils = require(GenericAbuseReportingParent.FocusNavigationUtils)
local Foundation = require(GenericAbuseReportingParent.Foundation)
local InputHandlers = require(GenericAbuseReportingParent.InputHandlers)
local React = require(GenericAbuseReportingParent.React)

require(GenericAbuseReportingParent.ReactFocusNavigation)

local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local FocusRoot = FocusNavigationUtils.FocusRoot
local Icon = Foundation.Icon
local IconName = Foundation.Enums.IconName
local Popover = Foundation.Popover
local PopoverAlign = Foundation.Enums.PopoverAlign
local PopoverSide = Foundation.Enums.PopoverSide
local EnumsRadius = Foundation.Enums.Radius
local FoundationText = Foundation.Text
local View = Foundation.View
local SideModalDropdownButton = require(GenericAbuseReporting.Common.SideModalDropdownButton)
local t1 = {
	offset = 5,
	position = PopoverSide.Bottom
}

local function InExpDropdownWithPopover(t2: {[any]: any}) -- line: 57
	-- upvalues: React (copy), FocusNavigationEventNameEnum (copy), InputHandlers (copy), View (copy), FoundationText (copy), Icon (copy), IconName (copy), Popover (copy), SideModalDropdownButton (copy), PopoverAlign (copy), t1 (copy), EnumsRadius (copy), FocusRoot (copy), FocusNavigableSurfaceIdentifierEnum (copy)
	local v22, v23 = React.useState(false)
	local v24 = React.useRef(nil)
	local v25, v26 = React.useState(0)
	local onOpenChange = t2.onOpenChange
	local v28 = React.useCallback(function(b1: boolean) -- line: 67
		-- upvalues: onOpenChange (copy), v23 (copy)
		if onOpenChange then
			onOpenChange(b1)
		end

		v23(b1)
	end, { onOpenChange })
	local v29 = React.useMemo(function() -- line: 74
		-- upvalues: t2 (copy)
		if t2.value == nil then
			return nil
		end

		for _, v40 in t2.items do
			if v40.id == t2.value then
				return v40
			end
		end

		return nil
	end, {
		t2.items,
		t2.value
	})
	local v30 = React.useCallback(function() -- line: 86
		-- upvalues: v28 (copy), v22 (copy)
		v28(not v22)
	end, {
		v22,
		v28
	})
	local v31 = React.useCallback(function() -- line: 90
		-- upvalues: v28 (copy)
		v28(false)
	end, { v28 })
	local v32 = React.useMemo(function() -- line: 94
		-- upvalues: FocusNavigationEventNameEnum (copy), InputHandlers (copy), v31 (copy)
		return {
			[FocusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(v31)
			}
		}
	end, { v31 })
	local v33 = if not v29 then t2.placeholder or "" else v29.text
	local items = t2.items
	local onItemChanged = t2.onItemChanged
	local value = t2.value
	local v37 = React.useMemo(function() -- line: 107
		-- upvalues: items (copy), value (copy), React (copy), View (copy), v28 (copy), onItemChanged (copy), FoundationText (copy), Icon (copy), IconName (copy)
		local t3 = {}

		for v42, v43 in items do
			local id = v43.id
			local v45 = id == value

			t3[`item-{ tostring(id) }`] = React.createElement(View, {
				LayoutOrder = v42,
				onActivated = function() -- line: 114
					-- upvalues: v28 (copy), onItemChanged (copy), id (copy)
					v28(false)
					onItemChanged(id)
				end,
				selection = {
					Selectable = true
				},
				tag = {
					["row flex-between size-full-0 auto-y padding-small radius-medium"] = true,
					["bg-shift-200"] = v45
				}
			}, {
				Text = React.createElement(FoundationText, {
					TextWrapped = true,
					tag = "auto-xy",
					LayoutOrder = 1,
					Text = v43.text,
					TextXAlignment = Enum.TextXAlignment.Left
				}),
				Check = v45 and React.createElement(Icon, {
					LayoutOrder = 2,
					name = IconName.CheckLarge
				}) or nil
			})
		end

		return t3
	end, {
		items,
		value,
		onItemChanged,
		v28
	})

	return React.createElement(View, {
		tag = "size-full-0 auto-y padding-top-xxsmall",
		ref = v24,
		onAbsoluteSizeChanged = function(p1) -- line: 145
			-- upvalues: v26 (copy)
			v26(p1.AbsoluteSize.X)
		end,
		LayoutOrder = t2.LayoutOrder
	}, {
		Popover = React.createElement(Popover.Root, {
			isOpen = v22
		}, {
			Trigger = React.createElement(SideModalDropdownButton, {
				onActivated = v30,
				text = v33
			}),
			Anchor = React.createElement(Popover.Anchor, {
				anchorRef = v24
			}),
			Menu = React.createElement(Popover.Content, {
				hasArrow = false,
				align = PopoverAlign.End,
				side = t1,
				onPressedOutside = v31,
				radius = EnumsRadius.Medium
			}, React.createElement(FocusRoot, {
				surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.ModerationOverlay,
				isFocusable = v22,
				isAutoFocusRoot = v22,
				isIsolated = v22,
				eventHandlers = v32
			}, {
				Menu = React.createElement(View, {
					tag = "col align-x-center align-y-center gap-xsmall auto-y padding-xsmall stroke-default radius-medium",
					Size = UDim2.new(0, v25 - 2, 0, -2)
				}, v37)
			}))
		})
	})
end

return React.memo(InExpDropdownWithPopover)
