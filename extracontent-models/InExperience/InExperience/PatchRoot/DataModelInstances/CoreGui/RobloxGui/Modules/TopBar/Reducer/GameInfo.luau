local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)
local Actions = script.Parent.Parent.Actions
local SetGameName = require(Actions.SetGameName)
local ParentParent = script.Parent.Parent

if require(ParentParent.Flags.FFlagTopBarDeprecateGameInfoRodux) then
	return nil
end

return Rodux.createReducer({
	name = RobloxTranslator:FormatByKey("CoreScripts.TopBar.GameNamePlaceHolder")
}, {
	[SetGameName.name] = function(_, p2) -- line: 22
		return {
			name = p2.gameName
		}
	end
})
