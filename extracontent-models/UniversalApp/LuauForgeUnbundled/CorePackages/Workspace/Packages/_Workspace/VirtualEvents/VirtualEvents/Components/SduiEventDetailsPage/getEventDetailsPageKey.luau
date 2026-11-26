local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/RobloxAppEnums").AppPage

local function getEventDetailsPageKey(p2)
	if p2 == nil then
		return appPage.EventDetails .. "-Unknown"
	end

	return appPage.EventDetails .. "-" .. p2
end

return getEventDetailsPageKey
