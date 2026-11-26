local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)

local HttpService = game:GetService("HttpService")

local songCollectionCarousel = require("@luauforge/deferred/gEb").SongCollectionCarousel
local useExperienceSongs = require("@luauforge/bundled/dDG").useExperienceSongs

local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization

local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").AppPage

local fFlagSongCarouselPropUpdate = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSongCarouselPropUpdate

return function(props)
	local v5 = useExperienceSongs(props.universeId)

	local v6 = useLocalization({
		featuredSongsHeader = {
			"Feature.GameDetails.Heading.FeaturedSongs",
			experienceName = props.universeTitle
		}
	})

	local songIds = v5.songIds

	local ref = React.useRef(HttpService:GenerateGUID())
	local v7 = "GameDetails_" .. tostring(props.universeId) .. tostring(ref.current)

	if #songIds == 0 then
		return nil
	end

	local createElement = React.createElement
	local v9 = {
		songIds = songIds,
		title = v6.featuredSongsHeader,
		impressionsTag = v7,
		collectionOrder = 0,
		layoutOrder = 0,
		pageContext = 0,
		referralId = 0,
		fractionalItemAmount = 0,
		clipsDescendants = 0
	}

	local v10 = if fFlagSongCarouselPropUpdate then props.collectionOrder else nil
	v9.collectionOrder = v10
	local v11 = if not fFlagSongCarouselPropUpdate then props.collectionOrder else nil
	v9.layoutOrder = v11
	v9.pageContext = appPage.ExperienceDetail
	v9.referralId = props.universeId
	v9.fractionalItemAmount = props.fractionalItemAmount
	v9.clipsDescendants = props.clipsDescendants
	return createElement(songCollectionCarousel, v9)
end
