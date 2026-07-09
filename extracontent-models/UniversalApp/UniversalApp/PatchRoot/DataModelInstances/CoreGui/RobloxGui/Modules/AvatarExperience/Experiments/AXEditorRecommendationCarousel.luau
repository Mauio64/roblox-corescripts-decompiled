local CorePackages = game:GetService("CorePackages")
local AppUserLayers = require(CorePackages.Workspace.Packages.ExperimentLayers).AppUserLayers
local IxpUtils = require(CorePackages.Workspace.Packages.IxpUtils)

game:DefineFastFlag("AXEditorRecommendationCarouselEnabled", false)
game:DefineFastFlag("AXEditorRecommendationCarouselEnabledForAll", false)

return IxpUtils.defineIXPTest({
	name = "AvatarMarketplace.Editor.RecommendationCarousel",
	recordExposure = false,
	layer = AppUserLayers.AvatarExperienceUACustomizeView,
	getIsUserInExperiment = function(p1) -- line: 28
		return p1.enableAvatarEditorRecommendationCarousel ~= nil
	end,
	getDependentFlagsEnabled = function() -- line: 32
		return true
	end,
	getEnabledFlag = function() -- line: 36
		return game:GetFastFlag("AXEditorRecommendationCarouselEnabled")
	end,
	getEnabledForAllFlag = function() -- line: 40
		return game:GetFastFlag("AXEditorRecommendationCarouselEnabledForAll")
	end,
	variables = {
		EnableAvatarEditorRecommendationCarousel = function(p2, _) -- line: 45
			return p2.enableAvatarEditorRecommendationCarousel == true or false
		end
	}
})
