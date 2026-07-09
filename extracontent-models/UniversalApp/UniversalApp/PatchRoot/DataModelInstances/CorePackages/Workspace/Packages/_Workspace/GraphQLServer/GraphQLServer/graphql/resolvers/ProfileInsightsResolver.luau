local Parent = script:FindFirstAncestor("GraphQLServer").Parent
local HttpService = game:GetService("HttpService")
local Cryo = require(Parent.Cryo)

require(script.Parent.Parent.generatedTypes)
require(Parent.LuauPolyfill)

local ProfileInsightsConnector = require(script.Parent.Parent.connectors.ProfileInsightsConnector)
local findProfileInsightsByUserIds = ProfileInsightsConnector.findProfileInsightsByUserIds
local findProfileInsightsByUserIdsFeed = ProfileInsightsConnector.findProfileInsightsByUserIdsFeed
local FFlagPlayerSearchEnableOnlineFrequents = require(Parent.SharedFlags).FFlagPlayerSearchEnableOnlineFrequents

return {
	ProfileInsights = {
		targetUserId = function(p1) -- line: 39
			return p1.targetUser
		end,
		mutualFriends = function(p2) -- line: 42
			-- upvalues: Cryo (copy)
			local g17 = nil
			local mutualFriendInsight = nil

			for _, v15 in p2.profileInsights do
				if v15.mutualFriendInsight then
					mutualFriendInsight = v15.mutualFriendInsight
					g17 = true
				end

				if g17 then
					break
				end
			end

			if not g17 then
				mutualFriendInsight = {}
			end

			g17 = false

			local v18 = if not mutualFriendInsight then {} else mutualFriendInsight.mutualFriends

			if not v18 then
				return {}
			end

			local v19 = v18

			return Cryo.List.foldLeft(Cryo.Dictionary.keys(v19), function(p3, p4) -- line: 53
				-- upvalues: v19 (copy)
				local v60 = v19[p4]

				table.insert(p3, {
					id = p4,
					username = v60.username,
					displayName = v60.displayName
				})

				return p3
			end, {})
		end,
		isOfflineFrequents = function(p5) -- line: 64
			-- upvalues: FFlagPlayerSearchEnableOnlineFrequents (copy)
			local g24 = nil
			local g28 = nil
			local offlineFrequentsInsight = nil
			local playedTogetherInsight = nil

			for _, v22 in p5.profileInsights do
				if v22.offlineFrequentsInsight then
					offlineFrequentsInsight = v22.offlineFrequentsInsight
					g24 = true
				end

				if g24 then
					break
				end
			end

			if not g24 then
				offlineFrequentsInsight = {}
			end

			g24 = false

			if FFlagPlayerSearchEnableOnlineFrequents then
				for _, v26 in p5.profileInsights do
					if v26.playedTogetherInsight then
						playedTogetherInsight = v26.playedTogetherInsight
						g28 = true
					end

					if g28 then
						break
					end
				end

				if not g28 then
					playedTogetherInsight = {}
				end
			else
				playedTogetherInsight = nil
			end

			g28 = false

			if FFlagPlayerSearchEnableOnlineFrequents then
				if offlineFrequentsInsight and offlineFrequentsInsight.havePlayedTogether or playedTogetherInsight and playedTogetherInsight.havePlayedTogether then
					return true
				end

				return false
			end

			if offlineFrequentsInsight and offlineFrequentsInsight.havePlayedTogether then
				return true
			end

			return false
		end,
		friendshipAgeUnixSeconds = function(p6) -- line: 80
			local friendshipAgeInsight

			for _, v31 in p6.profileInsights do
				if v31.friendshipAgeInsight then
					friendshipAgeInsight = v31.friendshipAgeInsight

					return friendshipAgeInsight.friendsSinceDateTime and friendshipAgeInsight.friendsSinceDateTime.seconds or -1
				end
			end

			friendshipAgeInsight = {}

			return friendshipAgeInsight.friendsSinceDateTime and friendshipAgeInsight.friendsSinceDateTime.seconds or -1
		end,
		friendRequestOriginSource = function(p7) -- line: 85
			local friendRequestOriginInsight

			for _, v35 in p7.profileInsights do
				if v35.friendRequestOriginInsight then
					friendRequestOriginInsight = v35.friendRequestOriginInsight

					return friendRequestOriginInsight.friendRequestOriginSource or -1
				end
			end

			friendRequestOriginInsight = {}

			return friendRequestOriginInsight.friendRequestOriginSource or -1
		end,
		accountCreationDateUnixSeconds = function(p8) -- line: 90
			local accountCreationDateInsight

			for _, v39 in p8.profileInsights do
				if v39.accountCreationDateInsight then
					accountCreationDateInsight = v39.accountCreationDateInsight

					return accountCreationDateInsight.accountCreatedDateTime and accountCreationDateInsight.accountCreatedDateTime.seconds or -1
				end
			end

			accountCreationDateInsight = {}

			return accountCreationDateInsight.accountCreatedDateTime and accountCreationDateInsight.accountCreatedDateTime.seconds or -1
		end,
		localizedCountryName = function(p9) -- line: 98
			local accountLocationInsight

			for _, v43 in p9.profileInsights do
				if v43.accountLocationInsight then
					accountLocationInsight = v43.accountLocationInsight

					return accountLocationInsight and accountLocationInsight.localizedCountryName or ""
				end
			end

			accountLocationInsight = {}

			return accountLocationInsight and accountLocationInsight.localizedCountryName or ""
		end,
		userAgeVerifiedBracket = function(p10) -- line: 102
			local g49 = nil
			local userAgeVerifiedInsight = nil

			for _, v47 in p10.profileInsights do
				if v47.userAgeVerifiedInsight then
					userAgeVerifiedInsight = v47.userAgeVerifiedInsight
					g49 = true
				end

				if g49 then
					break
				end
			end

			if not g49 then
				userAgeVerifiedInsight = {}
			end

			g49 = false

			if userAgeVerifiedInsight and userAgeVerifiedInsight.namespace and userAgeVerifiedInsight.verifiedAgeBandLabel then
				return `{ userAgeVerifiedInsight.namespace }.{ userAgeVerifiedInsight.verifiedAgeBandLabel }`
			end

			return ""
		end
	},
	ProfileInsightsPages = {
		id = function(p11) -- line: 118
			-- upvalues: HttpService (copy)
			if p11.pageId then
				return p11.pageId
			end

			return (HttpService:GenerateGUID(false))
		end,
		profileInsights = function(p12) -- line: 121
			return p12.profileInsights
		end
	},
	Query = {
		profilesInsights = function(_, p14, p15) -- line: 127
			-- upvalues: findProfileInsightsByUserIdsFeed (copy), FFlagPlayerSearchEnableOnlineFrequents (copy)
			return findProfileInsightsByUserIdsFeed(p14.userIds, p14.count, p14.pageId, if not FFlagPlayerSearchEnableOnlineFrequents then nil else p14.rankingStrategy, p15.fetchImpl)
		end,
		profilesInsightsByUserIds = function(_, p17, p18) -- line: 136
			-- upvalues: findProfileInsightsByUserIds (copy)
			return findProfileInsightsByUserIds(p17.userIds, p17.count, p17.rankingStrategy, p18.fetchImpl)
		end
	}
}
