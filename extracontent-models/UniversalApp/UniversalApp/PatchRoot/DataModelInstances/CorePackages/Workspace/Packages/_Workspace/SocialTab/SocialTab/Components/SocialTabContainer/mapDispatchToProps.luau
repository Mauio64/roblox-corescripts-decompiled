local SocialTab = script:FindFirstAncestor("SocialTab")
local SocialTabParent = SocialTab.Parent
local Logger = require(SocialTab.Logger)
local dependencies = require(SocialTab.dependencies)
local Promise = dependencies.Promise
local GetUnreadConversationCount = require(SocialTabParent.SocialTabState).Requests.GetUnreadConversationCount
local GetPresencesFromUserIds = dependencies.NetworkingPresence.GetPresencesFromUserIds
local NetworkingFriends = dependencies.NetworkingFriends
local NetworkingUsers = dependencies.NetworkingUsers
local SocialLibraries = dependencies.SocialLibraries
local EnteredChatFromEntryPoint = require(SocialTabParent.AppChat.EnteredChatFromEntryPoint)
local AppPage = require(SocialTabParent.RobloxAppEnums).AppPage
local NavigateDown = require(SocialTabParent.NavigationRodux).Thunks.NavigateDown
local FFlagSignalsNavP3Dispatch = require(SocialTabParent.SharedFlags).FFlagSignalsNavP3Dispatch
local v15 = if not FFlagSignalsNavP3Dispatch then nil else require(SocialTabParent.RobloxAppNavigation).NavigationCommands

return function(p1) -- line: 23
	-- upvalues: NetworkingFriends (copy), Promise (copy), GetUnreadConversationCount (copy), SocialLibraries (copy), GetPresencesFromUserIds (copy), NetworkingUsers (copy), Logger (copy), EnteredChatFromEntryPoint (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v15 (copy), NavigateDown (copy)
	return {
		refreshPageData = function() -- line: 25
			-- upvalues: NetworkingFriends (copy), Promise (copy), p1 (copy), GetUnreadConversationCount (copy), SocialLibraries (copy), GetPresencesFromUserIds (copy), NetworkingUsers (copy), Logger (copy)
			local GetFriendRequestsCount = NetworkingFriends.GetFriendRequestsCount

			return Promise.all({
				p1(GetUnreadConversationCount.API()),
				p1(function(p2) -- line: 30
					-- upvalues: SocialLibraries (copy), p1 (copy), GetPresencesFromUserIds (copy), Promise (copy)
					local v23 = SocialLibraries.Dictionary.getDeepValue(p2:getState(), "SocialTab.Friends.byUserId.localUserId")

					if v23 then
						return p1(GetPresencesFromUserIds.API(v23))
					end

					return Promise.resolve()
				end),
				p1(GetFriendRequestsCount.API()),
				p1(function(p3) -- line: 43
					-- upvalues: p1 (copy), NetworkingUsers (copy)
					return p1(NetworkingUsers.GetUserV2FromUserId.API(p3:getState().LocalUserId))
				end)
			}):catch(function() -- line: 46
				-- upvalues: Logger (copy)
				Logger:info("Failed to refresh SocialTab data")
			end)
		end,
		fetchFriendsRequestsCount = function() -- line: 50
			-- upvalues: p1 (copy), NetworkingFriends (copy)
			return p1(NetworkingFriends.GetFriendRequestsCount.API())
		end,
		enteredChatFromEntryPoint = function(p4) -- line: 53
			-- upvalues: p1 (copy), EnteredChatFromEntryPoint (copy)
			return p1(EnteredChatFromEntryPoint(p4))
		end,
		navigateToFriendsPage = function() -- line: 56
			-- upvalues: AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v15 (copy), p1 (copy), NavigateDown (copy)
			local t1 = {
				name = AppPage.ViewFriends
			}

			if FFlagSignalsNavP3Dispatch then
				v15.down(v15.fromLegacyPage(t1))

				return
			end

			p1(NavigateDown(t1))
		end,
		navigateToAddFriendsPage = function() -- line: 66
			-- upvalues: AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v15 (copy), p1 (copy), NavigateDown (copy)
			local t2 = {
				name = AppPage.AddFriendsPage
			}

			if FFlagSignalsNavP3Dispatch then
				v15.down(v15.fromLegacyPage(t2))

				return
			end

			p1(NavigateDown(t2))
		end,
		navigateToUserSearch = function() -- line: 76
			-- upvalues: AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v15 (copy), p1 (copy), NavigateDown (copy)
			local t3 = {
				shouldShowUserSearchLandingPage = true,
				name = AppPage.UserSearch
			}

			if FFlagSignalsNavP3Dispatch then
				v15.down(v15.fromLegacyPage(t3))

				return
			end

			p1(NavigateDown(t3))
		end
	}
end
