local Parent = script:FindFirstAncestor("ProfileInsights").Parent
local Signals = require(Parent.Signals)
local createSignal = Signals.createSignal
local createComputed = Signals.createComputed
local ProfileInsightsModel = require(script.Parent.ProfileInsightsModel)
local HttpService = game:GetService("HttpService")
local v7 = game:DefineFastInt("ProfileInsightsStoreHttpTimeout", 1500)
local FFlagAddFriendsPageTrustedFriendRequestSection = require(Parent.SharedFlags).FFlagAddFriendsPageTrustedFriendRequestSection
local UrlBuilder = require(Parent.UrlBuilder)
local UrlBuilder2 = UrlBuilder.UrlBuilder
local UrlBase = UrlBuilder.UrlBase
local v12 = UrlBuilder2.new({
	path = "profile-insights-api/v1/multiProfileInsights",
	base = UrlBase.APIS
})()

local function makeHttpCall(t1: {[any]: any}, n1: number?, s1: string?, p1: ((...any) -> ...any)) -- line: 49
	-- upvalues: HttpService (copy), v12 (copy), v7 (copy)
	HttpService:RequestInternal({
		Method = "POST",
		Priority = 0,
		Url = v12,
		Body = HttpService:JSONEncode({
			userIds = t1,
			count = if not s1 then n1 or 2 else nil,
			rankingStrategy = s1
		}),
		Timeout = v7,
		CachePolicy = Enum.HttpCachePolicy.None,
		Headers = {
			["Content-Type"] = "application/json",
			Accept = "application/json"
		},
		RequestType = Enum.HttpRequestType.Default
	}):Start(function(p2, p3) -- line: 73
		-- upvalues: HttpService (copy), p1 (copy)
		local result = nil
		local v29 = false

		if p3 and p3.Body then
			v29, result = pcall(function() -- line: 77
				-- upvalues: HttpService (copy), p3 (copy)
				return HttpService:JSONDecode(p3.Body)
			end)
		end

		p1(not not p2 and v29, result)
	end)
end
local function createFetchResult(s2: string, p4) -- line: 85
	return {
		status = s2,
		data = p4
	}
end

return createComputed(function(_) -- line: 96
	-- upvalues: createSignal (copy), ProfileInsightsModel (copy), FFlagAddFriendsPageTrustedFriendRequestSection (copy), makeHttpCall (copy), HttpService (copy)
	local t2 = {}
	local t3 = {}

	local function getCacheKey(t4: {[any]: any}, n2: number?, s3: string?) -- line: 101
		return table.concat(t4, ",") .. tostring(n2) .. tostring(s3)
	end
	local function mergeWithExisting(s4: string, t5: {[any]: any}) -- line: 105
		-- upvalues: t3 (copy)
		local v35 = t3[s4]

		if v35 then
			local t6 = {}
			local t7 = { table.unpack(v35.getProfileInsights(false)) }
			local v38 = false

			for _, v40 in t7 do
				t6[v40.targetUserId] = true
			end

			for _, v42 in t5 do
				if not t6[v42.targetUserId] then
					t6[v42.targetUserId] = true
					table.insert(t7, v42)
					v38 = true
				end
			end

			if v38 then
				return t7
			end

			return (v35.getProfileInsights(false))
		end

		return t5
	end

	return {
		getProfileInsightsByUserId = function(t8: {[any]: any}) -- line: 132
			-- upvalues: createSignal (copy), t2 (copy), ProfileInsightsModel (copy), FFlagAddFriendsPageTrustedFriendRequestSection (copy), makeHttpCall (copy)
			local userIds = t8.userIds
			local count = t8.count
			local rankingStrategy = t8.rankingStrategy

			if not userIds or #userIds == 0 then
				return createSignal({
					status = "success",
					data = {}
				})
			end

			local v47 = table.concat(userIds, ",") .. tostring(count) .. tostring(rankingStrategy)

			if t2[v47] then
				local v48 = createSignal
				local v49 = t2[v47]

				return v48({
					status = "success",
					data = v49
				})
			end

			t2[v47] = ProfileInsightsModel.createProfileInsightsSignalList()

			if FFlagAddFriendsPageTrustedFriendRequestSection and t8.skipFetch then
				local v50 = createSignal
				local v51 = t2[v47]

				return v50({
					status = "success",
					data = v51
				})
			end

			local v52 = t2[v47]
			local t9 = {
				status = "fetching",
				data = v52
			}
			local v54, v55 = createSignal(t9)

			makeHttpCall(userIds, count, rankingStrategy, function(p6, p7) -- line: 157
				-- upvalues: t2 (copy), v47 (copy), ProfileInsightsModel (copy), v55 (copy)
				if p6 and p7.userInsights then
					t2[v47].setProfileInsights(ProfileInsightsModel.createProfileInsightsList(p7.userInsights))

					local v72 = t2[v47]
					local t10 = {
						status = "success",
						data = v72
					}

					v55(t10)

					return
				end

				local t11 = {
					status = "failed",
					data = {}
				}

				v55(t11)
			end)

			return v54
		end,
		getProfileInsightsByPage = function(t12: {[any]: any}) -- line: 172
			-- upvalues: HttpService (copy), t3 (copy), ProfileInsightsModel (copy), createSignal (copy), t2 (copy), mergeWithExisting (copy), makeHttpCall (copy)
			local v57 = if not t12.pageId then HttpService:GenerateGUID(false) else t12.pageId
			local userIds = t12.userIds
			local count = t12.count
			local rankingStrategy = t12.rankingStrategy

			if not t3[v57] then
				t3[v57] = ProfileInsightsModel.createProfileInsightsSignalList()
			end

			if not userIds or #userIds == 0 then
				local v61 = createSignal
				local v62 = t3[v57]

				return v61({
					status = "success",
					data = v62
				})
			end

			local v63 = table.concat(userIds, ",") .. tostring(count) .. tostring(rankingStrategy)

			if t2[v63] then
				t3[v57].setProfileInsights((mergeWithExisting(v57, t2[v63].getProfileInsights(false))))

				local v64 = createSignal
				local v65 = t3[v57]

				return v64({
					status = "success",
					data = v65
				})
			end

			t2[v63] = ProfileInsightsModel.createProfileInsightsSignalList()

			local v66 = createSignal
			local v67 = t3[v57]
			local v68, v69 = v66({
				status = "success",
				data = v67
			})

			makeHttpCall(userIds, count, rankingStrategy, function(p8, p9) -- line: 194
				-- upvalues: ProfileInsightsModel (copy), t2 (copy), v63 (copy), t3 (copy), v57 (copy), mergeWithExisting (copy), v69 (copy)
				if p8 and p9.userInsights then
					local v77 = ProfileInsightsModel.createProfileInsightsList(p9.userInsights)

					t2[v63].setProfileInsights(v77)
					t3[v57].setProfileInsights((mergeWithExisting(v57, v77)))

					local v78 = v69
					local v79 = t3[v57]

					v78({
						status = "success",
						data = v79
					})

					return
				end

				v69({
					status = "failed",
					data = {}
				})
			end)

			return v68
		end
	}
end)
