local FFlagBuildAdUpsell = require(script.Parent.FFlagBuildAdUpsell)
local FFlagEnableBuildAdPromotion = require(script.Parent.FFlagEnableBuildAdPromotion)

return game:DefineFastFlag("EnablePaidAds4", false) and FFlagBuildAdUpsell and FFlagEnableBuildAdPromotion
