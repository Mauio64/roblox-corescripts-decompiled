local CorePackages = game:GetService("CorePackages")
local IXPService = game:GetService("IXPService")

local React = require(CorePackages.Packages.React)
local Cryo = require(CorePackages.Packages.Cryo)
local userSearchHydrationLayer = require("@luauforge/bundled/ehc").UserSearchHydrationLayer
local module = require("@luauforge/bundled/ehd")

require("@luauforge/bundled/ehi")
require("@luauforge/bundled/ehD")

local fFlagPlayerSearchEnableOnlineFrequents = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagPlayerSearchEnableOnlineFrequents

local fFlagPlayerSearchEnableOnlineFrequentsForAll = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagPlayerSearchEnableOnlineFrequentsForAll

local fFlagLuaAppLogSocialUserSearchUXExposure = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppLogSocialUserSearchUXExposure

local defineFastString = game:DefineFastString("LuaAppSocialUserSearchUXLayer", "Social.UserSearchUX")

return function(props)
	if fFlagLuaAppLogSocialUserSearchUXExposure then
		React.useEffect(function()
			IXPService:LogUserLayerExposure(defineFastString)
		end, {})
	end

	local createElement = React.createElement
	local v6 = {
		users = props.entries,
		searchParameters = props.searchParameters,
		enableOnlineFrequents = 0,
		renderComponent = 0
	}

	local v7 = if fFlagPlayerSearchEnableOnlineFrequents and not fFlagPlayerSearchEnableOnlineFrequentsForAll then props.enableOnlineFrequents else nil
	v6.enableOnlineFrequents = v7

	function v6.renderComponent(p2)
		return React.createElement(
			module,
			Cryo.Dictionary.join(props, {
				mappedProfilesInsights = p2.mappedProfilesInsights
			})
		)
	end

	return createElement(userSearchHydrationLayer, v6)
end
