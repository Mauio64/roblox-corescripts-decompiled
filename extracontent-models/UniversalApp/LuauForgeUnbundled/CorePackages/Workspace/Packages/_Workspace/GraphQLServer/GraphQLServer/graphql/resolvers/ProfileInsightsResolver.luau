local HttpService = game:GetService("HttpService")

local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/Cryo")

require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/GraphQLServer/graphql/generatedTypes")

require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/LuauPolyfill")

local ProfileInsightsConnector = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/GraphQLServer/graphql/connectors/ProfileInsightsConnector")
local findProfileInsightsByUserIds = ProfileInsightsConnector.findProfileInsightsByUserIds
local findProfileInsightsByUserIdsFeed = ProfileInsightsConnector.findProfileInsightsByUserIdsFeed

local fFlagPlayerSearchEnableOnlineFrequents = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/SharedFlags").FFlagPlayerSearchEnableOnlineFrequents

return {
	ProfileInsights = {
		targetUserId = function(p2)
			return p2.targetUser
		end,
		mutualFriends = function(p2)
			local flag = true
			local v5

			for k, profileInsight in p2.profileInsights do
				if profileInsight.mutualFriendInsight then
					v5 = profileInsight.mutualFriendInsight
					flag = false
					break
				end
			end

			if flag then
				v5 = {}
			end

			local v6 = not v5 and {} or v5.mutualFriends

			if v6 then
				return Cryo.List.foldLeft(Cryo.Dictionary.keys(v6), function(list, p3)
					local v7 = v6[p3]
					table.insert(list, {
						id = p3,
						username = v7.username,
						displayName = v7.displayName
					})

					return list
				end, {})
			end

			return {}
		end,
		isOfflineFrequents = function(p2): boolean
			local flag = true
			local v5

			for k, profileInsight in p2.profileInsights do
				if profileInsight.offlineFrequentsInsight then
					v5 = profileInsight.offlineFrequentsInsight
					flag = false
					break
				end
			end

			if flag then
				v5 = {}
			end

			local v6

			if fFlagPlayerSearchEnableOnlineFrequents then
				local flag2 = true

				for k, profileInsight in p2.profileInsights do
					if profileInsight.playedTogetherInsight then
						v6 = profileInsight.playedTogetherInsight
						flag2 = false
						break
					end
				end

				if flag2 then
					v6 = {}
				end
			end

			if fFlagPlayerSearchEnableOnlineFrequents then
				if v5 and v5.havePlayedTogether or v6 and v6.havePlayedTogether then
					return true
				end

				return false
			elseif v5 and v5.havePlayedTogether then
				return true
			else
				return false
			end
		end,
		friendshipAgeUnixSeconds = function(p2)
			local flag = true
			local v5

			for k, profileInsight in p2.profileInsights do
				if profileInsight.friendshipAgeInsight then
					v5 = profileInsight.friendshipAgeInsight
					flag = false
					break
				end
			end

			if flag then
				v5 = {}
			end

			return v5.friendsSinceDateTime and v5.friendsSinceDateTime.seconds or -1
		end,
		friendRequestOriginSource = function(p2)
			local flag = true
			local v5

			for k, profileInsight in p2.profileInsights do
				if profileInsight.friendRequestOriginInsight then
					v5 = profileInsight.friendRequestOriginInsight
					flag = false
					break
				end
			end

			if flag then
				v5 = {}
			end

			return v5.friendRequestOriginSource or -1
		end,
		accountCreationDateUnixSeconds = function(p2)
			local flag = true
			local v5

			for k, profileInsight in p2.profileInsights do
				if profileInsight.accountCreationDateInsight then
					v5 = profileInsight.accountCreationDateInsight
					flag = false
					break
				end
			end

			if flag then
				v5 = {}
			end

			return v5.accountCreatedDateTime and v5.accountCreatedDateTime.seconds or -1
		end,
		localizedCountryName = function(p2)
			local flag = true
			local v5

			for k, profileInsight in p2.profileInsights do
				if profileInsight.accountLocationInsight then
					v5 = profileInsight.accountLocationInsight
					flag = false
					break
				end
			end

			if flag then
				v5 = {}
			end

			return v5 and v5.localizedCountryName or ""
		end,
		userAgeVerifiedBracket = function(p2)
			local flag = true
			local v5

			for k, profileInsight in p2.profileInsights do
				if profileInsight.userAgeVerifiedInsight then
					v5 = profileInsight.userAgeVerifiedInsight
					flag = false
					break
				end
			end

			if flag then
				v5 = {}
			end

			if v5 and v5.namespace and v5.verifiedAgeBandLabel then
				return `{v5.namespace}.{v5.verifiedAgeBandLabel}`
			end

			return ""
		end
	},
	ProfileInsightsPages = {
		id = function(self)
			if self.pageId then
				return self.pageId
			end

			return (HttpService:GenerateGUID(false))
		end,
		profileInsights = function(p2)
			return p2.profileInsights
		end
	},
	Query = {
		profilesInsights = function(p2, data, p3)
			local userIds = data.userIds
			local count = data.count
			local pageId = data.pageId
			local v6 = if fFlagPlayerSearchEnableOnlineFrequents then data.rankingStrategy else nil
			return findProfileInsightsByUserIdsFeed(userIds, count, pageId, v6, p3.fetchImpl)
		end,
		profilesInsightsByUserIds = function(p2, data, p3)
			return findProfileInsightsByUserIds(
				data.userIds,
				data.count,
				data.rankingStrategy,
				p3.fetchImpl
			)
		end
	}
}
