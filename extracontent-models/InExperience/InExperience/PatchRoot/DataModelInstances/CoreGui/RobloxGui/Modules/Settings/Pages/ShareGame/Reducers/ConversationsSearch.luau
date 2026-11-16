local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")

local ShareGame = CoreGui.RobloxGui.Modules.Settings.Pages.ShareGame

local AppCommonLib = require(CorePackages.Workspace.Packages.AppCommonLib)
local Immutable = AppCommonLib.Immutable

local ClosePage = require(ShareGame.Actions.ClosePage)
local SetSearchAreaActive = require(ShareGame.Actions.SetSearchAreaActive)
local SetSearchText = require(ShareGame.Actions.SetSearchText)

local v = { SearchAreaActive = false, SearchText = "" }

return function(p, data)
	p = p or v

	if data.type == SetSearchAreaActive.name then
		return (Immutable.Set(p, "SearchAreaActive", data.isActive))
	end

	if data.type == SetSearchText.name then
		return (Immutable.Set(p, "SearchText", data.searchText))
	end

	if data.type == ClosePage.name then
		p = v
	end

	return p
end
