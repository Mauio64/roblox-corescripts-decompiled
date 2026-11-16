local parent = script:FindFirstAncestor("AppTopBanner").Parent
local Rodux = require(parent.Rodux)

return Rodux.makeActionCreator(
	script.Name,
	function(expanded, appTopBannerType, appTopBannerContentProps, onAppTopBannerClick, appTopBannerContentHeight)
		return {
			expanded = expanded,
			appTopBannerType = appTopBannerType,
			appTopBannerContentProps = appTopBannerContentProps,
			onAppTopBannerClick = onAppTopBannerClick,
			appTopBannerContentHeight = appTopBannerContentHeight
		}
	end
)
