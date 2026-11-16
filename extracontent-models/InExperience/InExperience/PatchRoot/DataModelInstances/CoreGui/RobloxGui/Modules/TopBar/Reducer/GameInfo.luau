local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)

local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)

local Actions = script.Parent.Parent.Actions

local SetGameName = require(Actions.SetGameName)

local parent = script.Parent.Parent
local FFlagTopBarDeprecateGameInfoRodux = require(parent.Flags.FFlagTopBarDeprecateGameInfoRodux)

if FFlagTopBarDeprecateGameInfoRodux then
	return nil
end

return Rodux.createReducer({
	name = RobloxTranslator:FormatByKey("CoreScripts.TopBar.GameNamePlaceHolder")
}, {
	[SetGameName.name] = function(_, p)
		return { name = p.gameName }
	end
})
