local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local topicContentsReducer = require("@luauforge/bundled/dCO").TopicContentsReducer
local gameInfosReducer = require("@luauforge/bundled/dCP").GameInfosReducer
local topicInfosReducer = require("@luauforge/bundled/dCQ").TopicInfosReducer
local fetchStatusReducer = require("@luauforge/bundled/dCR").FetchStatusReducer

local nextDataExpirationTimeReducer = require("@luauforge/bundled/dCS").NextDataExpirationTimeReducer
local gameFiltersReducer = require("@luauforge/bundled/dCT").DataStore.GameFiltersReducer
local songDetailReducer = require("@luauforge/bundled/dCU").SongDetailReducer
local songInfosReducer = require("@luauforge/bundled/dDF").SongInfosReducer
local artistSongReducer = require("@luauforge/bundled/dCU").ArtistSongReducer
local experienceSongsReducer = require("@luauforge/bundled/dDG").ExperienceSongsReducer
local songExperiencesReducer = require("@luauforge/bundled/dCU").SongExperiencesReducer
local pageSessionTimestamp = require("@luauforge/bundled/dDY").PageSessionTimestamp

local modules = require("@luauforge/bundled/dtb").Modules
local gameGridFlexFeedItemBounds = modules.Personalization.OmniFeed.DataStore.GameGridFlexFeedItemBounds
local discoveryNextPageId = modules.Personalization.Games.Discovery.DiscoveryNextPageId
local omniItemsGlobalLayoutData = modules.Personalization.OmniFeed.DataStore.OmniItemsGlobalLayoutData
local sduiConfigReducer = require("@luauforge/bundled/dDZ").SduiConfigReducer

local module = require("@luauforge/bundled/dEa")

local fFlagEnableTopSongsSort = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableTopSongsSort
local fFlagSongEdpCarouselIxp = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSongEdpCarouselIxp

local combineReducers = Rodux.combineReducers
local v5 = {
	["OrderedOmniItems"] = nil,
	["OrderedOmniItems"] = nil,
	["OrderedOmniItems"] = nil,
	["OrderedOmniItems"] = nil,
	["OrderedOmniItems"] = nil,
	OrderedOmniItems = module,
	[topicInfosReducer.key] = topicInfosReducer.reducer,
	[topicContentsReducer.key] = topicContentsReducer.reducer,
	PageSessionTimestamp = pageSessionTimestamp,
	GameGridFlexFeedItemBounds = gameGridFlexFeedItemBounds,
	OmniItemsGlobalLayoutData = omniItemsGlobalLayoutData,
	DiscoveryNextPageId = discoveryNextPageId,
	[gameInfosReducer.key] = gameInfosReducer.reducer,
	[fetchStatusReducer.key] = fetchStatusReducer.reducer,
	[nextDataExpirationTimeReducer.key] = nextDataExpirationTimeReducer.reducer,
	[gameFiltersReducer.key] = gameFiltersReducer.reducer,
	[sduiConfigReducer.key] = sduiConfigReducer.reducer
}
local key = artistSongReducer.key
local v6 = if fFlagEnableTopSongsSort then artistSongReducer.reducer else nil
v5[key] = v6
local key2 = experienceSongsReducer.key
local v7 = if fFlagSongEdpCarouselIxp then experienceSongsReducer.reducer else nil
v5[key2] = v7

local key3 = songDetailReducer.key
local v8 = if fFlagEnableTopSongsSort then songDetailReducer.reducer else nil
v5[key3] = v8
local key4 = songInfosReducer.key
local v9 = if fFlagEnableTopSongsSort then songInfosReducer.reducer else nil
v5[key4] = v9
local key5 = songExperiencesReducer.key
local v10 = if fFlagEnableTopSongsSort then songExperiencesReducer.reducer else nil
v5[key5] = v10
return combineReducers(v5)
