require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/CTARow/Types")

local CoreGui = game:GetService("CoreGui")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")
local Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Dash")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Foundation")
local useIsSpatial = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Responsive").useIsSpatial
local menu = Foundation.Menu
local overlayProvider = Foundation.OverlayProvider
local popoverAlign = Foundation.Enums.PopoverAlign
local inputSize = Foundation.Enums.InputSize

local function getVROverlaySurfaceGui()
	local luaAppScreenGui = CoreGui:FindFirstChild("LuaAppScreenGui")

	if luaAppScreenGui then
		return luaAppScreenGui:FindFirstChild("MainAppScreen_SurfaceGui")
	end

	return nil
end

local function convertToMenuItems(menuItems, closeMenu)
	return Dash.map(menuItems, function(p2)
		return {
			items = Dash.map(p2.items, function(data)
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
	local v5 = useIsSpatial()
	local v6 = React.useMemo(function()
		if not v5 then
			return nil
		end

		local luaAppScreenGui = CoreGui:FindFirstChild("LuaAppScreenGui")

		if luaAppScreenGui then
			return (luaAppScreenGui:FindFirstChild("MainAppScreen_SurfaceGui"))
		end

		return nil
	end, { v5 })

	local v7 = React.useMemo(function()
		return convertToMenuItems(props.menuItems, props.closeMenu)
	end, { props.menuItems, props.closeMenu })

	return React.createElement(overlayProvider, { gui = v6 }, {
		Menu = React.createElement(menu, {
			isOpen = props.isOpen,
			align = props.align or popoverAlign.End,
			anchorRef = props.anchorRef,
			items = v7,
			onPressedOutside = props.closeMenu,
			ref = props.menuRef,
			size = inputSize.Medium
		})
	})
end

return ContextualMenu
