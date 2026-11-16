local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local CoreGui = game:GetService("CoreGui")
local parent = ProfilePlatform.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Responsive = require(parent.Responsive)
local useIsSpatial = Responsive.useIsSpatial
local SharedFlags = require(parent.SharedFlags)
local FFlagProfileFixMenuNavigation = SharedFlags.FFlagProfileFixMenuNavigation

local PopoverSide = Foundation.Enums.PopoverSide
local PopoverAlign = Foundation.Enums.PopoverAlign
local InputSize = Foundation.Enums.InputSize
local Menu = Foundation.Menu
local OverlayProvider = Foundation.OverlayProvider

local function getVROverlaySurfaceGui()
	if not FFlagProfileFixMenuNavigation then
		return nil
	end

	local luaAppScreenGui = CoreGui:FindFirstChild("LuaAppScreenGui")

	if luaAppScreenGui then
		return (luaAppScreenGui:FindFirstChild("MainAppScreen_SurfaceGui"))
	end

	return nil
end

local function ProfileContextualMenu(props)
	local mainAppScreen_SurfaceGui

	if FFlagProfileFixMenuNavigation and useIsSpatial() and FFlagProfileFixMenuNavigation then
		local luaAppScreenGui = CoreGui:FindFirstChild("LuaAppScreenGui")

		if luaAppScreenGui then
			mainAppScreen_SurfaceGui = luaAppScreenGui:FindFirstChild("MainAppScreen_SurfaceGui")
		end
	end

	local side

	if props.screenSize.Y / 2 < props.rootElementPosition.Y then
		side = PopoverSide.Top
	else
		side = PopoverSide.Bottom
	end

	if side == PopoverSide.Top then
		local v = props.screenSize.X / props.screenSize.Y
		local v2 = -(props.screenSize.Y - props.rootElementPosition.Y) + -20
		local v3

		if v >= 1.3 then
			v3 = v < 1.7
		else
			v3 = false
		end

		if props.screenSize.Y > 700 and not v3 then
			v2 += props.screenSize.Y * 0.05
		end
	else
		local _ = props.rootElementPosition.Y + 60
	end

	if FFlagProfileFixMenuNavigation then
		local createElement = React.createElement

		local createElement2 = React.createElement
		local v = {
			align = PopoverAlign.End,
			anchorRef = props.rootElementRef,
			isOpen = props.isOpen == nil or props.isOpen,
			items = props.buttonProps,
			onPressedOutside = props.onDismiss,
			side = side,
			size = InputSize.Medium,
			ref = 0
		}
		local ref

		if FFlagProfileFixMenuNavigation then
			ref = props.menuRef
		end

		v.ref = ref
		return (createElement(OverlayProvider, { gui = mainAppScreen_SurfaceGui }, {
			Menu = createElement2(Menu, v)
		}))
	else
		local createElement = React.createElement
		local v = {
			align = PopoverAlign.End,
			anchorRef = props.rootElementRef,
			isOpen = props.isOpen == nil or props.isOpen,
			items = props.buttonProps,
			onPressedOutside = props.onDismiss,
			side = side,
			size = InputSize.Medium,
			ref = 0
		}
		local ref

		if FFlagProfileFixMenuNavigation then
			ref = props.menuRef
		end

		v.ref = ref
		return (createElement(Menu, v))
	end
end

return ProfileContextualMenu
