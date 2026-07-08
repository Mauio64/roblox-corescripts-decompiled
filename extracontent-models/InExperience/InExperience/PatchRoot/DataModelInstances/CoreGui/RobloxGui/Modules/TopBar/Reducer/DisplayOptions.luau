local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local Cryo = require(CorePackages.Packages.Cryo)
local ParentParent = script.Parent.Parent

if require(ParentParent.Flags.FFlagTopBarDeprecateDisplayOptionsRodux) then
	return nil
end

local Actions = ParentParent.Actions
local SetMenuOpen = require(Actions.SetMenuOpen)
local SetTopBarEnabled = require(Actions.SetTopBarEnabled)
local SetSmallTouchDevice = require(Actions.SetSmallTouchDevice)
local SetScreenSize = require(Actions.SetScreenSize)
local SetKeepOutArea = require(Actions.SetKeepOutArea)
local RemoveKeepOutArea = require(Actions.RemoveKeepOutArea)

require(Actions.SetInputType)

local SetInspectMenuOpen = require(Actions.SetInspectMenuOpen)
local SetGamepadMenuOpen = require(Actions.SetGamepadMenuOpen)
local SetGamepadNavigationDialogOpen = require(Actions.SetGamepadNavigationDialogOpen)
local FFlagGamepadNavigationDialogABTest = require(script.Parent.Parent.Flags.FFlagGamepadNavigationDialogABTest)
local CoreGuiCommon = require(CorePackages.Workspace.Packages.CoreGuiCommon)
local FFlagTopBarSignalizeMenuOpen = CoreGuiCommon.Flags.FFlagTopBarSignalizeMenuOpen
local FFlagTopBarSignalizeKeepOutAreas = CoreGuiCommon.Flags.FFlagTopBarSignalizeKeepOutAreas
local FFlagTopBarSignalizeScreenSize = CoreGuiCommon.Flags.FFlagTopBarSignalizeScreenSize
local _ = require(ParentParent.Constants).InputType

game:GetService("CoreGui"):WaitForChild("RobloxGui")

local t1 = {
	menuOpen = false,
	inspectMenuOpen = false,
	topbarEnabled = true,
	isSmallTouchDevice = false,
	isGamepadMenuOpen = false,
	screenSize = Vector2.new(0, 0),
	isGamepadNavigationDialogOpen = not FFlagGamepadNavigationDialogABTest and nil,
	keepOutAreas = {}
}

return (Rodux.createReducer(t1, {
	[if not FFlagTopBarSignalizeMenuOpen then SetMenuOpen.name else ""] = not FFlagTopBarSignalizeMenuOpen and function(p1, p2) -- line: 51
		-- upvalues: Cryo (copy)
		local isGamepadMenuOpen = p1.isGamepadMenuOpen

		if not p1.menuOpen and p2.menuOpen then
			isGamepadMenuOpen = false
		end

		return Cryo.Dictionary.join(p1, {
			menuOpen = p2.menuOpen,
			isGamepadMenuOpen = isGamepadMenuOpen
		})
	end or nil,
	[SetTopBarEnabled.name] = function(p3, p4) -- line: 64
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p3, {
			topbarEnabled = p4.enabled
		})
	end,
	[SetSmallTouchDevice.name] = function(p5, p6) -- line: 70
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p5, {
			isSmallTouchDevice = p6.isSmallTouchDevice
		})
	end,
	[if not FFlagTopBarSignalizeScreenSize then SetScreenSize.name else ""] = not FFlagTopBarSignalizeScreenSize and function(p7, p8) -- line: 76
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p7, {
			screenSize = p8.screenSize
		})
	end or nil,
	[if not FFlagTopBarSignalizeMenuOpen then SetInspectMenuOpen.name else ""] = not FFlagTopBarSignalizeMenuOpen and function(p9, p10) -- line: 82
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p9, {
			inspectMenuOpen = p10.inspectMenuOpen
		})
	end or nil,
	[SetGamepadMenuOpen.name] = function(p11, p12) -- line: 88
		-- upvalues: Cryo (copy), FFlagGamepadNavigationDialogABTest (copy)
		return Cryo.Dictionary.join(p11, {
			isGamepadMenuOpen = p12.open,
			isGamepadNavigationDialogOpen = not FFlagGamepadNavigationDialogABTest and nil
		})
	end,
	[SetGamepadNavigationDialogOpen.name] = if not FFlagGamepadNavigationDialogABTest then nil else function(p13, p14) -- line: 96
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p13, {
			isGamepadNavigationDialogOpen = p14.open
		})
	end,
	[if not FFlagTopBarSignalizeKeepOutAreas then SetKeepOutArea.name else ""] = not FFlagTopBarSignalizeKeepOutAreas and function(p15, p16) -- line: 103
		-- upvalues: Cryo (copy)
		local v39 = table.clone(p15.keepOutAreas)

		v39[p16.id] = {
			size = p16.size,
			position = p16.position
		}

		return Cryo.Dictionary.join(p15, {
			keepOutAreas = v39
		})
	end or nil,
	[if not FFlagTopBarSignalizeKeepOutAreas then RemoveKeepOutArea.name else ""] = not FFlagTopBarSignalizeKeepOutAreas and function(p17, p18) -- line: 115
		-- upvalues: Cryo (copy)
		local v42 = table.clone(p17.keepOutAreas)

		v42[p18.id] = nil

		return Cryo.Dictionary.join(p17, {
			keepOutAreas = v42
		})
	end or nil
}))
