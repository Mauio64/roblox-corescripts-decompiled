local BuilderIcons = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/BuilderIcons")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/Cryo")
local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/FocusNavigationUtils")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/React")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/SharedFlags")

local threeDotsHorizontal = BuilderIcons.Icon.ThreeDotsHorizontal
local focusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local useFocusNavigableSurfaceRegistryConnection = FocusNavigationUtils.useFocusNavigableSurfaceRegistryConnection
local buttonVariant = Foundation.Enums.ButtonVariant
local iconButton = Foundation.IconButton
local iconSize = Foundation.Enums.IconSize
local inputSize = Foundation.Enums.InputSize
local popoverAlign = Foundation.Enums.PopoverAlign
local popoverSide = Foundation.Enums.PopoverSide
local menu = Foundation.Menu
local view = Foundation.View

local getOverflowMenuSignalStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/AppBlox/OverflowMenu/getOverflowMenuSignalStore")
local useOverflowMenuOpen = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/AppBlox/OverflowMenu/useOverflowMenuOpen")
local fFlagLuaAppSduiGameTileFeedback = SharedFlags.FFlagLuaAppSduiGameTileFeedback

local function OverflowMenu(props)
	local menuKey = props.menuKey
	local ref = React.useRef(nil)
	local v5 = getOverflowMenuSignalStore()
	local v6 = useOverflowMenuOpen(menuKey)

	local v7 = React.useCallback(function()
		local v8 = v6
		v5.toggleMenu(menuKey)

		if props.onMenuOpenChanged then
			props.onMenuOpenChanged(v8)
		end
	end, { menuKey, v5, v6, props.onMenuOpenChanged })

	local v8 = React.useCallback(function()
		v5.closeMenu(menuKey)

		if props.onMenuOpenChanged then
			props.onMenuOpenChanged(true)
		end
	end, { menuKey, v5, props.onMenuOpenChanged })

	local v9 = React.useMemo(function()
		return Cryo.List.map(props.menuItems, function(data)
			return {
				icon = data.icon,
				id = data.id,
				text = data.text,
				onActivated = function()
					task.spawn(function()
						data.onActivated()
					end)
					v5.closeMenu(menuKey)

					if props.onMenuOpenChanged then
						props.onMenuOpenChanged(true)
					end
				end
			}
		end)
	end, { props.menuItems, menuKey, v5, props.onMenuOpenChanged })

	local ref2 = React.useRef(menuKey)
	React.useEffect(function()
		if ref2.current ~= menuKey and v5 then
			ref2.current = menuKey
			v5.closeMenu(menuKey)
		end
	end, { menuKey, v5 })

	local state, setState = React.useState(nil)
	local v10 = React.useCallback(function(p2)
		setState(p2)

		if props.setFocusRef then
			props.setFocusRef(p2)
		end
	end, { props.setFocusRef })

	useFocusNavigableSurfaceRegistryConnection(
		state,
		focusNavigableSurfaceIdentifierEnum.ContextualMenu,
		true
	)

	if not (props.shouldShowAnchor or v6) then
		return nil
	end

	local createElement = React.createElement
	local fragment = React.Fragment
	local v13

	if props.hasOverflowButton and (props.shouldShowAnchor or v6) then
		local createElement2 = React.createElement
		local v15 = {
			AnchorPoint = props.anchorPoint,
			Position = props.anchorPosition,
			ZIndex = 0,
			tag = 0,
			backgroundStyle = 0,
			ref = 0
		}
		local v16 = if fFlagLuaAppSduiGameTileFeedback then props.zIndex else nil
		v15.ZIndex = v16
		v15.tag = props.buttonTag == nil and "auto-xy radius-circle" or props.buttonTag
		v15.backgroundStyle = props.buttonIconBackgroundStyle
		v15.ref = ref
		v13 = createElement2(view, v15, {
			IconButton = React.createElement(iconButton, {
				icon = props.buttonIcon or threeDotsHorizontal,
				isCircular = props.buttonIsCircular == nil or props.buttonIsCircular,
				onActivated = v7,
				size = props.buttonIconSize or iconSize.Medium,
				variant = props.buttonVariant or buttonVariant.Utility
			})
		})
	else
		local createElement2 = React.createElement
		local v15 = {
			AnchorPoint = props.anchorPoint,
			BackgroundTransparency = 1,
			Position = props.anchorPosition,
			Size = UDim2.fromScale(0, 0),
			ZIndex = 0,
			ref = 0
		}
		local v16 = if fFlagLuaAppSduiGameTileFeedback then props.zIndex else nil
		v15.ZIndex = v16
		v15.ref = ref
		v13 = createElement2("Frame", v15)
	end

	local v14 = if v6 then React.createElement(menu, {
		align = props.popoverAlign or popoverAlign.End,
		isOpen = true,
		items = v9,
		onPressedOutside = v8,
		side = props.popoverSide or popoverSide.Bottom,
		size = props.menuItemSize or inputSize.Medium,
		width = props.menuWidth,
		anchorRef = ref,
		ref = v10
	}) else nil
	return (createElement(fragment, nil, { MenuAnchor = v13, OverflowMenu = v14 }))
end

return React.memo(OverflowMenu)
