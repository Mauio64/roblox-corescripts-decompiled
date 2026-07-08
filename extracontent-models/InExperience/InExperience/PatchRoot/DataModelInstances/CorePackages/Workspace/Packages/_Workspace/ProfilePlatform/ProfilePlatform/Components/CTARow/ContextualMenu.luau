local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent

require(ProfilePlatform.Components.CTARow.Types)

local CoreGui = game:GetService("CoreGui")
local React = require(ProfilePlatformParent.React)
local Dash = require(ProfilePlatformParent.Dash)
local Foundation = require(ProfilePlatformParent.Foundation)
local useIsSpatial = require(ProfilePlatformParent.Responsive).useIsSpatial
local Menu = Foundation.Menu
local OverlayProvider = Foundation.OverlayProvider
local PopoverAlign = Foundation.Enums.PopoverAlign
local InputSize = Foundation.Enums.InputSize

local function getVROverlaySurfaceGui() -- line: 30
	-- upvalues: CoreGui (copy)
	local LuaAppScreenGui = CoreGui:FindFirstChild("LuaAppScreenGui")

	if LuaAppScreenGui then
		return (LuaAppScreenGui:FindFirstChild("MainAppScreen_SurfaceGui"))
	end

	return nil
end
local function convertToMenuItems(p1, p2: ((...any) -> ...any)) -- line: 38
	-- upvalues: Dash (copy)
	return Dash.map(p1, function(p3) -- line: 42
		-- upvalues: Dash (copy), p2 (copy)
		return {
			items = Dash.map(p3.items, function(p4) -- line: 44
				-- upvalues: p2 (copy)
				local displayValue = p4.displayValue

				return {
					id = p4.id,
					onActivated = function() -- line: 46
						-- upvalues: p2 (copy), p4 (copy)
						p2()
						p4.onActivated()
					end,
					isDisabled = p4.isDisabled,
					text = displayValue.text or "",
					icon = displayValue.icon
				}
			end)
		}
	end)
end
local function ContextualMenu(t1: {[any]: any}) -- line: 63
	-- upvalues: useIsSpatial (copy), React (copy), CoreGui (copy), convertToMenuItems (copy), OverlayProvider (copy), Menu (copy), PopoverAlign (copy), InputSize (copy)
	local v19 = useIsSpatial()
	local v20 = React.useMemo(function() -- line: 65
		-- upvalues: v19 (copy), CoreGui (copy)
		if v19 then
			local LuaAppScreenGui = CoreGui:FindFirstChild("LuaAppScreenGui")

			if LuaAppScreenGui then
				return (LuaAppScreenGui:FindFirstChild("MainAppScreen_SurfaceGui"))
			end

			return nil
		end

		return nil
	end, { v19 })
	local v21 = React.useMemo(function() -- line: 69
		-- upvalues: convertToMenuItems (copy), t1 (copy)
		return convertToMenuItems(t1.menuItems, t1.closeMenu)
	end, {
		t1.menuItems,
		t1.closeMenu
	})

	return (React.createElement(OverlayProvider, {
		gui = v20
	}, {
		Menu = React.createElement(Menu, {
			isOpen = t1.isOpen,
			align = t1.align or PopoverAlign.End,
			anchorRef = t1.anchorRef,
			items = v21,
			onPressedOutside = t1.closeMenu,
			ref = t1.menuRef,
			size = InputSize.Medium
		})
	}))
end

return ContextualMenu
