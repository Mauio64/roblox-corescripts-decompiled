local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactsRodux/Rodux")
local ActionDomain = require("@game/CorePackages/Workspace/Packages/_Index/ContactsRodux/ContactsRodux/Actions/ActionDomain")

return Rodux.makeActionCreator(ActionDomain .. "RequestSent", function(p2)
	return { payload = p2 }
end)
