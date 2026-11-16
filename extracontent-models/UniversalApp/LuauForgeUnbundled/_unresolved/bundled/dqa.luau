local module = require("@luauforge/bundled/dqb")

require("@luauforge/bundled/dqc")

return {
	Modules = {
		LuaApp = {
			Actions = {
				Games = {
					AddContentMetadata = require("@luauforge/bundled/dqN"),
					AddOmniRecommendations = require("@luauforge/bundled/dqO"),
					AppendGameSortsInGroup = require("@luauforge/bundled/dqP"),
					SetGameSortsInGroup = require("@luauforge/bundled/dqQ"),
					SetOmniAutocompleteSorts = require("@luauforge/bundled/dqR"),
					SetOmniRecommendationsMetadataRequestStatus = require("@luauforge/bundled/dqS"),
					SetOmniRecommendationsRefreshTime = require("@luauforge/bundled/dqT"),
					UpdateGameMedia = require("@luauforge/bundled/dqU")
				},
				AppendSearchInGames = require("@luauforge/bundled/dqx"),
				SetHomePageUpsellCardVariation = require("@luauforge/bundled/dqV"),
				SetSearchInGames = require("@luauforge/bundled/dqw"),
				SetSearchInGamesStatus = require("@luauforge/bundled/dqt"),
				AddTextSearchResults = require("@luauforge/bundled/dqL"),
				RemoveTextSearchResults = require("@luauforge/bundled/dqW")
			},
			Analytics = {
				Events = {
					Games = { GameDetailsEvents = require("@luauforge/bundled/dqX") }
				},
				Sessions = { OmniSearchSessionUtil = require("@luauforge/bundled/dqZ") }
			},
			Common = {
				Experience = { getPlayButtonProps = require("@luauforge/bundled/drb") }
			},
			Components = {
				EventReceivers = { OnGameLeaveReceiver = require("@luauforge/bundled/dre") },
				ExperienceDetails = { ExperienceRatings = require("@luauforge/bundled/drM") },
				Games = {
					AppFeaturedGameTileTwoByTwo = require("@luauforge/bundled/drX"),
					GameGridSelector = require("@luauforge/bundled/dsm"),
					GameGridTable = require("@luauforge/bundled/dsu"),
					OmniFeedAutoRefresher = require("@luauforge/bundled/dsA")
				},
				Generic = { GridView = require("@luauforge/bundled/dss") },
				Search = {
					SearchTypeSelection = {
						Context = require("@luauforge/bundled/dtd"),
						SearchSelectionTypeHeader = require("@luauforge/bundled/dte")
					}
				}
			},
			DesignTokenMappers = { experienceDetailsTokenMapper = require("@luauforge/bundled/dtf") },
			Enum = {
				SearchRetrievalStatus = require("@game/CorePackages/Packages/_Index/RoduxNetworking/RoduxNetworking/NetworkStatus/EnumNetworkStatus"),
				PaginationMethod = require("@luauforge/bundled/dqF")
			},
			Flags = {
				FFlagSearchEmphasisViewportNonSdui = require("@luauforge/bundled/dqM"),
				GetFFlagEnableHomePageUpsellCard = require("@luauforge/bundled/dtg"),
				GetFFlagFixFetchNextOmniWithoutPageToken = require("@luauforge/bundled/drI"),
				GetFFlagLuaAppUpdateGameSortGridRowHeight10ft = require("@luauforge/bundled/dst"),
				GetFFlagShowCreatorNameOnEmphasisSearchTileIXP = require("@luauforge/bundled/dqA")
			},
			Http = {
				Requests = {
					DiscoveryApi = {
						OmniGetRecommendationsMetadata = require("@luauforge/bundled/dth")
					},
					GamesApi = { GetSearchLandingPageSuggestion = require("@luauforge/bundled/dti") },
					SearchGetOmniSearch = require("@luauforge/bundled/dtj")
				}
			},
			Models = {
				DiscoveryApi = {
					OmniRecommendations = require("@luauforge/bundled/drH"),
					getFormattedTextSearchEntry = require("@luauforge/bundled/dqI")
				},
				GamesApi = {
					GameMediaEntry = require("@luauforge/bundled/dtk"),
					GameSearchEntry = require("@luauforge/bundled/dqy")
				},
				GameSortGroup = require("@luauforge/bundled/dtl"),
				SearchInGames = require("@luauforge/bundled/dqC")
			},
			Reducers = {
				Games = {
					GameMedia = require("@luauforge/bundled/dtm"),
					GameSortGroups = require("@luauforge/bundled/dtn"),
					OmniRecommendations = require("@luauforge/bundled/dto"),
					OmniRecommendationsRefreshTime = require("@luauforge/bundled/dtp")
				},
				FetchHomePageDataStatusAll = require("@luauforge/bundled/dtq"),
				GamesPageDataStatus = require("@luauforge/bundled/dts"),
				HomePageDataStatus = require("@luauforge/bundled/dtu"),
				HomePageUpsellCardVariation = require("@luauforge/bundled/dtw"),
				OmniRecommendationsMetadataRetrievalStatus = require("@luauforge/bundled/dtx"),
				RequestsStatus = require("@luauforge/bundled/dty")
			},
			Thunks = {
				Games = {
					ApiFetchGameMedia = require("@luauforge/bundled/dtA"),
					ApiFetchGamesData = require("@luauforge/bundled/dtC"),
					ApiFetchGamesInSort = require("@luauforge/bundled/dtD"),
					RefreshExpiringSortTokens = require("@luauforge/bundled/dtF"),
					updateGamesSortData = require("@luauforge/bundled/dsF")
				},
				Omni = {
					ApiFetchOmniRecommendations = require("@luauforge/bundled/dro"),
					ApiFetchOmniRecommendationsMetadata = require("@luauforge/bundled/dtG"),
					parseAndAddContentMetadata = require("@luauforge/bundled/dry")
				},
				Search = {
					ApiFetchGameSearchResults = require("@luauforge/bundled/dtH"),
					ApiFetchSearchLandingPage = require("@luauforge/bundled/dtK"),
					HandleGameSearchResults = require("@luauforge/bundled/dqc")
				},
				FetchAdditionalFriendsInfo = require("@luauforge/bundled/dtL"),
				FetchDataWithErrorToasts = require("@luauforge/bundled/dtM"),
				FetchGamesPageData = require("@luauforge/bundled/dtO"),
				FetchHomePageData = require("@luauforge/bundled/dtQ"),
				FetchHomePageContactMethodModuleVariation = require("@luauforge/bundled/dtS"),
				PostHomePageContactMethodModuleVariationDismiss = require("@luauforge/bundled/duV"),
				FetchUserDataForHomePage = require("@luauforge/bundled/dtU"),
				LegacyUpdateUsers = require("@game/CoreGui/RobloxGui/Modules/Settings/Pages/ShareGame/Thunks/ApiFetchUsersFriends"),
				RefreshGameSorts = require("@luauforge/bundled/duX")
			},
			Util = {
				Omni = { OmniUtils = require("@luauforge/bundled/drx") }
			}
		},
		Personalization = {
			Analytics = {
				queryImpressionsEvent = require("@luauforge/bundled/duY"),
				querySuggestionClicked = require("@luauforge/bundled/duZ")
			},
			Games = {
				DataStore = { GenerateTopicContents = require("@luauforge/bundled/drv") },
				Discovery = { DiscoveryNextPageId = require("@luauforge/bundled/dva") },
				GameCollectionCarousel = require("@luauforge/bundled/dvb"),
				useLoadGamesForSortFromGamesApi = require("@luauforge/bundled/dvi"),
				useLoadMoreGames = require("@luauforge/bundled/dvj")
			},
			OmniFeed = {
				DataStore = {
					AddExploreOmniItems = require("@luauforge/bundled/dtc"),
					AddSearchResultsOmniFeed = require("@luauforge/bundled/dqH"),
					ClearFeedItemRenderedRows = require("@luauforge/bundled/dvk"),
					ClearGameGridFlexFeedItemBounds = require("@luauforge/bundled/dvl"),
					FeedItemModel = require("@luauforge/bundled/dvm"),
					GameGridFlexFeedItemBounds = require("@luauforge/bundled/dvn"),
					OmniItemsGlobalLayoutData = require("@luauforge/bundled/dvp"),
					SetGameGridFlexFeedItemInput = require("@luauforge/bundled/dvo"),
					SetFeedItemRenderedRows = require("@luauforge/bundled/dvq"),
					useUpdateFeedItemRenderedRows = require("@luauforge/bundled/dvr")
				},
				FeedItems = {
					GameCarouselFeedItem = require("@luauforge/bundled/dvs"),
					GameFiltersFeedItem = require("@luauforge/bundled/dvv"),
					HomeGameGridFlexFeedItem = require("@luauforge/bundled/dvx"),
					SearchGameGridFeedItem = require("@luauforge/bundled/dvC"),
					SearchTextFeedItem = require("@luauforge/bundled/dvG"),
					SongCarouselFeedItem = require("@luauforge/bundled/dvJ")
				},
				OmniFeedImpressionsDetector = require("@luauforge/bundled/dwa"),
				OmniFeedProps = require("@luauforge/bundled/dvt"),
				resolveSearchViewportSize = require("@luauforge/bundled/dtJ"),
				useGridFlexFeedItemBounds = require("@luauforge/bundled/dvB")
			},
			Search = {
				FIntSearchLandingPageSideMargin = require("@luauforge/bundled/dvu"),
				mapContentTypeToTreatmentType = require("@luauforge/bundled/dqG"),
				SearchConstants = require("@luauforge/bundled/dwb"),
				SearchPill = require("@luauforge/bundled/dwc"),
				SearchTextBanner = require("@luauforge/bundled/dvH")
			},
			Sessions = {
				DataStore = {
					PageSessionTimestamp = module.PageSessionTimestamp,
					SetPageSessionTimestamp = module.SetPageSessionTimestamp
				},
				DiscoverPageSession = require("@luauforge/bundled/dsE"),
				SearchLandingPageSession = require("@luauforge/bundled/dwd")
			}
		}
	}
}
