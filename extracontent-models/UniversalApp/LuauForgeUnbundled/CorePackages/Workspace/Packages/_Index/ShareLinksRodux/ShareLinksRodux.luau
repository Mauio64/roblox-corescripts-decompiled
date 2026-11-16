local Reducers = require("@game/CorePackages/Workspace/Packages/_Index/ShareLinksRodux/ShareLinksRodux/Reducers")
local module2 = require("@game/CorePackages/Workspace/Packages/_Index/ShareLinksRodux/ShareLinksRodux/Actions")
local module3 = require("@game/CorePackages/Workspace/Packages/_Index/ShareLinksRodux/ShareLinksRodux/Models")
local module4 = require("@game/CorePackages/Workspace/Packages/_Index/ShareLinksRodux/ShareLinksRodux/Enums")

local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareLinksRodux/Cryo")
local RoduxNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareLinksRodux/RoduxNetworking")
local NetworkingShareLinks = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareLinksRodux/NetworkingShareLinks")

return {
	config = function(p2)
		local joined = Cryo.Dictionary.join(p2, {
			shareLinksNetworking = NetworkingShareLinks.config({ roduxNetworking = RoduxNetworking.mock() })
		})

		return {
			installReducer = function()
				return Reducers(joined)
			end,
			Actions = module2,
			Models = module3,
			Enums = module4
		}
	end
}
