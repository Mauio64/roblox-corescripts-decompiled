local AppBlox = script:FindFirstAncestor("AppBlox")
local AppBloxParent = AppBlox.Parent
local BuilderIcons = require(AppBloxParent.BuilderIcons)
local Cryo = require(AppBloxParent.Cryo)
local FocusNavigationUtils = require(AppBloxParent.FocusNavigationUtils)
local Foundation = require(AppBloxParent.Foundation)
local React = require(AppBloxParent.React)
local SharedFlags = require(AppBloxParent.SharedFlags)
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
local FFlagLuaAppGameTileOverflowMenuTelemetry = SharedFlags.FFlagLuaAppGameTileOverflowMenuTelemetry
local v23 = game:DefineFastFlag("OverflowMenuRemoveCloseMenuChecks", false)
local FFlagSduiExperienceDetailsSupport = SharedFlags.FFlagSduiExperienceDetailsSupport

local function OverflowMenu(t1: {[any]: any}) -- line: 60
	-- upvalues: React (copy), v23 (copy), getOverflowMenuSignalStore (copy), useOverflowMenuOpen (copy), FFlagLuaAppGameTileOverflowMenuTelemetry (copy), Cryo (copy), useFocusNavigableSurfaceRegistryConnection (copy), FocusNavigableSurfaceIdentifierEnum (copy), View (copy), FFlagSduiExperienceDetailsSupport (copy), IconButton (copy), ThreeDotsHorizontal (copy), IconSize (copy), ButtonVariant (copy), Menu (copy), PopoverAlign (copy), PopoverSide (copy), InputSize (copy)
	local menuKey = t1.menuKey
	local v28 = React.useRef(nil)
	local v29 = if not v23 then React.useRef(nil) else nil
	local v30 = getOverflowMenuSignalStore()
	local v31 = useOverflowMenuOpen(menuKey)
	local v32 = React.useCallback(function() -- line: 70
		-- upvalues: FFlagLuaAppGameTileOverflowMenuTelemetry (copy), v31 (copy), v30 (copy), menuKey (copy), t1 (copy)
		local v40 = if not FFlagLuaAppGameTileOverflowMenuTelemetry then nil else v31

		v30.toggleMenu(menuKey)

		if FFlagLuaAppGameTileOverflowMenuTelemetry and t1.onMenuOpenChanged then
			t1.onMenuOpenChanged(v40)
		end
	end, {
		menuKey,
		v30,
		if not FFlagLuaAppGameTileOverflowMenuTelemetry then nil else v31,
		if not FFlagLuaAppGameTileOverflowMenuTelemetry then nil else t1.onMenuOpenChanged
	})
	local v33 = React.useCallback(function() -- line: 86
		-- upvalues: v23 (copy), v29 (copy), t1 (copy), v30 (copy), menuKey (copy), FFlagLuaAppGameTileOverflowMenuTelemetry (copy)
		if v23 or (v29.current == Enum.GuiState.Idle or not t1.hasOverflowButton or not t1.shouldShowAnchor) then
			v30.closeMenu(menuKey)

			if FFlagLuaAppGameTileOverflowMenuTelemetry and t1.onMenuOpenChanged then
				t1.onMenuOpenChanged(true)
			end
		end
	end, {
		if v23 then nil else t1.hasOverflowButton,
		if v23 then nil else t1.shouldShowAnchor,
		menuKey,
		v30,
		if not FFlagLuaAppGameTileOverflowMenuTelemetry then nil else t1.onMenuOpenChanged
	})
	local v34 = React.useMemo(function() -- line: 112
		-- upvalues: Cryo (copy), t1 (copy), v30 (copy), menuKey (copy), FFlagLuaAppGameTileOverflowMenuTelemetry (copy)
		return Cryo.List.map(t1.menuItems, function(p1) -- line: 113
			-- upvalues: v30 (copy), menuKey (copy), FFlagLuaAppGameTileOverflowMenuTelemetry (copy), t1 (copy)
			return {
				icon = p1.icon,
				id = p1.id,
				text = p1.text,
				onActivated = function() -- line: 118
					-- upvalues: p1 (copy), v30 (copy), menuKey (copy), FFlagLuaAppGameTileOverflowMenuTelemetry (copy), t1 (copy)
					task.spawn(function() -- line: 119
						-- upvalues: p1 (copy)
						p1.onActivated()
					end)
					v30.closeMenu(menuKey)

					if FFlagLuaAppGameTileOverflowMenuTelemetry and t1.onMenuOpenChanged then
						t1.onMenuOpenChanged(true)
					end
				end
			}
		end)
	end, {
		t1.menuItems,
		menuKey,
		v30,
		if not FFlagLuaAppGameTileOverflowMenuTelemetry then nil else t1.onMenuOpenChanged
	})
	local v35 = React.useRef(menuKey)

	React.useEffect(function() -- line: 140
		-- upvalues: v35 (copy), menuKey (copy), v30 (copy)
		if v35.current ~= menuKey and v30 then
			v35.current = menuKey
			v30.closeMenu(menuKey)
		end
	end, {
		menuKey,
		v30
	})

	local v36 = nil

	if not v23 then
		v36 = React.useCallback(function() -- line: 149
			-- upvalues: v28 (copy), v29 (copy)
			if v28.current then
				v29.current = v28.current.GuiState
			end
		end, {})
	end

	local v37, v38 = React.useState(nil)
	local v39 = React.useCallback(function(p2) -- line: 157
		-- upvalues: v38 (copy), t1 (copy)
		v38(p2)

		if t1.setFocusRef then
			t1.setFocusRef(p2)
		end
	end, { t1.setFocusRef })

	useFocusNavigableSurfaceRegistryConnection(v37, FocusNavigableSurfaceIdentifierEnum.ContextualMenu, true)

	if t1.shouldShowAnchor or v31 then
		return (React.createElement(React.Fragment, nil, {
			MenuAnchor = if not t1.hasOverflowButton or not t1.shouldShowAnchor and not v31 then React.createElement("Frame", {
				BackgroundTransparency = 1,
				AnchorPoint = t1.anchorPoint,
				Position = t1.anchorPosition,
				Size = UDim2.fromScale(0, 0),
				ref = v28
			}) else React.createElement(View, {
				AnchorPoint = t1.anchorPoint,
				Position = t1.anchorPosition,
				onStateChanged = if not v23 then v36 else nil,
				tag = (not FFlagSduiExperienceDetailsSupport or t1.buttonTag == nil) and "auto-xy radius-circle" or t1.buttonTag,
				backgroundStyle = t1.buttonIconBackgroundStyle,
				ref = v28
			}, {
				IconButton = React.createElement(IconButton, {
					icon = t1.buttonIcon or ThreeDotsHorizontal,
					isCircular = not FFlagSduiExperienceDetailsSupport or (t1.buttonIsCircular == nil or t1.buttonIsCircular),
					onActivated = v32,
					size = t1.buttonIconSize or IconSize.Medium,
					variant = t1.buttonVariant or ButtonVariant.Utility
				})
			}),
			OverflowMenu = if not v31 then nil else React.createElement(Menu, {
				isOpen = true,
				align = t1.popoverAlign or PopoverAlign.End,
				items = v34,
				onPressedOutside = v33,
				side = t1.popoverSide or PopoverSide.Bottom,
				size = t1.menuItemSize or InputSize.Medium,
				width = t1.menuWidth,
				anchorRef = v28,
				ref = v39
			})
		}))
	end

	return nil
end

return React.memo(OverflowMenu)
