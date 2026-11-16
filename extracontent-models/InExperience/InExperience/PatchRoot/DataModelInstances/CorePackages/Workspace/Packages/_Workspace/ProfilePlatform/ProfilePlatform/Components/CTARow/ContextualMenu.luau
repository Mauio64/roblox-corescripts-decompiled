local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent
require(ProfilePlatform.Components.CTARow.Types)

local CoreGui = game:GetService("CoreGui")

local React = require(parent.React)
local Dash = require(parent.Dash)
local Foundation = require(parent.Foundation)
local Responsive = require(parent.Responsive)
local useIsSpatial = Responsive.useIsSpatial
local Menu = Foundation.Menu
local OverlayProvider = Foundation.OverlayProvider
local PopoverAlign = Foundation.Enums.PopoverAlign
local InputSize = Foundation.Enums.InputSize

local function getVROverlaySurfaceGui() -- 1 equivalent call inferred from this helper
	local luaAppScreenGui = CoreGui:FindFirstChild("LuaAppScreenGui")

	if luaAppScreenGui then
		return (luaAppScreenGui:FindFirstChild("MainAppScreen_SurfaceGui"))
	end

	return nil
end

local function convertToMenuItems(menuItems, closeMenu)
	return Dash.map(menuItems, function(p)
		return {
			items = Dash.map(p.items, function(data)
				local displayValue = data.displayValue
				local function onActivated()
					closeMenu()
					data.onActivated()
				end
				return {
					id = data.id,
					onActivated = onActivated,
					isDisabled = data.isDisabled,
					text = displayValue.text or "",
					icon = displayValue.icon
				}
			end)
		}
	end)
end

local function ContextualMenu(props)
	local v = useIsSpatial()
	local gui = React.useMemo(function()
		if not v then
			return nil
		end

		return getVROverlaySurfaceGui() -- inferred equivalent call
	end, { v })

	local items = React.useMemo(function()
		return convertToMenuItems(props.menuItems, props.closeMenu)
	end, { props.menuItems, props.closeMenu })

	return (React.createElement(OverlayProvider, { gui = gui }, {
		Menu = React.createElement(Menu, {
			isOpen = props.isOpen,
			align = props.align or PopoverAlign.End,
			anchorRef = props.anchorRef,
			items = items,
			onPressedOutside = props.closeMenu,
			ref = props.menuRef,
			size = InputSize.Medium
		})
	}))
end

return ContextualMenu
