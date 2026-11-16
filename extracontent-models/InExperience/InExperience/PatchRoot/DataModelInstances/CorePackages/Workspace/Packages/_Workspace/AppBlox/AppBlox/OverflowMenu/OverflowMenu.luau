local AppBlox = script:FindFirstAncestor("AppBlox")
local parent = AppBlox.Parent

local BuilderIcons = require(parent.BuilderIcons)
local Cryo = require(parent.Cryo)
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local Foundation = require(parent.Foundation)
local React = require(parent.React)
local SharedFlags = require(parent.SharedFlags)

local ThreeDotsHorizontal = BuilderIcons.Icon.ThreeDotsHorizontal
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local useFocusNavigableSurfaceRegistryConnection = FocusNavigationUtils.useFocusNavigableSurfaceRegistryConnection
local ButtonVariant = Foundation.Enums.ButtonVariant
local IconButton = Foundation.IconButton
local IconSize = Foundation.Enums.IconSize
local InputSize = Foundation.Enums.InputSize
local PopoverAlign = Foundation.Enums.PopoverAlign
local PopoverSide = Foundation.Enums.PopoverSide
local Menu = Foundation.Menu
local View = Foundation.View

local getOverflowMenuSignalStore = require(AppBlox.OverflowMenu.getOverflowMenuSignalStore)
local useOverflowMenuOpen = require(AppBlox.OverflowMenu.useOverflowMenuOpen)
local FFlagLuaAppSduiGameTileFeedback = SharedFlags.FFlagLuaAppSduiGameTileFeedback

local function OverflowMenu(props)
	local menuKey = props.menuKey
	local ref = React.useRef(nil)
	local overflowMenuSignalStore = getOverflowMenuSignalStore()
	local v = useOverflowMenuOpen(menuKey)

	local onActivated = React.useCallback(function()
		overflowMenuSignalStore.toggleMenu(menuKey)

		if props.onMenuOpenChanged then
			props.onMenuOpenChanged(v)
		end
	end, { menuKey, overflowMenuSignalStore, v, props.onMenuOpenChanged })

	local onPressedOutside = React.useCallback(function()
		overflowMenuSignalStore.closeMenu(menuKey)

		if props.onMenuOpenChanged then
			props.onMenuOpenChanged(true)
		end
	end, { menuKey, overflowMenuSignalStore, props.onMenuOpenChanged })

	local items = React.useMemo(function()
		return Cryo.List.map(props.menuItems, function(data)
			return {
				icon = data.icon,
				id = data.id,
				text = data.text,
				onActivated = function()
					task.spawn(function()
						data.onActivated()
					end)
					overflowMenuSignalStore.closeMenu(menuKey)

					if props.onMenuOpenChanged then
						props.onMenuOpenChanged(true)
					end
				end
			}
		end)
	end, { props.menuItems, menuKey, overflowMenuSignalStore, props.onMenuOpenChanged })

	local ref2 = React.useRef(menuKey)
	React.useEffect(function()
		if ref2.current ~= menuKey and overflowMenuSignalStore then
			ref2.current = menuKey
			overflowMenuSignalStore.closeMenu(menuKey)
		end
	end, { menuKey, overflowMenuSignalStore })

	local state, setState = React.useState(nil)
	local ref3 = React.useCallback(function(p)
		setState(p)

		if props.setFocusRef then
			props.setFocusRef(p)
		end
	end, { props.setFocusRef })

	useFocusNavigableSurfaceRegistryConnection(state, FocusNavigableSurfaceIdentifierEnum.ContextualMenu, true)

	if not (props.shouldShowAnchor or v) then
		return nil
	end

	local createElement = React.createElement
	local fragment = React.Fragment
	local menuAnchor

	if props.hasOverflowButton and (props.shouldShowAnchor or v) then
		local createElement2 = React.createElement
		local v2 = {
			AnchorPoint = props.anchorPoint,
			Position = props.anchorPosition,
			ZIndex = 0,
			tag = 0,
			backgroundStyle = 0,
			ref = 0
		}
		local zIndex

		if FFlagLuaAppSduiGameTileFeedback then
			zIndex = props.zIndex
		end

		v2.ZIndex = zIndex
		v2.tag = props.buttonTag == nil and "auto-xy radius-circle" or props.buttonTag
		v2.backgroundStyle = props.buttonIconBackgroundStyle
		v2.ref = ref
		menuAnchor = createElement2(View, v2, {
			IconButton = React.createElement(IconButton, {
				icon = props.buttonIcon or ThreeDotsHorizontal,
				isCircular = props.buttonIsCircular == nil or props.buttonIsCircular,
				onActivated = onActivated,
				size = props.buttonIconSize or IconSize.Medium,
				variant = props.buttonVariant or ButtonVariant.Utility
			})
		})
	else
		local createElement2 = React.createElement
		local v2 = {
			AnchorPoint = props.anchorPoint,
			BackgroundTransparency = 1,
			Position = props.anchorPosition,
			Size = UDim2.fromScale(0, 0),
			ZIndex = 0,
			ref = 0
		}
		local zIndex

		if FFlagLuaAppSduiGameTileFeedback then
			zIndex = props.zIndex
		end

		v2.ZIndex = zIndex
		v2.ref = ref
		menuAnchor = createElement2("Frame", v2)
	end

	local overflowMenu

	if v then
		overflowMenu = React.createElement(Menu, {
			align = props.popoverAlign or PopoverAlign.End,
			isOpen = true,
			items = items,
			onPressedOutside = onPressedOutside,
			side = props.popoverSide or PopoverSide.Bottom,
			size = props.menuItemSize or InputSize.Medium,
			width = props.menuWidth,
			anchorRef = ref,
			ref = ref3
		})
	end

	return (createElement(fragment, nil, { MenuAnchor = menuAnchor, OverflowMenu = overflowMenu }))
end

return React.memo(OverflowMenu)
