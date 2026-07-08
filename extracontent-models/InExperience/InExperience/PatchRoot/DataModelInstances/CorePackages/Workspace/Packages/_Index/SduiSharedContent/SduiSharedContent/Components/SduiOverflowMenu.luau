local Parent = script:FindFirstAncestor("SduiSharedContent").Parent
local React = require(Parent.React)
local AppBlox = require(Parent.AppBlox)
local OverflowMenu = AppBlox.OverflowMenu
local getOverflowMenuSignalStore = AppBlox.getOverflowMenuSignalStore
local useBackButtonBinding = require(Parent.SduiSharedUtilities).useBackButtonBinding
local useUidRefString = require(Parent.SduiCoreSystem).useUidRefString

require(Parent.SduiCompat)

local Foundation = require(Parent.Foundation)
local FFlagSduiExperienceDetailsSupport = require(Parent.SharedFlags).FFlagSduiExperienceDetailsSupport

local function SduiOverflowMenu(t1: {[any]: any}) -- line: 42
	-- upvalues: useUidRefString (copy), FFlagSduiExperienceDetailsSupport (copy), React (copy), getOverflowMenuSignalStore (copy), useBackButtonBinding (copy), Foundation (copy), OverflowMenu (copy)
	local v12 = `sdui-overflow-menu-{ useUidRefString().current }`
	local v13 = t1.anchorPoint or Vector2.new(0, 0)
	local v14 = t1.position or UDim2.new(0, 0, 0, 0)

	if FFlagSduiExperienceDetailsSupport then
		local v15 = React.useCallback(function() -- line: 51
			-- upvalues: getOverflowMenuSignalStore (copy), v12 (copy)
			getOverflowMenuSignalStore().closeMenu(v12)
		end, { v12 })
		local v16 = useBackButtonBinding(v15)
		local items = t1.items
		local n1 = 0

		for _ in items do
			n1 += 1
		end

		if n1 ~= #items then
			local t2 = {}

			for _, v22 in items do
				table.insert(t2, v22)
			end

			items = t2
		end

		local v23 = t1.layoutOrder ~= nil
		local t3 = {
			hasOverflowButton = true,
			shouldShowAnchor = true,
			anchorPoint = if not v23 then v13 else nil,
			anchorPosition = if not v23 then v14 else nil,
			menuItems = items,
			menuKey = v12,
			buttonVariant = t1.buttonVariant,
			buttonIconSize = t1.buttonSize,
			buttonIcon = t1.buttonIcon,
			buttonIconBackgroundStyle = t1.buttonIconBackgroundStyle,
			menuItemSize = t1.menuItemSize,
			popoverAlign = t1.popoverAlign,
			popoverSide = t1.popoverSide,
			menuWidth = t1.menuWidth,
			buttonIsCircular = if not FFlagSduiExperienceDetailsSupport then nil else t1.buttonIsCircular,
			buttonTag = if not FFlagSduiExperienceDetailsSupport then nil else t1.buttonTag,
			setFocusRef = v16
		}

		if v23 then
			return React.createElement(Foundation.View, {
				tag = "auto-xy",
				LayoutOrder = t1.layoutOrder
			}, {
				OverflowMenu = React.createElement(OverflowMenu, t3)
			})
		end

		return React.createElement(OverflowMenu, t3)
	end

	return React.createElement(OverflowMenu, {
		hasOverflowButton = true,
		shouldShowAnchor = true,
		anchorPoint = v13,
		anchorPosition = v14,
		menuItems = t1.items,
		menuKey = v12,
		buttonVariant = t1.buttonVariant,
		buttonIconSize = t1.buttonSize,
		buttonIcon = t1.buttonIcon,
		buttonIconBackgroundStyle = t1.buttonIconBackgroundStyle,
		menuItemSize = t1.menuItemSize,
		popoverAlign = t1.popoverAlign,
		popoverSide = t1.popoverSide,
		menuWidth = t1.menuWidth
	})
end

return React.memo(SduiOverflowMenu)
