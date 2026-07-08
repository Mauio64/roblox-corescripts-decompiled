local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local ShareGame = CoreGui.RobloxGui.Modules.Settings.Pages.ShareGame
local Immutable = require(CorePackages.Workspace.Packages.AppCommonLib).Immutable
local ClosePage = require(ShareGame.Actions.ClosePage)
local SetSearchAreaActive = require(ShareGame.Actions.SetSearchAreaActive)
local SetSearchText = require(ShareGame.Actions.SetSearchText)
local t1 = {
	SearchAreaActive = false,
	SearchText = ""
}

return function(p1, p2) -- line: 19
	-- upvalues: t1 (copy), SetSearchAreaActive (copy), Immutable (copy), SetSearchText (copy), ClosePage (copy)
	local v11 = p1 or t1

	if p2.type == SetSearchAreaActive.name then
		return (Immutable.Set(v11, "SearchAreaActive", p2.isActive))
	end

	if p2.type == SetSearchText.name then
		return (Immutable.Set(v11, "SearchText", p2.searchText))
	end

	if p2.type == ClosePage.name then
		v11 = t1
	end

	return v11
end
