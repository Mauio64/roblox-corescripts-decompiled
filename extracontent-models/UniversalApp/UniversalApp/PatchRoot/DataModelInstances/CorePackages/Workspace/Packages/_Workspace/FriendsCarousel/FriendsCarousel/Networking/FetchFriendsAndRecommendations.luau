local UserInputService = game:GetService("UserInputService")
local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local dependencies = require(ParentParent.dependencies)
local ThirdPartyUserService = game:GetService("ThirdPartyUserService")
local NetworkingFriends = dependencies.NetworkingFriends
local NetworkingAliases = dependencies.NetworkingAliases
local RoduxFriends = dependencies.RoduxFriends
local RoduxAnalytics = dependencies.RoduxAnalytics
local Promise = dependencies.Promise
local Dash = dependencies.Dash
local showRecommendations = require(ParentParent.Utils.showRecommendations)
local EventNames = require(ParentParent.Analytics).EventNames
local Analytics = require(ParentParent.Analytics).Analytics
local FetchNames = require(ParentParent.Analytics.FetchNames)
local RetrievalStatus = require(ParentParentParent.UIBlox).App.Loading.Enum.RetrievalStatus
local UserSorts = require(ParentParent.Common.UserSorts)
local RECOMMENDATION_SESSION_ID_KEY = require(ParentParent.Common.Constants).RECOMMENDATION_SESSION_ID_KEY
local SocialCommon = dependencies.SocialCommon
local RecommendationSourceEnum = SocialCommon.Enums.RecommendationSourceEnum
local ContextualInfoTypes = SocialCommon.Enums.ContextualInfoTypes
local Timers = require(ParentParentParent.SocialLuaAnalytics).Analytics.Timing.Timers
local v23 = dependencies.logger:new("FriendsCarousel/" .. script.Name)
local isSubjectToDesktopPolicies = dependencies.isSubjectToDesktopPolicies
local FFlagEnableRecommendationsForPCGDK = require(ParentParentParent.SharedFlags).FFlagEnableRecommendationsForPCGDK
local FFlagFixIsConsoleCheckForSocialCarousel = require(ParentParentParent.SharedFlags).FFlagFixIsConsoleCheckForSocialCarousel

local function v27(p1) -- line: 40
	-- upvalues: showRecommendations (copy), isSubjectToDesktopPolicies (copy), FFlagEnableRecommendationsForPCGDK (copy), ThirdPartyUserService (copy), FFlagFixIsConsoleCheckForSocialCarousel (copy), UserInputService (copy)
	return showRecommendations(p1) and not isSubjectToDesktopPolicies() or (showRecommendations(p1) and (not not FFlagEnableRecommendationsForPCGDK and (not not ThirdPartyUserService and ThirdPartyUserService:HaveActiveUser())) or showRecommendations(p1) and (FFlagFixIsConsoleCheckForSocialCarousel and UserInputService.PreferredInput == Enum.PreferredInput.Gamepad))
end

local n1 = 0

