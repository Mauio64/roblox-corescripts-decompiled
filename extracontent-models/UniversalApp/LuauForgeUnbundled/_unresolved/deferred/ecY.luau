local CorePackages = game:GetService("CorePackages")

require(CorePackages.Packages.React)
local Roact = require(CorePackages.Packages.Roact)
local Cryo = require(CorePackages.Packages.Cryo)
local RoactAppExperiment = require(CorePackages.Packages.RoactAppExperiment)

local getFStringSocialUserSearchResultsPageLayer = require("@game/CorePackages/Workspace/Packages/SharedFlags").getFStringSocialUserSearchResultsPageLayer

local fFlagPlayerSearchEnableOnlineFrequents = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagPlayerSearchEnableOnlineFrequents

local fFlagPlayerSearchEnableOnlineFrequentsForAll = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagPlayerSearchEnableOnlineFrequentsForAll

local extended = Roact.PureComponent:extend("UserSearchResultsPageLayerExposure")

function extended:init()
	self.state = { layerExposedOnMount = false }
end

function extended.didMount(object)
	object:setState({ layerExposedOnMount = true })
end

function extended.render(p2)
	if p2.state.layerExposedOnMount then
		return (p2.props.renderChild(Cryo.Dictionary.join(p2.props, {
			renderChild = Cryo.None
		})))
	end

	return nil
end

return RoactAppExperiment.connectUserLayer(
	{ getFStringSocialUserSearchResultsPageLayer() },
	function(p2, p3)
		local v5 = p2[getFStringSocialUserSearchResultsPageLayer()] or {}

		local v6 = {
			enablePresenceIndicator = v5.enable_presence_indicator,
			enableOnlineFrequents = 0
		}

		local v7 = if fFlagPlayerSearchEnableOnlineFrequents and not fFlagPlayerSearchEnableOnlineFrequentsForAll then v5.enableOnlineFrequents else nil
		v6.enableOnlineFrequents = v7
		return v6
	end
)(extended)
