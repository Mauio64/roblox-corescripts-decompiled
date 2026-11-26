local module = require("@luauforge/deferred/dZM")
local RoduxNetworking = require("@game/CorePackages/Workspace/Packages/RoduxNetworking")
local module3 = require("@game/CorePackages/Workspace/Packages/ContentSharingNetworking")

local AliasesReducer = require("@game/CorePackages/Packages/_Index/RoduxAliases/RoduxAliases/Reducers/AliasesReducer")

return {
	config = function(p2)
		local joined = module.Dictionary.join(p2, {
			ContentSharingNetworking = module3.config({
				roduxNetworking = RoduxNetworking.mock()
			})
		})

		return {
			installReducer = function()
				return AliasesReducer(joined)
			end
		}
	end
}
