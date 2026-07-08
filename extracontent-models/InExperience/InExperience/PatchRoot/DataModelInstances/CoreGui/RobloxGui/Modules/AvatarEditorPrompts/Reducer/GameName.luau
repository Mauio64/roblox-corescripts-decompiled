local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local Rodux = require(CorePackages.Packages.Rodux)

CoreGui:WaitForChild("RobloxGui")

local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)
local Actions = script.Parent.Parent.Actions
local GameNameFetched = require(Actions.GameNameFetched)
local v7 = RobloxTranslator:FormatByKey("CoreScripts.AvatarEditorPrompts.GameNamePlaceHolder")

return Rodux.createReducer(v7, {
	[GameNameFetched.name] = function(_, p2) -- line: 16
		return p2.gameName
	end
})
