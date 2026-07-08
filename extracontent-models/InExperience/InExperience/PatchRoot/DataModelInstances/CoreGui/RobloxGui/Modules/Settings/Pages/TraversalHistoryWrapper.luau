local Modules = game:GetService("CoreGui"):WaitForChild("RobloxGui").Modules
local SettingsPageFactory = require(Modules.Settings.SettingsPageFactory)

local function createTraversalHistoryWrapper() -- line: 10
	-- upvalues: SettingsPageFactory (copy)
	local v4 = SettingsPageFactory:CreateNewPage()

	v4.Page.Name = "TraversalHistoryWrapper"
	v4.Page:ClearAllChildren()
	v4.TabHeader = nil
	v4.ShouldShowBottomBar = false
	v4.ShouldShowHubBar = false

	return v4
end

return createTraversalHistoryWrapper
