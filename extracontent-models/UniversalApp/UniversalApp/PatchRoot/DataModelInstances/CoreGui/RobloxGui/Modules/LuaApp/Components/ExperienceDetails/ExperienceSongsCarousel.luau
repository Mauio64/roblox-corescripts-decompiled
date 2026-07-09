local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local HttpService = game:GetService("HttpService")
local SongCollectionCarousel = require(CorePackages.Workspace.Packages.SongDetails).SongCollectionCarousel
local useExperienceSongs = require(CorePackages.Workspace.Packages.ExperienceSongsRodux).useExperienceSongs
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local AppPage = require(CorePackages.Workspace.Packages.RobloxAppEnums).AppPage
local FFlagSongCarouselPropUpdate = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSongCarouselPropUpdate

return function(t1: {[any]: any}) -- line: 26
	-- upvalues: useExperienceSongs (copy), useLocalization (copy), React (copy), HttpService (copy), SongCollectionCarousel (copy), FFlagSongCarouselPropUpdate (copy), AppPage (copy)
	local v10 = useExperienceSongs(t1.universeId)
	local v11 = useLocalization({
		featuredSongsHeader = {
			"Feature.GameDetails.Heading.FeaturedSongs",
			experienceName = t1.universeTitle
		}
	})
	local songIds = v10.songIds
	local v13 = React.useRef(HttpService:GenerateGUID())
	local v14 = "GameDetails_" .. tostring(t1.universeId) .. tostring(v13.current)

	if #songIds == 0 then
		return nil
	end

	return React.createElement(SongCollectionCarousel, {
		songIds = songIds,
		title = v11.featuredSongsHeader,
		impressionsTag = v14,
		collectionOrder = if not FFlagSongCarouselPropUpdate then nil else t1.collectionOrder,
		layoutOrder = if not FFlagSongCarouselPropUpdate then t1.collectionOrder else nil,
		pageContext = AppPage.ExperienceDetail,
		referralId = t1.universeId,
		fractionalItemAmount = t1.fractionalItemAmount,
		clipsDescendants = t1.clipsDescendants
	})
end