return function(t1: {[any]: any}?) -- line: 58
	-- upvalues: Analytics (copy), Timers (copy), NetworkingFriends (copy), UserSorts (copy), n1 (ref), Dash (copy), EventNames (copy), RetrievalStatus (copy), FetchNames (copy), NetworkingAliases (copy), Promise (copy), v23 (copy), v27 (copy), ContextualInfoTypes (copy), RoduxFriends (copy), RecommendationSourceEnum (copy), RoduxAnalytics (copy), RECOMMENDATION_SESSION_ID_KEY (copy)
	return function(p2) -- line: 59
		-- upvalues: Analytics (copy), Timers (copy), NetworkingFriends (copy), UserSorts (copy), n1 (ref), t1 (copy), Dash (copy), EventNames (copy), RetrievalStatus (copy), FetchNames (copy), NetworkingAliases (copy), Promise (copy), v23 (copy), v27 (copy), ContextualInfoTypes (copy), RoduxFriends (copy), RecommendationSourceEnum (copy), RoduxAnalytics (copy), RECOMMENDATION_SESSION_ID_KEY (copy)
		local str = tostring(p2:getState().LocalUserId)
		local fireAnalyticsEvent = Analytics({
			infoForAllEvents = {
				uid = str
			}
		}).fireAnalyticsEvent
		local v34 = Timers()
		local v35 = v34.start()

		return p2:dispatch(NetworkingFriends.GetFriendsFromUserId.API(str, {
			userSort = UserSorts.StatusFrequents
		})):andThen(function(p3) -- line: 73
			-- upvalues: n1 (ref), t1 (copy), Dash (copy), v34 (copy), v35 (copy), fireAnalyticsEvent (copy), EventNames (copy), RetrievalStatus (copy), FetchNames (copy), p2 (copy), NetworkingAliases (copy), Promise (copy), v23 (copy), v27 (copy), NetworkingFriends (copy), str (copy), ContextualInfoTypes (copy), RoduxFriends (copy), RecommendationSourceEnum (copy), RoduxAnalytics (copy), RECOMMENDATION_SESSION_ID_KEY (copy)
			local data = p3.responseBody.data
			local v38 = data and #data or 0

			n1 = if not t1 or not t1.refresh then n1 else n1 + 1

			local v39 = if not data then {} else Dash.map(data, function(p4) -- line: 78
				return p4.id
			end)
			local v40 = v34.stop(v35)

			fireAnalyticsEvent(EventNames.FriendsEndpointLoadingTime, {
				status = RetrievalStatus.Done.rawValue(),
				loadingTime = v40,
				fetch = FetchNames.OldAllFriends
			})
			p2:dispatch(NetworkingAliases.GetTagsFromUserIds.API(v39)):andThen(function() -- line: 93
				-- upvalues: Promise (copy)
				return Promise.resolve()
			end):catch(function(p5) -- line: 96
				-- upvalues: v23 (copy)
				v23:info(`GetTagsFromUserIds failed: { p5 }`)
			end)

			if v27(v38) then
				p2:dispatch(NetworkingFriends.GetFriendRecommendationsFromUserId.API({
					targetUserId = str
				})):andThen(function(p6) -- line: 105
					-- upvalues: Dash (copy), ContextualInfoTypes (copy), p2 (copy), RoduxFriends (copy), RecommendationSourceEnum (copy), RoduxAnalytics (copy), RECOMMENDATION_SESSION_ID_KEY (copy), Promise (copy), fireAnalyticsEvent (copy), EventNames (copy), v38 (copy), n1 (ref)
					local data2 = p6.responseBody.data
					local v45 = Dash.map(data2, function(p7) -- line: 107
						-- upvalues: ContextualInfoTypes (copy)
						if p7.contextType == ContextualInfoTypes.Contacts then
							return p7.contactId
						end

						return p7.id
					end)

					p2:dispatch(RoduxFriends.Actions.RecommendationSourceCreated({
						source = RecommendationSourceEnum.HomepageFriendsCarousel,
						recommendationIds = v45
					}))

					local recommendationRequestId = p6.responseBody.recommendationRequestId

					p2:dispatch(RoduxAnalytics.Actions.SessionIdUpdated({
						sessionKey = RECOMMENDATION_SESSION_ID_KEY,
						sessionId = recommendationRequestId
					}))

					return Promise.resolve(p6):andThen(function(p8) -- line: 123
						-- upvalues: fireAnalyticsEvent (copy), EventNames (copy), v38 (copy), n1 (ref)
						if fireAnalyticsEvent then
							local data3 = p8.responseBody.data
							local v51 = data3 and #data3 or 0
							local recommendationRequestId2 = p8.responseBody.recommendationRequestId

							fireAnalyticsEvent(EventNames.CarouselLoadedWithUsers, {
								recommendationLimit = true,
								fetchedRecommendations = true,
								friendCount = v38,
								recommendationCount = v51,
								refreshCount = n1,
								recommendationSessionId = recommendationRequestId2
							})
						end
					end)
				end):catch(function(p9) -- line: 141
					-- upvalues: v23 (copy)
					v23:info(`GetFriendRecommendationsFromUserId failed: { p9 }`)
				end)
			elseif fireAnalyticsEvent then
				fireAnalyticsEvent(EventNames.CarouselLoadedWithUsers, {
					recommendationCount = 0,
					recommendationLimit = true,
					fetchedRecommendations = false,
					friendCount = v38,
					refreshCount = n1
				})
			end

			return Promise.resolve(data)
		end)
	end
end
