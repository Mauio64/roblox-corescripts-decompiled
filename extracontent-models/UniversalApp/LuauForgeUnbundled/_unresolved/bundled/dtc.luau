local module = require("@luauforge/bundled/dtd")

require("@luauforge/bundled/dte")

return {
	Modules = {
		LuaApp = {
			Actions = {
				Games = {
					AddContentMetadata = require("@luauforge/bundled/dtP"),
					AddOmniRecommendations = require("@luauforge/bundled/dtQ"),
					AppendGameSortsInGroup = require("@luauforge/bundled/dtR"),
					SetGameSortsInGroup = require("@luauforge/bundled/dtS"),
					SetOmniAutocompleteSorts = require("@luauforge/bundled/dtT"),
					SetOmniRecommendationsMetadataRequestStatus = require("@luauforge/bundled/dtU"),
					SetOmniRecommendationsRefreshTime = require("@luauforge/bundled/dtV"),
					UpdateGameMedia = require("@luauforge/bundled/dtW")
				},
				AppendSearchInGames = require("@luauforge/bundled/dtz"),
				SetHomePageUpsellCardVariation = require("@luauforge/bundled/dtX"),
				SetSearchInGames = require("@luauforge/bundled/dty"),
				SetSearchInGamesStatus = require("@luauforge/bundled/dtv"),
				AddTextSearchResults = require("@luauforge/bundled/dtN"),
				RemoveTextSearchResults = require("@luauforge/bundled/dtY")
			},
			Analytics = {
				Events = {
					Games = { GameDetailsEvents = require("@luauforge/bundled/dtZ") }
				},
				Sessions = { OmniSearchSessionUtil = require("@luauforge/bundled/dub") }
			},
			Common = {
				Experience = { getPlayButtonProps = require("@luauforge/bundled/dud") }
			},
			Components = {
				EventReceivers = { OnGameLeaveReceiver = require("@luauforge/bundled/dug") },
				ExperienceDetails = { ExperienceRatings = require("@luauforge/bundled/duO") },
				Games = {
					AppFeaturedGameTileTwoByTwo = require("@luauforge/bundled/duZ"),
					GameGridSelector = require("@luauforge/bundled/dvo"),
					GameGridTable = require("@luauforge/bundled/dvw"),
					OmniFeedAutoRefresher = require("@luauforge/bundled/dvC")
				},
				Generic = { GridView = require("@luauforge/bundled/dvu") },
				Search = {
					SearchTypeSelection = {
						Context = require("@luauforge/bundled/dwf"),
						SearchSelectionTypeHeader = require("@luauforge/bundled/dwg")
					}
				}
			},
			DesignTokenMappers = { experienceDetailsTokenMapper = require("@luauforge/bundled/dwh") },
			Enum = {
				SearchRetrievalStatus = require("@game/CorePackages/Packages/_Index/RoduxNetworking/RoduxNetworking/NetworkStatus/EnumNetworkStatus"),
				PaginationMethod = require("@luauforge/bundled/dtH")
			},
			Flags = {
				FFlagSearchEmphasisViewportNonSdui = require("@luauforge/bundled/dtO"),
				GetFFlagEnableHomePageUpsellCard = require("@luauforge/bundled/dwi"),
				GetFFlagFixFetchNextOmniWithoutPageToken = require("@luauforge/bundled/duK"),
				GetFFlagLuaAppUpdateGameSortGridRowHeight10ft = require("@luauforge/bundled/dvv"),
				GetFFlagShowCreatorNameOnEmphasisSearchTileIXP = require("@luauforge/bundled/dtC")
			},
			Http = {
				Requests = {
					DiscoveryApi = {
						OmniGetRecommendationsMetadata = require("@luauforge/bundled/dwj")
					},
					GamesApi = { GetSearchLandingPageSuggestion = require("@luauforge/bundled/dwk") },
					SearchGetOmniSearch = require("@luauforge/bundled/dwl")
				}
			},
			Models = {
				DiscoveryApi = {
					OmniRecommendations = require("@luauforge/bundled/duJ"),
					getFormattedTextSearchEntry = require("@luauforge/bundled/dtK")
				},
				GamesApi = {
					GameMediaEntry = require("@luauforge/bundled/dwm"),
					GameSearchEntry = require("@luauforge/bundled/dtA")
				},
				GameSortGroup = require("@luauforge/bundled/dwn"),
				SearchInGames = require("@luauforge/bundled/dtE")
			},
			Reducers = {
				Games = {
					GameMedia = require("@luauforge/bundled/dwo"),
					GameSortGroups = require("@luauforge/bundled/dwp"),
					OmniRecommendations = require("@luauforge/bundled/dwq"),
					OmniRecommendationsRefreshTime = require("@luauforge/bundled/dwr")
				},
				FetchHomePageDataStatusAll = require("@luauforge/bundled/dws"),
				GamesPageDataStatus = require("@luauforge/bundled/dwu"),
				HomePageDataStatus = require("@luauforge/bundled/dww"),
				HomePageUpsellCardVariation = require("@luauforge/bundled/dwy"),
				OmniRecommendationsMetadataRetrievalStatus = require("@luauforge/bundled/dwz"),
				RequestsStatus = require("@luauforge/bundled/dwA")
			},
			Thunks = {
				Games = {
					ApiFetchGameMedia = require("@luauforge/bundled/dwC"),
					ApiFetchGamesData = require("@luauforge/bundled/dwE"),
					ApiFetchGamesInSort = require("@luauforge/bundled/dwF"),
					RefreshExpiringSortTokens = require("@luauforge/bundled/dwH"),
					updateGamesSortData = require("@luauforge/bundled/dvH")
				},
				Omni = {
					ApiFetchOmniRecommendations = require("@luauforge/bundled/duq"),
					ApiFetchOmniRecommendationsMetadata = require("@luauforge/bundled/dwI"),
					parseAndAddContentMetadata = require("@luauforge/bundled/duA")
				},
				Search = {
					ApiFetchGameSearchResults = require("@luauforge/bundled/dwJ"),
					ApiFetchSearchLandingPage = require("@luauforge/bundled/dwN"),
					HandleGameSearchResults = require("@luauforge/bundled/dte")
				},
				FetchAdditionalFriendsInfo = require("@luauforge/bundled/dwO"),
				FetchDataWithErrorToasts = require("@luauforge/bundled/dwP"),
				FetchGamesPageData = require("@luauforge/bundled/dwR"),
				FetchHomePageData = require("@luauforge/bundled/dwT"),
				FetchHomePageContactMethodModuleVariation = require("@luauforge/bundled/dwV"),
				PostHomePageContactMethodModuleVariationDismiss = require("@luauforge/bundled/dxY"),
				FetchUserDataForHomePage = require("@luauforge/bundled/dwX"),
				LegacyUpdateUsers = require("@game/CoreGui/RobloxGui/Modules/Settings/Pages/ShareGame/Thunks/ApiFetchUsersFriends"),
				RefreshGameSorts = require("@luauforge/bundled/dya")
			},
			Util = {
				Omni = { OmniUtils = require("@luauforge/bundled/duz") }
			}
		},
		Personalization = {
			Analytics = {
				queryImpressionsEvent = require("@luauforge/bundled/dyb"),
				querySuggestionClicked = require("@luauforge/bundled/dyc")
			},
			Games = {
				DataStore = { GenerateTopicContents = require("@luauforge/bundled/dux") },
				Discovery = { DiscoveryNextPageId = require("@luauforge/bundled/dyd") },
				GameCollectionCarousel = require("@luauforge/bundled/dye"),
				useLoadGamesForSortFromGamesApi = require("@luauforge/bundled/dyl"),
				useLoadMoreGames = require("@luauforge/bundled/dym")
			},
			OmniFeed = {
				DataStore = {
					AddExploreOmniItems = require("@luauforge/bundled/dwe"),
					AddSearchResultsOmniFeed = require("@luauforge/bundled/dtJ"),
					ClearFeedItemRenderedRows = require("@luauforge/bundled/dyn"),
					ClearGameGridFlexFeedItemBounds = require("@luauforge/bundled/dyo"),
					FeedItemModel = require("@luauforge/bundled/dyp"),
					GameGridFlexFeedItemBounds = require("@luauforge/bundled/dyq"),
					OmniItemsGlobalLayoutData = require("@luauforge/bundled/dys"),
					SetGameGridFlexFeedItemInput = require("@luauforge/bundled/dyr"),
					SetFeedItemRenderedRows = require("@luauforge/bundled/dyt"),
					useUpdateFeedItemRenderedRows = require("@luauforge/bundled/dyu")
				},
				FeedItems = {
					GameCarouselFeedItem = require("@luauforge/bundled/dyv"),
					GameFiltersFeedItem = require("@luauforge/bundled/dyy"),
					HomeGameGridFlexFeedItem = require("@luauforge/bundled/dyA"),
					SearchGameGridFeedItem = require("@luauforge/bundled/dyF"),
					SearchTextFeedItem = require("@luauforge/bundled/dyJ"),
					SongCarouselFeedItem = require("@luauforge/bundled/dyM")
				},
				OmniFeedImpressionsDetector = require("@luauforge/bundled/dzd"),
				OmniFeedProps = require("@luauforge/bundled/dyw"),
				resolveSearchViewportSize = require("@luauforge/bundled/dwM"),
				useGridFlexFeedItemBounds = require("@luauforge/bundled/dyE")
			},
			Search = {
				FIntSearchLandingPageSideMargin = require("@luauforge/bundled/dyx"),
				mapContentTypeToTreatmentType = require("@luauforge/bundled/dtI"),
				SearchConstants = require("@luauforge/bundled/dze"),
				SearchPill = require("@luauforge/bundled/dzf"),
				SearchTextBanner = require("@luauforge/bundled/dyK")
			},
			Sessions = {
				DataStore = {
					PageSessionTimestamp = module.PageSessionTimestamp,
					SetPageSessionTimestamp = module.SetPageSessionTimestamp
				},
				DiscoverPageSession = require("@luauforge/bundled/dvG"),
				SearchLandingPageSession = require("@luauforge/bundled/dzg")
			}
		}
	}
}
