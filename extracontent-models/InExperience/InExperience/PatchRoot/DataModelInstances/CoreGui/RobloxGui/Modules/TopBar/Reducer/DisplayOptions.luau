local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)
local Cryo = require(CorePackages.Packages.Cryo)

local parent = script.Parent.Parent

local FFlagTopBarDeprecateDisplayOptionsRodux = require(parent.Flags.FFlagTopBarDeprecateDisplayOptionsRodux)

if FFlagTopBarDeprecateDisplayOptionsRodux then
	return nil
end

local actions = parent.Actions
local SetMenuOpen = require(actions.SetMenuOpen)
local SetTopBarEnabled = require(actions.SetTopBarEnabled)
local SetSmallTouchDevice = require(actions.SetSmallTouchDevice)
local SetScreenSize = require(actions.SetScreenSize)
local SetKeepOutArea = require(actions.SetKeepOutArea)
local RemoveKeepOutArea = require(actions.RemoveKeepOutArea)
require(actions.SetInputType)
local SetInspectMenuOpen = require(actions.SetInspectMenuOpen)
local SetGamepadMenuOpen = require(actions.SetGamepadMenuOpen)
local SetGamepadNavigationDialogOpen = require(actions.SetGamepadNavigationDialogOpen)
local FFlagGamepadNavigationDialogABTest = require(script.Parent.Parent.Flags.FFlagGamepadNavigationDialogABTest)

local CoreGuiCommon = require(CorePackages.Workspace.Packages.CoreGuiCommon)
local FFlagTopBarSignalizeMenuOpen = CoreGuiCommon.Flags.FFlagTopBarSignalizeMenuOpen
local FFlagTopBarSignalizeKeepOutAreas = CoreGuiCommon.Flags.FFlagTopBarSignalizeKeepOutAreas
local FFlagTopBarSignalizeScreenSize = CoreGuiCommon.Flags.FFlagTopBarSignalizeScreenSize

local Constants = require(parent.Constants)
local InputType = Constants.InputType

local CoreGui = game:GetService("CoreGui")
CoreGui:WaitForChild("RobloxGui")

local v = {
	menuOpen = false,
	inspectMenuOpen = false,
	topbarEnabled = true,
	isSmallTouchDevice = false,
	screenSize = Vector2.new(0, 0),
	isGamepadMenuOpen = false,
	isGamepadNavigationDialogOpen = not FFlagGamepadNavigationDialogABTest and nil,
	keepOutAreas = {}
}

return (Rodux.createReducer(v, {
	[FFlagTopBarSignalizeMenuOpen and "" or SetMenuOpen.name] = not FFlagTopBarSignalizeMenuOpen and function(p, p2)
		local isGamepadMenuOpen = p.isGamepadMenuOpen

		if not p.menuOpen and p2.menuOpen then
			isGamepadMenuOpen = false
		end

		return Cryo.Dictionary.join(p, {
			menuOpen = p2.menuOpen,
			isGamepadMenuOpen = isGamepadMenuOpen
		})
	end or nil,
	[SetTopBarEnabled.name] = function(p, p2)
		return Cryo.Dictionary.join(p, { topbarEnabled = p2.enabled })
	end,
	[SetSmallTouchDevice.name] = function(p, p2)
		return Cryo.Dictionary.join(p, { isSmallTouchDevice = p2.isSmallTouchDevice })
	end,
	[FFlagTopBarSignalizeScreenSize and "" or SetScreenSize.name] = not FFlagTopBarSignalizeScreenSize and function(p, p2)
		return Cryo.Dictionary.join(p, { screenSize = p2.screenSize })
	end or nil,
	[FFlagTopBarSignalizeMenuOpen and "" or SetInspectMenuOpen.name] = not FFlagTopBarSignalizeMenuOpen and function(p, p2)
		return Cryo.Dictionary.join(p, { inspectMenuOpen = p2.inspectMenuOpen })
	end or nil,
	[SetGamepadMenuOpen.name] = function(p, p2)
		return Cryo.Dictionary.join(p, {
			isGamepadMenuOpen = p2.open,
			isGamepadNavigationDialogOpen = not FFlagGamepadNavigationDialogABTest and nil
		})
	end,
	[SetGamepadNavigationDialogOpen.name] = FFlagGamepadNavigationDialogABTest and function(p, p2)
		return Cryo.Dictionary.join(p, { isGamepadNavigationDialogOpen = p2.open })
	end or nil,
	[FFlagTopBarSignalizeKeepOutAreas and "" or SetKeepOutArea.name] = not FFlagTopBarSignalizeKeepOutAreas and function(p, data)
		local clone = table.clone(p.keepOutAreas)
		clone[data.id] = { size = data.size, position = data.position }

		return Cryo.Dictionary.join(p, { keepOutAreas = clone })
	end or nil,
	[FFlagTopBarSignalizeKeepOutAreas and "" or RemoveKeepOutArea.name] = not FFlagTopBarSignalizeKeepOutAreas and function(p, p2)
		local clone = table.clone(p.keepOutAreas)
		clone[p2.id] = nil

		return Cryo.Dictionary.join(p, { keepOutAreas = clone })
	end or nil
}))
