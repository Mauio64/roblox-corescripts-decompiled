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
local v22 = game:DefineFastFlag("OverflowMenuRemoveCloseMenuChecks", false)
local FFlagSduiExperienceDetailsSupport = SharedFlags.FFlagSduiExperienceDetailsSupport

local function OverflowMenu(t1: {[any]: any}) -- line: 59
	-- upvalues: React (copy), v22 (copy), getOverflowMenuSignalStore (copy), useOverflowMenuOpen (copy), Cryo (copy), useFocusNavigableSurfaceRegistryConnection (copy), FocusNavigableSurfaceIdentifierEnum (copy), View (copy), FFlagSduiExperienceDetailsSupport (copy), IconButton (copy), ThreeDotsHorizontal (copy), IconSize (copy), ButtonVariant (copy), Menu (copy), PopoverAlign (copy), PopoverSide (copy), InputSize (copy)
	local menuKey = t1.menuKey
	local v27 = React.useRef(nil)
	local v28 = if not v22 then React.useRef(nil) else nil
	local v29 = getOverflowMenuSignalStore()
	local v30 = useOverflowMenuOpen(menuKey)
	local v31 = React.useCallback(function() -- line: 69
		-- upvalues: v30 (copy), v29 (copy), menuKey (copy), t1 (copy)
		local v39 = v30

		v29.toggleMenu(menuKey)

		if t1.onMenuOpenChanged then
			t1.onMenuOpenChanged(v39)
		end
	end, {
		menuKey,
		v29,
		v30,
		t1.onMenuOpenChanged
	})
	local v32 = React.useCallback(function() -- line: 85
		-- upvalues: v22 (copy), v28 (copy), t1 (copy), v29 (copy), menuKey (copy)
		if v22 or (v28.current == Enum.GuiState.Idle or not t1.hasOverflowButton or not t1.shouldShowAnchor) then
			v29.closeMenu(menuKey)

			if t1.onMenuOpenChanged then
				t1.onMenuOpenChanged(true)
			end
		end
	end, {
		if v22 then nil else t1.hasOverflowButton,
		if v22 then nil else t1.shouldShowAnchor,
		menuKey,
		v29,
		t1.onMenuOpenChanged
	})
	local v33 = React.useMemo(function() -- line: 111
		-- upvalues: Cryo (copy), t1 (copy), v29 (copy), menuKey (copy)
		return Cryo.List.map(t1.menuItems, function(p1) -- line: 112
			-- upvalues: v29 (copy), menuKey (copy), t1 (copy)
			return {
				icon = p1.icon,
				id = p1.id,
				text = p1.text,
				onActivated = function() -- line: 117
					-- upvalues: p1 (copy), v29 (copy), menuKey (copy), t1 (copy)
					task.spawn(function() -- line: 118
						-- upvalues: p1 (copy)
						p1.onActivated()
					end)
					v29.closeMenu(menuKey)

					if t1.onMenuOpenChanged then
						t1.onMenuOpenChanged(true)
					end
				end
			}
		end)
	end, {
		t1.menuItems,
		menuKey,
		v29,
		t1.onMenuOpenChanged
	})
	local v34 = React.useRef(menuKey)

	React.useEffect(function() -- line: 139
		-- upvalues: v34 (copy), menuKey (copy), v29 (copy)
		if v34.current ~= menuKey and v29 then
			v34.current = menuKey
			v29.closeMenu(menuKey)
		end
	end, {
		menuKey,
		v29
	})

	local v35 = nil

	if not v22 then
		v35 = React.useCallback(function() -- line: 148
			-- upvalues: v27 (copy), v28 (copy)
			if v27.current then
				v28.current = v27.current.GuiState
			end
		end, {})
	end

	local v36, v37 = React.useState(nil)
	local v38 = React.useCallback(function(p2) -- line: 156
		-- upvalues: v37 (copy), t1 (copy)
		v37(p2)

		if t1.setFocusRef then
			t1.setFocusRef(p2)
		end
	end, { t1.setFocusRef })

	useFocusNavigableSurfaceRegistryConnection(v36, FocusNavigableSurfaceIdentifierEnum.ContextualMenu, true)

	if t1.shouldShowAnchor or v30 then
		return (React.createElement(React.Fragment, nil, {
			MenuAnchor = if not t1.hasOverflowButton or not t1.shouldShowAnchor and not v30 then React.createElement("Frame", {
				BackgroundTransparency = 1,
				AnchorPoint = t1.anchorPoint,
				Position = t1.anchorPosition,
				Size = UDim2.fromScale(0, 0),
				ref = v27
			}) else React.createElement(View, {
				AnchorPoint = t1.anchorPoint,
				Position = t1.anchorPosition,
				onStateChanged = if not v22 then v35 else nil,
				tag = (not FFlagSduiExperienceDetailsSupport or t1.buttonTag == nil) and "auto-xy radius-circle" or t1.buttonTag,
				backgroundStyle = t1.buttonIconBackgroundStyle,
				ref = v27
			}, {
				IconButton = React.createElement(IconButton, {
					icon = t1.buttonIcon or ThreeDotsHorizontal,
					isCircular = not FFlagSduiExperienceDetailsSupport or (t1.buttonIsCircular == nil or t1.buttonIsCircular),
					onActivated = v31,
					size = t1.buttonIconSize or IconSize.Medium,
					variant = t1.buttonVariant or ButtonVariant.Utility
				})
			}),
			OverflowMenu = if not v30 then nil else React.createElement(Menu, {
				isOpen = true,
				align = t1.popoverAlign or PopoverAlign.End,
				items = v33,
				onPressedOutside = v32,
				side = t1.popoverSide or PopoverSide.Bottom,
				size = t1.menuItemSize or InputSize.Medium,
				width = t1.menuWidth,
				anchorRef = v27,
				ref = v38
			})
		}))
	end

	return nil
end

return React.memo(OverflowMenu)
