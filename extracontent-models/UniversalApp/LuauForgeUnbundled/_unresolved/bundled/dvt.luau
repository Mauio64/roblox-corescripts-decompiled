local module = require("@luauforge/bundled/drj")
local omniFeedPropsKey = require("@luauforge/bundled/dqn").OmniFeedPropsKey
require("@luauforge/bundled/dvc")

return {
	interface = module.strictInterface({
		feedItemPosition = module.number,
		feedItemStartRow = module.optional(module.number),
		scrollViewPositionChangedSignal = module.table,
		refreshSignal = module.table,
		appPage = module.string,
		verticalScrollingFrameRef = module.table,
		sduiContext = module.table,
		selectionOrderBase = module.optional(module.number),
		defaultContainerSize = module.optional(module.Vector2),
		appCompositionEnabled = module.optional(module.boolean),
		videoPlaybackContext = module.optional(module.table),
		refreshFeed = module.optional(module.callback)
	}),
	key = omniFeedPropsKey,
	new = function(p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13)
		return {
			feedItemPosition = p2,
			feedItemStartRow = p3,
			scrollViewPositionChangedSignal = p4,
			refreshSignal = p5,
			appPage = p6,
			verticalScrollingFrameRef = p7,
			sduiContext = p8,
			selectionOrderBase = p9,
			defaultContainerSize = p10,
			appCompositionEnabled = p11,
			videoPlaybackContext = p12,
			refreshFeed = p13
		}
	end
}
