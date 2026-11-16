local UserInputService = game:GetService("UserInputService")

local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/FriendsCarousel/FriendsCarousel/dependencies")
local ThirdPartyUserService = game:GetService("ThirdPartyUserService")

local networkingFriends = dependencies.NetworkingFriends
local networkingAliases = dependencies.NetworkingAliases
local roduxFriends = dependencies.RoduxFriends
local roduxAnalytics = dependencies.RoduxAnalytics
local promise = dependencies.Promise
local dash = dependencies.Dash
local showRecommendations = require("@game/CorePackages/Workspace/Packages/_Index/FriendsCarousel/FriendsCarousel/Utils/showRecommendations")

local eventNames = require("@game/CorePackages/Workspace/Packages/_Index/FriendsCarousel/FriendsCarousel/Analytics").EventNames
local analytics = require("@game/CorePackages/Workspace/Packages/_Index/FriendsCarousel/FriendsCarousel/Analytics").Analytics
local FetchNames = require("@game/CorePackages/Workspace/Packages/_Index/FriendsCarousel/FriendsCarousel/Analytics/FetchNames")

local retrievalStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCarousel/UIBlox").App.Loading.Enum.RetrievalStatus

local UserSorts = require("@game/CorePackages/Workspace/Packages/_Index/FriendsCarousel/FriendsCarousel/Common/UserSorts")
local RECOMMENDATION_SESSION_ID_KEY = require("@game/CorePackages/Workspace/Packages/_Index/FriendsCarousel/FriendsCarousel/Common/Constants").RECOMMENDATION_SESSION_ID_KEY
local socialCommon = dependencies.SocialCommon
local recommendationSourceEnum = socialCommon.Enums.RecommendationSourceEnum
local contextualInfoTypes = socialCommon.Enums.ContextualInfoTypes

local timers = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCarousel/SocialLuaAnalytics").Analytics.Timing.Timers

local v5 = dependencies.logger:new("FriendsCarousel/FetchFriendsAndRecommendations")

local isSubjectToDesktopPolicies = dependencies.isSubjectToDesktopPolicies
local fFlagEnableRecommendationsForPCGDK = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCarousel/SharedFlags").FFlagEnableRecommendationsForPCGDK
local fFlagFixIsConsoleCheckForSocialCarousel = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCarousel/SharedFlags").FFlagFixIsConsoleCheckForSocialCarousel

local fFlagSocialCarouselMigrateRecommendations = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCarousel/SharedFlags").FFlagSocialCarouselMigrateRecommendations

local fFlagLuaSupportMicroGamepadPreferredInput = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCarousel/SharedFlags").FFlagLuaSupportMicroGamepadPreferredInput

local function fn(p2)
	return showRecommendations(p2) and not isSubjectToDesktopPolicies()
		or showRecommendations(p2)
		and fFlagEnableRecommendationsForPCGDK
		and ThirdPartyUserService
		and ThirdPartyUserService:HaveActiveUser()
		or showRecommendations(p2)
		and fFlagFixIsConsoleCheckForSocialCarousel
		and (UserInputService.PreferredInput == Enum.PreferredInput.Gamepad or fFlagLuaSupportMicroGamepadPreferredInput and UserInputService.PreferredInput == Enum.PreferredInput.MicroGamepad)
end

local v6 = 0

return function(p2)
	return function(object)
		local localUserId = tostring(object:getState().LocalUserId)

		local fireAnalyticsEvent = analytics({
			infoForAllEvents = { uid = localUserId }
		}).fireAnalyticsEvent

		local v7 = timers()
		local v8 = v7.start()

		return object:dispatch(networkingFriends.GetFriendsFromUserId.API(localUserId, {
			userSort = UserSorts.StatusFrequents
		})):andThen(function(p3)
			local data = p3.responseBody.data
			local v9 = data and #data or 0
			v6 = if p2 and p2.refresh then v6 + 1 else v6

			local v11 = not data and {} or dash.map(data, function(p4)
				return p4.id
			end)

			local v12 = v7.stop(v8)

			fireAnalyticsEvent(eventNames.FriendsEndpointLoadingTime, {
				status = retrievalStatus.Done.rawValue(),
				loadingTime = v12,
				fetch = FetchNames.OldAllFriends
			})

			object:dispatch(networkingAliases.GetTagsFromUserIds.API(v11)):andThen(function()
				return promise.resolve()
			end):catch(function(p4)
				v5:info(`GetTagsFromUserIds failed: {p4}`)
			end)

			if fn(v9) and not fFlagSocialCarouselMigrateRecommendations then
				object:dispatch(networkingFriends.GetFriendRecommendationsFromUserId.API({
					targetUserId = localUserId
				})):andThen(function(p4)
					local data2 = p4.responseBody.data
					local mapped = dash.map(data2, function(data3)
						if data3.contextType == contextualInfoTypes.Contacts then
							return data3.contactId
						end

						return data3.id
					end)

					object:dispatch(roduxFriends.Actions.RecommendationSourceCreated({
						source = recommendationSourceEnum.HomepageFriendsCarousel,
						recommendationIds = mapped
					}))

					local recommendationRequestId = p4.responseBody.recommendationRequestId
					object:dispatch(roduxAnalytics.Actions.SessionIdUpdated({
						sessionKey = RECOMMENDATION_SESSION_ID_KEY,
						sessionId = recommendationRequestId
					}))

					return promise.resolve(p4):andThen(function(p5)
						if fireAnalyticsEvent then
							local data3 = p5.responseBody.data
							local v13 = data3 and #data3 or 0
							local recommendationRequestId2 = p5.responseBody.recommendationRequestId

							fireAnalyticsEvent(eventNames.CarouselLoadedWithUsers, {
								friendCount = v9,
								recommendationCount = v13,
								recommendationLimit = true,
								refreshCount = v6,
								fetchedRecommendations = true,
								recommendationSessionId = recommendationRequestId2
							})
						end
					end)
				end):catch(function(p4)
					v5:info(`GetFriendRecommendationsFromUserId failed: {p4}`)
				end)
			elseif fireAnalyticsEvent then
				fireAnalyticsEvent(eventNames.CarouselLoadedWithUsers, {
					friendCount = v9,
					recommendationCount = 0,
					recommendationLimit = true,
					refreshCount = v6,
					fetchedRecommendations = false
				})
			end

			return promise.resolve(data)
		end)
	end
end
