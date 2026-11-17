local parent = script:FindFirstAncestor("SduiSharedContent").Parent

local React = require(parent.React)
local AppBlox = require(parent.AppBlox)
local OverflowMenu = AppBlox.OverflowMenu
local getOverflowMenuSignalStore = AppBlox.getOverflowMenuSignalStore
local SduiSharedUtilities = require(parent.SduiSharedUtilities)
local useBackButtonBinding = SduiSharedUtilities.useBackButtonBinding
local SduiCoreSystem = require(parent.SduiCoreSystem)
local useUidRefString = SduiCoreSystem.useUidRefString
require(parent.SduiCompat)
local Foundation = require(parent.Foundation)

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppSduiGameTileFeedback = SharedFlags.FFlagLuaAppSduiGameTileFeedback
local SharedFlags2 = require(parent.SharedFlags)
local FFlagSduiOverflowMenuHideWhenEmpty = SharedFlags2.FFlagSduiOverflowMenuHideWhenEmpty

local function addMenuItemTelemetry(items)
	local ids = {}

	for _, item in items do
		if typeof(item.id) == "string" and item.id ~= "" then
			table.insert(ids, item.id)
		end
	end

	local joined = table.concat(ids, ",")

	local result = {}

	for _, item in items do
		if item.onActivated and typeof(item.id) == "string" and item.id ~= "" then
			local clone = table.clone(item)
			function clone.onActivated(_, _, _)
				item.onActivated(nil, nil, { menuItemId = item.id, availableMenuItemIds = joined })
			end
			table.insert(result, clone)
		else
			table.insert(result, item)
		end
	end

	return result
end

local function SduiOverflowMenu(props)
	local v = useUidRefString()
	local menuKey

	if FFlagLuaAppSduiGameTileFeedback and props.menuKey then
		menuKey = props.menuKey
	else
		menuKey = `sdui-overflow-menu-{v.current}`
	end

	local anchorPoint = props.anchorPoint or Vector2.new(0, 0)
	local position = props.position or UDim2.new(0, 0, 0, 0)
	local v2, v3

	if FFlagLuaAppSduiGameTileFeedback then
		v2 = props.hasOverflowButton == nil or props.hasOverflowButton
		v3 = props.shouldShowAnchor == nil or props.shouldShowAnchor
	end

	local menuItems

	if FFlagLuaAppSduiGameTileFeedback then
		menuItems = React.useMemo(function()
			if props.includeMenuItemTelemetry then
				return addMenuItemTelemetry(props.items)
			end

			return props.items
		end, { props.items, props.includeMenuItemTelemetry })
	end

	local setFocusRef = useBackButtonBinding((React.useCallback(function()
		getOverflowMenuSignalStore().closeMenu(menuKey)
	end, { menuKey })))

	if not FFlagLuaAppSduiGameTileFeedback then
		menuItems = props.items
	end

	local count = 0

	for _ in menuItems do
		count += 1
	end

	if count ~= #menuItems then
		local v4 = {}

		for _, v5 in menuItems do
			table.insert(v4, v5)
		end

		menuItems = v4
	end

	if FFlagSduiOverflowMenuHideWhenEmpty and #menuItems == 0 then
		return nil
	end

	local v4 = props.layoutOrder ~= nil

	if v4 then
		anchorPoint = nil
	end

	if v4 then
		position = nil
	end

	local v5 = {
		anchorPoint = anchorPoint,
		anchorPosition = position,
		menuItems = menuItems,
		menuKey = menuKey,
		buttonVariant = props.buttonVariant,
		buttonIconSize = props.buttonSize,
		buttonIcon = props.buttonIcon,
		buttonIconBackgroundStyle = props.buttonIconBackgroundStyle,
		menuItemSize = props.menuItemSize,
		popoverAlign = props.popoverAlign,
		popoverSide = props.popoverSide,
		menuWidth = props.menuWidth,
		hasOverflowButton = not FFlagLuaAppSduiGameTileFeedback or v2,
		shouldShowAnchor = not FFlagLuaAppSduiGameTileFeedback or v3,
		buttonIsCircular = props.buttonIsCircular,
		buttonTag = props.buttonTag,
		setFocusRef = 0,
		onMenuOpenChanged = 0,
		zIndex = 0
	}

	if FFlagLuaAppSduiGameTileFeedback and props.setFocusRef then
		setFocusRef = props.setFocusRef
	end

	v5.setFocusRef = setFocusRef
	local onMenuOpenChanged

	if FFlagLuaAppSduiGameTileFeedback then
		onMenuOpenChanged = props.onMenuOpenChanged
	end

	v5.onMenuOpenChanged = onMenuOpenChanged
	local zIndex

	if FFlagLuaAppSduiGameTileFeedback then
		zIndex = props.zIndex
	end

	v5.zIndex = zIndex

	if v4 then
		return React.createElement(Foundation.View, {
			LayoutOrder = props.layoutOrder,
			tag = "auto-xy"
		}, {
			OverflowMenu = React.createElement(OverflowMenu, v5)
		})
	end

	return React.createElement(OverflowMenu, v5)
end

return React.memo(SduiOverflowMenu)
