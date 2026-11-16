local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")

local Rodux = require(CorePackages.Packages.Rodux)

CoreGui:WaitForChild("RobloxGui")
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)

local Actions = script.Parent.Parent.Actions

local GameNameFetched = require(Actions.GameNameFetched)

local formatByKey = RobloxTranslator:FormatByKey("CoreScripts.AvatarEditorPrompts.GameNamePlaceHolder")

return Rodux.createReducer(formatByKey, {
	[GameNameFetched.name] = function(_, p)
		return p.gameName
	end
})
