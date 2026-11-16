local CoreGui = game:GetService("CoreGui")

local RobloxGui = CoreGui.RobloxGui

local ReactPageFactory = require(RobloxGui.Modules.Settings.ReactPageFactory)

local PlayerProfileContainer = require(script.PlayerProfileContainer)

function createPlayerProfilePage()
	local newPage = ReactPageFactory:createNewPage("PlayerProfile")

	newPage:setPage(PlayerProfileContainer)

	return newPage
end

return createPlayerProfilePage()
