local parent = script.Parent

require(parent.Common.DirectRecommendationTypes)

local PYMKCarouselApi = {}
PYMKCarouselApi.installReducer = require(script.Parent.installReducer)
PYMKCarouselApi.PYMKCollectionCarousel = require(script.Parent.Components.PYMKCollectionCarousel)
PYMKCarouselApi.PYMKCarouselEntryPoint = require(script.Parent.Components.PYMKCarouselEntryPoint)
local Constants = require(script.Parent.Common.Constants)
PYMKCarouselApi.RoduxKey = Constants.RODUX_KEY
PYMKCarouselApi.PYMKCarouselModel = {
	fromJsonData = require(script.Parent.installReducer.fromOmniJsonData)
}

PYMKCarouselApi["jest.config"] = script.Parent["jest.config"]
return PYMKCarouselApi
