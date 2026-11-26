return require("@game/CorePackages/Workspace/Packages/_Workspace/AppTopBanner/Rodux").makeActionCreator(
	"SetAppTopBanner",
	function(p2, p3, p4, onAppTopBannerClick, p5)
		return {
			expanded = p2,
			appTopBannerType = p3,
			appTopBannerContentProps = p4,
			onAppTopBannerClick = onAppTopBannerClick,
			appTopBannerContentHeight = p5
		}
	end
)
