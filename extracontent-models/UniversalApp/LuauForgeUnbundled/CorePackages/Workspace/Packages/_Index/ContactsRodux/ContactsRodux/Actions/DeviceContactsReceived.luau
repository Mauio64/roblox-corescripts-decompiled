local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactsRodux/Rodux")
require("@game/CorePackages/Workspace/Packages/_Index/ContactsRodux/ContactsRodux/Types/ContactTypes")
local ActionDomain = require("@game/CorePackages/Workspace/Packages/_Index/ContactsRodux/ContactsRodux/Actions/ActionDomain")

return Rodux.makeActionCreator(ActionDomain .. "DeviceContactsReceived", function(p2)
	return { payload = p2 }
end)
