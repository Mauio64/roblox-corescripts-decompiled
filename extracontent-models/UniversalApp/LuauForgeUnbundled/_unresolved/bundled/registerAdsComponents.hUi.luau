local module = require("@luauforge/bundled/hTY")
local getSduiComponentRegistry = module.getSduiComponentRegistry
local sduiComponentType = module.SduiComponentType

local fFlagLuaAppSduiSponsoredOneByTwoTile = require("@luauforge/bundled/hTZ").FFlagLuaAppSduiSponsoredOneByTwoTile
local fFlagLuaAppSduiSponsoredTwoByOneTile = require("@luauforge/bundled/hTZ").FFlagLuaAppSduiSponsoredTwoByOneTile
local fFlagSduiPlayWithRewardRefactor = require("@luauforge/bundled/hTZ").FFlagSduiPlayWithRewardRefactor

local function registerAdsComponents()
	local v5 = {
		[sduiComponentType.SponsoredOneByTwoTile] = fFlagLuaAppSduiSponsoredOneByTwoTile and {
			getLazyComponent = function()
				return require("@luauforge/bundled/hUj")
			end
		} or nil,
		[sduiComponentType.SponsoredTwoByOneTile] = fFlagLuaAppSduiSponsoredTwoByOneTile and {
			getLazyComponent = function()
				return require("@luauforge/bundled/hUp")
			end
		} or nil,
		[sduiComponentType.PlayWithReward] = fFlagSduiPlayWithRewardRefactor and {
			getLazyComponent = function()
				return require("@luauforge/bundled/hUs")
			end
		} or nil
	}

	getSduiComponentRegistry().registerComponentDefinitions(v5)
end

return registerAdsComponents
