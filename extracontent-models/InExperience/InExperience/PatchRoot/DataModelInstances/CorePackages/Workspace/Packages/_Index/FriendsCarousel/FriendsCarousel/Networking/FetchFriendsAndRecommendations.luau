local UserInputService = game:GetService("UserInputService")

local parent = script.Parent.Parent
local parent2 = parent.Parent
local dependencies = require(parent.dependencies)
local ThirdPartyUserService = game:GetService("ThirdPartyUserService")

local networkingFriends = dependencies.NetworkingFriends
local networkingAliases = dependencies.NetworkingAliases
local roduxFriends = dependencies.RoduxFriends
local roduxAnalytics = dependencies.RoduxAnalytics
local promise = dependencies.Promise
local dash = dependencies.Dash
local showRecommendations = require(parent.Utils.showRecommendations)

local Analytics = require(parent.Analytics)
local EventNames = Analytics.EventNames
local Analytics2 = require(parent.Analytics)
local analytics = Analytics2.Analytics
local FetchNames = require(parent.Analytics.FetchNames)

local UIBlox = require(parent2.UIBlox)
local RetrievalStatus = UIBlox.App.Loading.Enum.RetrievalStatus

local UserSorts = require(parent.Common.UserSorts)
local Constants = require(parent.Common.Constants)
local RECOMMENDATION_SESSION_ID_KEY = Constants.RECOMMENDATION_SESSION_ID_KEY
local socialCommon = dependencies.SocialCommon
local recommendationSourceEnum = socialCommon.Enums.RecommendationSourceEnum
local contextualInfoTypes = socialCommon.Enums.ContextualInfoTypes

local SocialLuaAnalytics = require(parent2.SocialLuaAnalytics)
local Timers = SocialLuaAnalytics.Analytics.Timing.Timers

local v = dependencies.logger:new("FriendsCarousel/" .. script.Name)

local isSubjectToDesktopPolicies = dependencies.isSubjectToDesktopPolicies
local SharedFlags = require(parent2.SharedFlags)
local FFlagEnableRecommendationsForPCGDK = SharedFlags.FFlagEnableRecommendationsForPCGDK
local SharedFlags2 = require(parent2.SharedFlags)
local FFlagFixIsConsoleCheckForSocialCarousel = SharedFlags2.FFlagFixIsConsoleCheckForSocialCarousel

local SharedFlags3 = require(parent2.SharedFlags)
local FFlagSocialCarouselMigrateRecommendations = SharedFlags3.FFlagSocialCarouselMigrateRecommendations

local SharedFlags4 = require(parent2.SharedFlags)
local FFlagLuaSupportMicroGamepadPreferredInput = SharedFlags4.FFlagLuaSupportMicroGamepadPreferredInput

local function fn(p)
	return showRecommendations(p) and not isSubjectToDesktopPolicies()
		or showRecommendations(p)
		and FFlagEnableRecommendationsForPCGDK
		and ThirdPartyUserService
		and ThirdPartyUserService:HaveActiveUser()
		or showRecommendations(p)
		and FFlagFixIsConsoleCheckForSocialCarousel
		and (UserInputService.PreferredInput == Enum.PreferredInput.Gamepad or FFlagLuaSupportMicroGamepadPreferredInput and UserInputService.PreferredInput == Enum.PreferredInput.MicroGamepad)
end

local refreshCount = 0

return function(p)
	return function(object)
		local localUserId = tostring(object:getState().LocalUserId)

		local fireAnalyticsEvent = analytics({
			infoForAllEvents = { uid = localUserId }
		}).fireAnalyticsEvent

		local timers = Timers()
		local v2 = timers.start()

		return object:dispatch(networkingFriends.GetFriendsFromUserId.API(localUserId, {
			userSort = UserSorts.StatusFrequents
		})):andThen(function(p2)
			local data = p2.responseBody.data
			local friendCount = data and #data or 0
			local v3

			if p and p.refresh then
				v3 = refreshCount + 1
			else
				v3 = refreshCount
			end

			refreshCount = v3

			local v4 = not data and {} or dash.map(data, function(p3)
				return p3.id
			end)

			local loadingTime = timers.stop(v2)

			fireAnalyticsEvent(EventNames.FriendsEndpointLoadingTime, {
				status = RetrievalStatus.Done.rawValue(),
				loadingTime = loadingTime,
				fetch = FetchNames.OldAllFriends
			})

			object:dispatch(networkingAliases.GetTagsFromUserIds.API(v4)):andThen(function()
				return promise.resolve()
			end):catch(function(p3)
				v:info(`GetTagsFromUserIds failed: {p3}`)
			end)

			if fn(friendCount) and not FFlagSocialCarouselMigrateRecommendations then
				object:dispatch(networkingFriends.GetFriendRecommendationsFromUserId.API({
					targetUserId = localUserId
				})):andThen(function(p3)
					local data2 = p3.responseBody.data
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

					local recommendationRequestId = p3.responseBody.recommendationRequestId
					object:dispatch(roduxAnalytics.Actions.SessionIdUpdated({
						sessionKey = RECOMMENDATION_SESSION_ID_KEY,
						sessionId = recommendationRequestId
					}))

					return promise.resolve(p3):andThen(function(p4)
						if fireAnalyticsEvent then
							local data3 = p4.responseBody.data
							local recommendationCount = data3 and #data3 or 0
							local recommendationRequestId2 = p4.responseBody.recommendationRequestId

							fireAnalyticsEvent(EventNames.CarouselLoadedWithUsers, {
								friendCount = friendCount,
								recommendationCount = recommendationCount,
								recommendationLimit = true,
								refreshCount = refreshCount,
								fetchedRecommendations = true,
								recommendationSessionId = recommendationRequestId2
							})
						end
					end)
				end):catch(function(p3)
					v:info(`GetFriendRecommendationsFromUserId failed: {p3}`)
				end)
			elseif fireAnalyticsEvent then
				fireAnalyticsEvent(EventNames.CarouselLoadedWithUsers, {
					friendCount = friendCount,
					recommendationCount = 0,
					recommendationLimit = true,
					refreshCount = refreshCount,
					fetchedRecommendations = false
				})
			end

			return promise.resolve(data)
		end)
	end
end
