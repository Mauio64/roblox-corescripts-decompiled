local parent = script:FindFirstAncestor("GraphQLServer").Parent
local HttpService = game:GetService("HttpService")

local Cryo = require(parent.Cryo)

require(script.Parent.Parent.generatedTypes)

require(parent.LuauPolyfill)

local ProfileInsightsConnector = require(script.Parent.Parent.connectors.ProfileInsightsConnector)
local findProfileInsightsByUserIds = ProfileInsightsConnector.findProfileInsightsByUserIds
local findProfileInsightsByUserIdsFeed = ProfileInsightsConnector.findProfileInsightsByUserIdsFeed

local SharedFlags = require(parent.SharedFlags)
local FFlagPlayerSearchEnableOnlineFrequents = SharedFlags.FFlagPlayerSearchEnableOnlineFrequents

local function fn(p, p2: string) -- 7 equivalent calls inferred from this helper
	for _, profileInsight in p.profileInsights do
		if profileInsight[p2] then
			return profileInsight[p2]
		end
	end

	return {}
end

return {
	ProfileInsights = {
		targetUserId = function(p)
			return p.targetUser
		end,
		mutualFriends = function(p)
			local v = fn(p, "mutualFriendInsight") -- inferred equivalent call
			local v2 = not v and {} or v.mutualFriends

			if v2 then
				return Cryo.List.foldLeft(Cryo.Dictionary.keys(v2), function(list, id)
					local v3 = v2[id]
					table.insert(list, {
						id = id,
						username = v3.username,
						displayName = v3.displayName
					})

					return list
				end, {})
			end

			return {}
		end,
		isOfflineFrequents = function(p): boolean
			local v = fn(p, "offlineFrequentsInsight") -- inferred equivalent call
			local v2

			if FFlagPlayerSearchEnableOnlineFrequents then
				local flag = true

				for _, profileInsight in p.profileInsights do
					if profileInsight.playedTogetherInsight then
						v2 = profileInsight.playedTogetherInsight
						flag = false
						break
					end
				end

				if flag then
					v2 = {}
				end
			end

			if FFlagPlayerSearchEnableOnlineFrequents then
				if v and v.havePlayedTogether or v2 and v2.havePlayedTogether then
					return true
				end

				return false
			elseif v and v.havePlayedTogether then
				return true
			else
				return false
			end
		end,
		friendshipAgeUnixSeconds = function(p)
			local v = fn(p, "friendshipAgeInsight") -- inferred equivalent call
			return v.friendsSinceDateTime and v.friendsSinceDateTime.seconds or -1
		end,
		friendRequestOriginSource = function(p)
			return fn(p, "friendRequestOriginInsight").friendRequestOriginSource or -1 -- inferred equivalent call
		end,
		accountCreationDateUnixSeconds = function(p)
			local v = fn(p, "accountCreationDateInsight") -- inferred equivalent call
			return v.accountCreatedDateTime and v.accountCreatedDateTime.seconds or -1
		end,
		localizedCountryName = function(p)
			local v = fn(p, "accountLocationInsight") -- inferred equivalent call
			return v and v.localizedCountryName or ""
		end,
		userAgeVerifiedBracket = function(p)
			local v = fn(p, "userAgeVerifiedInsight") -- inferred equivalent call

			if v and v.namespace and v.verifiedAgeBandLabel then
				return `{v.namespace}.{v.verifiedAgeBandLabel}`
			end

			return ""
		end
	},
	ProfileInsightsPages = {
		id = function(p)
			if p.pageId then
				return p.pageId
			end

			return (HttpService:GenerateGUID(false))
		end,
		profileInsights = function(p)
			return p.profileInsights
		end
	},
	Query = {
		profilesInsights = function(_, data, p)
			local userIds = data.userIds
			local count = data.count
			local pageId = data.pageId
			local v

			if FFlagPlayerSearchEnableOnlineFrequents then
				v = data.rankingStrategy
			end

			return findProfileInsightsByUserIdsFeed(userIds, count, pageId, v, p.fetchImpl)
		end,
		profilesInsightsByUserIds = function(_, data, p)
			return findProfileInsightsByUserIds(data.userIds, data.count, data.rankingStrategy, p.fetchImpl)
		end
	}
}
