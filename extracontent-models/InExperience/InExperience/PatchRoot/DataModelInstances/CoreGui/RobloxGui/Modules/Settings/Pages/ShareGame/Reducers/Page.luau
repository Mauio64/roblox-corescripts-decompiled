local CorePackages = game:GetService("CorePackages")

local CoreGui = game:GetService("CoreGui")
local ShareGame = CoreGui.RobloxGui.Modules.Settings.Pages.ShareGame

local AppCommonLib = require(CorePackages.Workspace.Packages.AppCommonLib)
local Immutable = AppCommonLib.Immutable
local Constants = require(ShareGame.Constants)
local OpenPage = require(ShareGame.Actions.OpenPage)
local ClosePage = require(ShareGame.Actions.ClosePage)

return function(p, p2)
	p = p or { IsOpen = false, Route = Constants.PageRoute.NONE }

	if p2.type == OpenPage.name then
		return (Immutable.JoinDictionaries(p, {
			IsOpen = true,
			Route = p2.route or Constants.PageRoute.NONE
		}))
	end

	if p2.type == ClosePage.name then
		p = Immutable.JoinDictionaries(p, {
			IsOpen = false,
			Route = p2.route or Constants.PageRoute.NONE
		})
	end

	return p
end
