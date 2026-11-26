local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/React")
local AppBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/AppBlox")
local overflowMenu = AppBlox.OverflowMenu
local getOverflowMenuSignalStore = AppBlox.getOverflowMenuSignalStore
local useBackButtonBinding = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiSharedUtilities").useBackButtonBinding
local useUidRefString = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiCoreSystem").useUidRefString
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiCompat")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/Foundation")

local fFlagLuaAppSduiGameTileFeedback = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SharedFlags").FFlagLuaAppSduiGameTileFeedback
local fFlagSduiOverflowMenuHideWhenEmpty = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SharedFlags").FFlagSduiOverflowMenuHideWhenEmpty

local function addMenuItemTelemetry(items)
	local ids = {}

	for k, item in items do
		if typeof(item.id) == "string" and item.id ~= "" then
			table.insert(ids, item.id)
		end
	end

	local joined = table.concat(ids, ",")

	local result = {}

	for k, item in items do
		if item.onActivated and typeof(item.id) == "string" and item.id ~= "" then
			local clone = table.clone(item)
			function clone.onActivated(p2, p3, p4)
				item.onActivated(nil, nil, {
					menuItemId = item.id,
					availableMenuItemIds = joined
				})
			end
			table.insert(result, clone)
		else
			table.insert(result, item)
		end
	end

	return result
end

local function SduiOverflowMenu(props)
	local v5 = useUidRefString()
	local v6

	if fFlagLuaAppSduiGameTileFeedback and props.menuKey then
		v6 = props.menuKey
	else
		v6 = `sdui-overflow-menu-{v5.current}`
	end

	local anchorPoint = props.anchorPoint or Vector2.new(0, 0)
	local position = props.position or UDim2.new(0, 0, 0, 0)
	local v7, v8

	if fFlagLuaAppSduiGameTileFeedback then
		v7 = props.hasOverflowButton == nil or props.hasOverflowButton
		v8 = props.shouldShowAnchor == nil or props.shouldShowAnchor
	end

	local v9

	if fFlagLuaAppSduiGameTileFeedback then
		v9 = React.useMemo(function()
			if props.includeMenuItemTelemetry then
				return addMenuItemTelemetry(props.items)
			end

			return props.items
		end, { props.items, props.includeMenuItemTelemetry })
	end

	local v11 = useBackButtonBinding((React.useCallback(function()
		getOverflowMenuSignalStore().closeMenu(v6)
	end, { v6 })))

	if not fFlagLuaAppSduiGameTileFeedback then
		v9 = props.items
	end

	local count = 0

	for k in v9 do
		count += 1
	end

	if count ~= #v9 then
		local v12 = {}

		for k, v13 in v9 do
			table.insert(v12, v13)
		end

		v9 = v12
	end

	if fFlagSduiOverflowMenuHideWhenEmpty and #v9 == 0 then
		return nil
	end

	local v12 = props.layoutOrder ~= nil

	if v12 then
		anchorPoint = nil
	end

	if v12 then
		position = nil
	end

	local v13 = {
		anchorPoint = anchorPoint,
		anchorPosition = position,
		menuItems = v9,
		menuKey = v6,
		buttonVariant = props.buttonVariant,
		buttonIconSize = props.buttonSize,
		buttonIcon = props.buttonIcon,
		buttonIconBackgroundStyle = props.buttonIconBackgroundStyle,
		menuItemSize = props.menuItemSize,
		popoverAlign = props.popoverAlign,
		popoverSide = props.popoverSide,
		menuWidth = props.menuWidth,
		hasOverflowButton = not fFlagLuaAppSduiGameTileFeedback or v7,
		shouldShowAnchor = not fFlagLuaAppSduiGameTileFeedback or v8,
		buttonIsCircular = props.buttonIsCircular,
		buttonTag = props.buttonTag,
		setFocusRef = 0,
		onMenuOpenChanged = 0,
		zIndex = 0
	}

	if fFlagLuaAppSduiGameTileFeedback and props.setFocusRef then
		v11 = props.setFocusRef
	end

	v13.setFocusRef = v11
	local v14 = if fFlagLuaAppSduiGameTileFeedback then props.onMenuOpenChanged else nil
	v13.onMenuOpenChanged = v14
	local v15 = if fFlagLuaAppSduiGameTileFeedback then props.zIndex else nil
	v13.zIndex = v15

	if v12 then
		return React.createElement(Foundation.View, {
			LayoutOrder = props.layoutOrder,
			tag = "auto-xy"
		}, {
			OverflowMenu = React.createElement(overflowMenu, v13)
		})
	end

	return React.createElement(overflowMenu, v13)
end

return React.memo(SduiOverflowMenu)
