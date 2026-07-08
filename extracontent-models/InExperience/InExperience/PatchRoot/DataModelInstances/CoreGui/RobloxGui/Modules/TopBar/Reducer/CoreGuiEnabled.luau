local CorePackages = game:GetService("CorePackages")
local RobloxGui = game:GetService("CoreGui"):WaitForChild("RobloxGui")
local Rodux = require(CorePackages.Packages.Rodux)
local Cryo = require(CorePackages.Packages.Cryo)
local ParentParent = script.Parent.Parent

if require(ParentParent.Flags.FFlagTopBarDeprecateCoreGuiRodux) then
	return nil
end

local Actions = ParentParent.Actions
local UpdateCoreGuiEnabled = require(Actions.UpdateCoreGuiEnabled)
local v8 = if not require(RobloxGui.Modules.Flags.FFlagMountCoreGuiBackpack) then {
	[Enum.CoreGuiType.PlayerList] = true,
	[Enum.CoreGuiType.Health] = true,
	[Enum.CoreGuiType.Backpack] = true,
	[Enum.CoreGuiType.Chat] = true,
	[Enum.CoreGuiType.EmotesMenu] = true
} else {
	[Enum.CoreGuiType.PlayerList] = true,
	[Enum.CoreGuiType.Health] = true,
	[Enum.CoreGuiType.Chat] = true,
	[Enum.CoreGuiType.EmotesMenu] = true
}

return (Rodux.createReducer(v8, {
	[UpdateCoreGuiEnabled.name] = function(p1, p2) -- line: 41
		-- upvalues: Cryo (copy)
		if p2.coreGuiType == Enum.CoreGuiType.All then
			local t1 = {}

			for k, _ in pairs(p1) do
				t1[k] = p2.enabled
			end

			return t1
		end

		return Cryo.Dictionary.join(p1, {
			[p2.coreGuiType] = p2.enabled
		})
	end
}))
