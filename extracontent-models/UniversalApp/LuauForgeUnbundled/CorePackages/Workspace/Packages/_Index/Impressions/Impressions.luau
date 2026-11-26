local module = require("@game/CorePackages/Workspace/Packages/_Index/Impressions/Impressions/ImpressionsTrackerWithoutNavigation")

return {
	Constants = require("@game/CorePackages/Workspace/Packages/_Index/Impressions/Impressions/Constants"),
	ImpressionsDetector = require("@game/CorePackages/Workspace/Packages/_Index/Impressions/Impressions/ImpressionsDetector"),
	ImpressionsTaggerWrapper = require("@game/CorePackages/Workspace/Packages/_Index/Impressions/Impressions/ImpressionsTaggerWrapper"),
	ImpressionsTagUtility = require("@game/CorePackages/Workspace/Packages/_Index/Impressions/Impressions/ImpressionsTagUtility"),
	ImpressionsVisualizer = require("@game/CorePackages/Workspace/Packages/_Index/Impressions/Impressions/ImpressionsVisualizer"),
	ScreenSizeImpressionsDetector = require("@game/CorePackages/Workspace/Packages/_Index/Impressions/Impressions/ScreenSizeImpressionsDetector"),
	useImpressionsTagger = require("@game/CorePackages/Workspace/Packages/_Index/Impressions/Impressions/useImpressionsTagger"),
	useBatchedImpressions = require("@game/CorePackages/Workspace/Packages/_Index/Impressions/Impressions/useBatchedImpressions"),
	ImpressionsTracker = require("@game/CorePackages/Workspace/Packages/_Index/Impressions/Impressions/ImpressionsTracker"),
	ImpressionsTrackerWithoutNavigation = module,
	FrameBoundsImpressionsTracker = require("@game/CorePackages/Workspace/Packages/_Index/Impressions/Impressions/FrameBoundsImpressionsTracker"),
	ScreenSizeImpressionsTracker = require("@game/CorePackages/Workspace/Packages/_Index/Impressions/Impressions/ScreenSizeImpressionsTracker"),
	ContentThresholdImpressionsDetector = require("@game/CorePackages/Workspace/Packages/_Index/Impressions/Impressions/ContentThresholdImpressionsDetector"),
	ViewportVisibilityImpressionsDetector = require("@game/CorePackages/Workspace/Packages/_Index/Impressions/Impressions/ViewportVisibilityImpressionsDetector")
}
