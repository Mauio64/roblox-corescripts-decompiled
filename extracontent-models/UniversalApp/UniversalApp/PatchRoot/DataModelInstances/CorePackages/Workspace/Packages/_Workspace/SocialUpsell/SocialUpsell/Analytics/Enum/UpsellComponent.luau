local Parent = script:FindFirstAncestor("SocialUpsell").Parent
local FFlagLuaAppCarouselAmpUpsellSubtitleClickAnalytics = require(Parent.SharedFlags).FFlagLuaAppCarouselAmpUpsellSubtitleClickAnalytics

return {
	Banner = "Banner",
	Modal = "Modal",
	PushNotifUI = "PushNotifUI",
	Carousel = if not FFlagLuaAppCarouselAmpUpsellSubtitleClickAnalytics then nil else "Carousel"
}
