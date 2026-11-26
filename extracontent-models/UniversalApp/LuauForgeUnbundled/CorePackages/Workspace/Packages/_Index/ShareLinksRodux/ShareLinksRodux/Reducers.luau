local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareLinksRodux/Rodux")

local module2 = require("@game/CorePackages/Workspace/Packages/_Index/ShareLinksRodux/ShareLinksRodux/Reducers/Invites")

return function(p2)
	return Rodux.combineReducers({ Invites = module2(p2) })
end
