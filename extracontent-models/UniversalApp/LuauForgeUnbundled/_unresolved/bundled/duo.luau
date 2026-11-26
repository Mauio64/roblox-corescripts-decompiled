local appPage = require("@luauforge/bundled/dup").AppPage
local omniFeedConstants = require("@luauforge/bundled/dtp").OmniFeedConstants

local module = require("@luauforge/bundled/duq")

local function refreshOmniRecommendations(p2, p3, object, p4)
	return object:dispatch(module(
		p2,
		p3,
		appPage.Home,
		nil,
		nil,
		omniFeedConstants.OmniRecommendationsRequestIntent.GameExit,
		p4
	)):catch(function(p5)
		warn("We failed to refresh omni recommendations on game exit!", p5)
	end)
end

return function(p2, p3, p4)
	return function(p5)
		return refreshOmniRecommendations(p2, p3, p5, p4)
	end
end
