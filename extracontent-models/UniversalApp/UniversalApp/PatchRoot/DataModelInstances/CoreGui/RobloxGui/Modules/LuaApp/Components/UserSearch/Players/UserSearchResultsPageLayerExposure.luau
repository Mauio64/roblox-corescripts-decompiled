local CorePackages = game:GetService("CorePackages")

require(CorePackages.Packages.React)

local Roact = require(CorePackages.Packages.Roact)
local Cryo = require(CorePackages.Packages.Cryo)
local RoactAppExperiment = require(CorePackages.Packages.RoactAppExperiment)
local getFStringSocialUserSearchResultsPageLayer = require(CorePackages.Workspace.Packages.SharedFlags).getFStringSocialUserSearchResultsPageLayer
local FFlagPlayerSearchEnableOnlineFrequents = require(CorePackages.Workspace.Packages.SharedFlags).FFlagPlayerSearchEnableOnlineFrequents
local FFlagPlayerSearchEnableOnlineFrequentsForAll = require(CorePackages.Workspace.Packages.SharedFlags).FFlagPlayerSearchEnableOnlineFrequentsForAll
local v8 = Roact.PureComponent:extend("UserSearchResultsPageLayerExposure")

function v8.init(p1) -- line: 25
	p1.state = {
		layerExposedOnMount = false
	}
end
function v8.didMount(p2) -- line: 31
	p2:setState({
		layerExposedOnMount = true
	})
end
function v8.render(p3) -- line: 37
	-- upvalues: Cryo (copy)
	if p3.state.layerExposedOnMount then
		return (p3.props.renderChild(Cryo.Dictionary.join(p3.props, {
			renderChild = Cryo.None
		})))
	end

	return nil
end

return RoactAppExperiment.connectUserLayer({ getFStringSocialUserSearchResultsPageLayer() }, function(p4, _) -- line: 47
	-- upvalues: getFStringSocialUserSearchResultsPageLayer (copy), FFlagPlayerSearchEnableOnlineFrequents (copy), FFlagPlayerSearchEnableOnlineFrequentsForAll (copy)
	local v14 = p4[getFStringSocialUserSearchResultsPageLayer()] or {}

	return {
		enablePresenceIndicator = v14.enable_presence_indicator,
		enableOnlineFrequents = if not FFlagPlayerSearchEnableOnlineFrequents or FFlagPlayerSearchEnableOnlineFrequentsForAll then nil else v14.enableOnlineFrequents
	}
end)(v8)
