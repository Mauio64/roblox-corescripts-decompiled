require(script.Parent.Parent.proto)

local v1beta1 = require(script.badges.v1beta1)
local v1beta1_2 = require(script.charts.v1beta1)
local v1beta1_3 = require(script.devstore.v1beta1)
local v1beta1_4 = require(script.experiencedetails.v1beta1)
local v1beta1_5 = require(script.experienceevents.v1beta1)
local v1beta1_6 = require(script.home.v1beta1)
local v1beta1_7 = require(script.marketplacecatalog.v1beta1)
local v1beta1_8 = require(script.prompts.v1beta1)
local v1beta1_9 = require(script.search.v1beta1)
local v1beta1_10 = require(script.shared.v1beta1)
local v1beta1_11 = require(script.spotlightcollection.v1beta1)

return {
	badges = v1beta1,
	charts = v1beta1_2,
	devstore = v1beta1_3,
	experiencedetails = v1beta1_4,
	experienceevents = v1beta1_5,
	home = v1beta1_6,
	marketplacecatalog = v1beta1_7,
	prompts = v1beta1_8,
	search = v1beta1_9,
	shared = v1beta1_10,
	spotlightcollection = v1beta1_11
}
