local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")

local Rodux = require(CorePackages.Packages.Rodux)
local Cryo = require(CorePackages.Packages.Cryo)

local parent = script.Parent.Parent

local FFlagTopBarDeprecateCoreGuiRodux = require(parent.Flags.FFlagTopBarDeprecateCoreGuiRodux)

if FFlagTopBarDeprecateCoreGuiRodux then
	return nil
end

local actions = parent.Actions
local UpdateCoreGuiEnabled = require(actions.UpdateCoreGuiEnabled)
local FFlagMountCoreGuiBackpack = require(RobloxGui.Modules.Flags.FFlagMountCoreGuiBackpack)
local set

if FFlagMountCoreGuiBackpack then
	set = {}
	set[Enum.CoreGuiType.PlayerList] = true
	set[Enum.CoreGuiType.Health] = true
else
	set = {}
	set[Enum.CoreGuiType.PlayerList] = true
	set[Enum.CoreGuiType.Health] = true
	set[Enum.CoreGuiType.Backpack] = true
end

set[Enum.CoreGuiType.Chat] = true
set[Enum.CoreGuiType.EmotesMenu] = true

return (Rodux.createReducer(set, {
	[UpdateCoreGuiEnabled.name] = function(items, p)
		if p.coreGuiType == Enum.CoreGuiType.All then
			local enableds = {}

			for k, _ in pairs(items) do
				enableds[k] = p.enabled
			end

			return enableds
		end

		return Cryo.Dictionary.join(items, { [p.coreGuiType] = p.enabled })
	end
}))
