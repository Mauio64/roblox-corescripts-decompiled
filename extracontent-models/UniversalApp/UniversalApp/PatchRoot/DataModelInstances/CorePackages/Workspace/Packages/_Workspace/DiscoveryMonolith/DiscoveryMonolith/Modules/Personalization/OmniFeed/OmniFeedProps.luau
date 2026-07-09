local Parent = script:FindFirstAncestor("DiscoveryMonolith").Parent
local t = require(Parent.t)
local OmniFeedPropsKey = require(Parent.DiscoveryTypes).OmniFeedPropsKey

require(Parent.VideoUtils)

local FFlagLuaAppHomeFirstTileThumbnailLoadedMilestone = require(Parent.SharedFlags).FFlagLuaAppHomeFirstTileThumbnailLoadedMilestone
local FFlagLuaAppHomeTouchAutoplay = require(Parent.SharedFlags).FFlagLuaAppHomeTouchAutoplay
local FFlagLuaAppGameCarouselAmpUpsellAction = require(Parent.SharedFlags).FFlagLuaAppGameCarouselAmpUpsellAction

return {
	interface = t.strictInterface({
		feedItemPosition = t.number,
		feedItemStartRow = t.optional(t.number),
		scrollViewPositionChangedSignal = t.table,
		refreshSignal = t.table,
		appPage = t.string,
		verticalScrollingFrameRef = t.table,
		sduiContext = t.table,
		selectionOrderBase = t.optional(t.number),
		defaultContainerSize = t.optional(t.Vector2),
		appCompositionEnabled = t.optional(t.boolean),
		onTileImageLoaded = if not FFlagLuaAppHomeFirstTileThumbnailLoadedMilestone then nil else t.optional(t.callback),
		videoPlaybackContext = if not FFlagLuaAppHomeTouchAutoplay then nil else t.optional(t.table),
		refreshFeed = if not FFlagLuaAppGameCarouselAmpUpsellAction then nil else t.optional(t.callback)
	}),
	key = OmniFeedPropsKey,
	new = function(n1: number, n2: number?, p1, p2, s1: string, p3, p4, n3: number?, vector2: Vector2?, b1: boolean?, p5: ((...any) -> ...any)?, p6, p7: ((...any) -> ...any)?) -- line: 32
		-- upvalues: FFlagLuaAppHomeFirstTileThumbnailLoadedMilestone (copy), FFlagLuaAppHomeTouchAutoplay (copy), FFlagLuaAppGameCarouselAmpUpsellAction (copy)
		return {
			feedItemPosition = n1,
			feedItemStartRow = n2,
			scrollViewPositionChangedSignal = p1,
			refreshSignal = p2,
			appPage = s1,
			verticalScrollingFrameRef = p3,
			sduiContext = p4,
			selectionOrderBase = n3,
			defaultContainerSize = vector2,
			appCompositionEnabled = b1,
			onTileImageLoaded = if not FFlagLuaAppHomeFirstTileThumbnailLoadedMilestone then nil else p5,
			videoPlaybackContext = if not FFlagLuaAppHomeTouchAutoplay then nil else p6,
			refreshFeed = if not FFlagLuaAppGameCarouselAmpUpsellAction then nil else p7
		}
	end
}
