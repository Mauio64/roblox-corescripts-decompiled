local InExperienceSideSheet = script:FindFirstAncestor("InExperienceSideSheet")

local registerInGameMenuPeoplePageActions = require(InExperienceSideSheet.Utils.registerInGameMenuPeoplePageActions)

return function(object)
	registerInGameMenuPeoplePageActions.registerOpenPeoplePage(function()
		local playersPage = object.PlayersPage

		if playersPage == nil then
			return
		end

		if object:GetVisibility() then
			object:SwitchToPage(playersPage, true, 1)
		else
			object:SetVisibility(true, false, playersPage)
		end
	end)

	registerInGameMenuPeoplePageActions.registerClosePeoplePage(function()
		local playersPage = object.PlayersPage
		local pages = object.Pages

		if object:GetVisibility() and playersPage ~= nil and pages ~= nil and pages.CurrentPage == playersPage then
			object:SetVisibility(false)
		end
	end)
end
