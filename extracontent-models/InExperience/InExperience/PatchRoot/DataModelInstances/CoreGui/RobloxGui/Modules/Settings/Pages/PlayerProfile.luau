local RobloxGui = game:GetService("CoreGui").RobloxGui
local ReactPageFactory = require(RobloxGui.Modules.Settings.ReactPageFactory)
local PlayerProfileContainer = require(script.PlayerProfileContainer)

function createPlayerProfilePage() -- line: 9
	-- upvalues: ReactPageFactory (copy), PlayerProfileContainer (copy)
	local v4 = ReactPageFactory:createNewPage("PlayerProfile")

	v4:setPage(PlayerProfileContainer)

	return v4
end

return createPlayerProfilePage()
