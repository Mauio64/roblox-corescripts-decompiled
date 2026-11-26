local module = require("@luauforge/bundled/idW")
local getSduiComponentRegistry = module.getSduiComponentRegistry
local sduiComponentType = module.SduiComponentType

local fFlagLuaAppSduiSponsoredOneByTwoTile = require("@luauforge/bundled/idX").FFlagLuaAppSduiSponsoredOneByTwoTile
local fFlagLuaAppSduiSponsoredTwoByOneTile = require("@luauforge/bundled/idX").FFlagLuaAppSduiSponsoredTwoByOneTile
local fFlagSduiPlayWithRewardRefactor = require("@luauforge/bundled/idX").FFlagSduiPlayWithRewardRefactor

local function registerAdsComponents()
	local v5 = {
		[sduiComponentType.SponsoredOneByTwoTile] = fFlagLuaAppSduiSponsoredOneByTwoTile and {
			getLazyComponent = function()
				return require("@luauforge/bundled/ieh")
			end
		} or nil,
		[sduiComponentType.SponsoredTwoByOneTile] = fFlagLuaAppSduiSponsoredTwoByOneTile and {
			getLazyComponent = function()
				return require("@luauforge/bundled/ien")
			end
		} or nil,
		[sduiComponentType.PlayWithReward] = fFlagSduiPlayWithRewardRefactor and {
			getLazyComponent = function()
				return require("@luauforge/bundled/ieq")
			end
		} or nil
	}

	getSduiComponentRegistry().registerComponentDefinitions(v5)
end

return registerAdsComponents
