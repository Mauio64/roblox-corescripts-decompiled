local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local parent = MomentsCreation.Parent

local MomentsCommon = require(parent.MomentsCommon)

local FFlagMomentsCreationBackCta = MomentsCommon.Flags.FFlagMomentsCreationBackCta

local FFlagMomentsTextOverlayDragToDeleteRefinement = require(MomentsCreation.Flags.FFlagMomentsTextOverlayDragToDeleteRefinement)

local CreationFlowStrings = {
	CommunityStandardsText = "Feature.Moments.Description.CommunityStandards",
	CreationTooltip = "Feature.Moments.Disclaimer.EveryoneMoments",
	EditingCtaMusic = "Feature.Moments.Label.Music",
	GeneralAllChipLabel = "Feature.Moments.Label.All",
	GeneralCtaBack = "Feature.Moments.Action.Back",
	GeneralCtaCancel = "Feature.Moments.Action.Cancel",
	GeneralCtaDone = "Feature.Moments.Action.Done",
	GeneralCtaLeave = "Feature.Moments.Action.Leave",
	GeneralCtaOk = "Feature.Moments.Action.Ok",
	GeneralCtaRetry = "Feature.Moments.Action.Retry",
	GeneralCtaReturn = "Feature.Moments.Action.Back",
	GeneralCtaSave = "Feature.Moments.Action.Save",
	GeneralCtaShowMore = "Feature.Moments.Action.ShowMore",
	GeneralEmptyStateText = "Feature.Moments.Description.EmptyCapturesLibrary",
	GeneralPhotosChipLabel = "Feature.Moments.Label.Photos",
	GeneralSearchPlaceholder = "Feature.Moments.Label.Search",
	GeneralVideosChipLabel = "Feature.Moments.Label.Videos",
	GenerateTextCta = "Feature.Moments.Action.GenerateText",
	GenerateTextOptionsTitle = "Feature.Moments.Title.GenerateTextOptions",
	ToneCinematic = "Feature.Moments.Label.Tone.Cinematic",
	ToneFunny = "Feature.Moments.Label.Tone.Funny",
	ToneHeading = "Feature.Moments.Label.Tone",
	ToneHype = "Feature.Moments.Label.Tone.Hype",
	ToneNeutral = "Feature.Moments.Label.Tone.Neutral",
	LeaveMomentCreationBody = "Feature.Moments.Description.LeaveMomentsCreation",
	LeaveMomentCreationTitle = "Feature.Moments.Title.LeaveMomentCreation",
	MusicNoResults = "Feature.Moments.Description.NoMusicResults",
	MusicSearchError = "Feature.Moments.Label.Error",
	MusicSavedEmptySubtitle = "Feature.Catalog.Message.Favorites.Empty",
	MusicSavedEmptyTitle = "Feature.Moments.Description.NothingHereYet",
	MusicTabTrending = "Feature.Moments.Label.FeedTrending",
	PublishingAllowComments = "Feature.Moments.Label.AllowComments",
	PublishingCtaContinue = "Feature.Moments.Action.Continue",
	PublishingCtaPrimary = "Feature.Moments.Action.Post",
	PublishingCtaReturn = FFlagMomentsCreationBackCta and "Feature.Moments.Action.Back" or "Feature.Moments.Action.Return",
	PublishingCtaSecondary = FFlagMomentsCreationBackCta and "Feature.Moments.Action.Back" or "Feature.Moments.Action.ReturnToEditing",
	PublishingDescription = "Feature.Moments.Description.PublishMoment",
	StayFriendlyModeration = "Feature.Moments.Label.StayFriendlyModeration"
}

if FFlagMomentsTextOverlayDragToDeleteRefinement then
	CreationFlowStrings.TextOverlayDragHereToDelete = "Feature.Moments.Label.DragHereToDelete"
end

return CreationFlowStrings
