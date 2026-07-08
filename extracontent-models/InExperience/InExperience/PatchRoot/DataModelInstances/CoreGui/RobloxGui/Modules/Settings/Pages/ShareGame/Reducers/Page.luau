local CorePackages = game:GetService("CorePackages")
local ShareGame = game:GetService("CoreGui").RobloxGui.Modules.Settings.Pages.ShareGame
local Immutable = require(CorePackages.Workspace.Packages.AppCommonLib).Immutable
local Constants = require(ShareGame.Constants)
local OpenPage = require(ShareGame.Actions.OpenPage)
local ClosePage = require(ShareGame.Actions.ClosePage)

return function(p1, p2) -- line: 11
	-- upvalues: Constants (copy), OpenPage (copy), Immutable (copy), ClosePage (copy)
	local v9 = p1 or {
		IsOpen = false,
		Route = Constants.PageRoute.NONE
	}

	if p2.type == OpenPage.name then
		return (Immutable.JoinDictionaries(v9, {
			IsOpen = true,
			Route = p2.route or Constants.PageRoute.NONE
		}))
	end

	if p2.type == ClosePage.name then
		v9 = Immutable.JoinDictionaries(v9, {
			IsOpen = false,
			Route = p2.route or Constants.PageRoute.NONE
		})
	end

	return v9
end
