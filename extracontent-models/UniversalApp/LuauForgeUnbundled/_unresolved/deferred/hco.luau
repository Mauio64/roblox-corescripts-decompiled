local appUserLayers = require("@luauforge/bundled/dPQ").AppUserLayers
local module = require("@luauforge/bundled/dPR")

game:DefineFastFlag("AXEditorRecommendationCarouselEnabled", false)

game:DefineFastFlag("AXEditorRecommendationCarouselEnabledForAll", false)

return module.defineIXPTest({
	name = "AvatarMarketplace.Editor.RecommendationCarousel",
	layer = appUserLayers.AvatarExperienceUACustomizeView,
	recordExposure = false,
	getIsUserInExperiment = function(p2): boolean
		return p2.enableAvatarEditorRecommendationCarousel ~= nil
	end,
	getDependentFlagsEnabled = function(): boolean
		return true
	end,
	getEnabledFlag = function()
		return game:GetFastFlag("AXEditorRecommendationCarouselEnabled")
	end,
	getEnabledForAllFlag = function()
		return game:GetFastFlag("AXEditorRecommendationCarouselEnabledForAll")
	end,
	variables = {
		EnableAvatarEditorRecommendationCarousel = function(p2, p3): boolean
			return p2.enableAvatarEditorRecommendationCarousel == true
		end
	}
})
