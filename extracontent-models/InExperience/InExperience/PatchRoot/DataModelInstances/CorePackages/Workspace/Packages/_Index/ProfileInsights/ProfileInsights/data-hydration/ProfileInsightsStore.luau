local Parent = script:FindFirstAncestor("ProfileInsights").Parent
local Signals = require(Parent.Signals)
local createSignal = Signals.createSignal
local createComputed = Signals.createComputed
local ProfileInsightsModel = require(script.Parent.ProfileInsightsModel)
local HttpService = game:GetService("HttpService")
local v7 = game:DefineFastInt("ProfileInsightsStoreHttpTimeout", 1500)
local UrlBuilder = require(Parent.UrlBuilder)
local UrlBuilder2 = UrlBuilder.UrlBuilder
local UrlBase = UrlBuilder.UrlBase
local v11 = UrlBuilder2.new({
	path = "profile-insights-api/v1/multiProfileInsights",
	base = UrlBase.APIS
})()

local function makeHttpCall(t1: {[any]: any}, n1: number?, s1: string?, p1: ((...any) -> ...any)) -- line: 46
	-- upvalues: HttpService (copy), v11 (copy), v7 (copy)
	HttpService:RequestInternal({
		Method = "POST",
		Priority = 0,
		Url = v11,
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
	}):Start(function(p2, p3) -- line: 70
		-- upvalues: HttpService (copy), p1 (copy)
		local result = nil
		local v28 = false

		if p3 and p3.Body then
			v28, result = pcall(function() -- line: 74
				-- upvalues: HttpService (copy), p3 (copy)
				return HttpService:JSONDecode(p3.Body)
			end)
		end

		p1(not not p2 and v28, result)
	end)
end
local function createFetchResult(s2: string, p4) -- line: 82
	return {
		status = s2,
		data = p4
	}
end

return createComputed(function(_) -- line: 93
	-- upvalues: createSignal (copy), ProfileInsightsModel (copy), makeHttpCall (copy), HttpService (copy)
	local t2 = {}
	local t3 = {}

	local function getCacheKey(t4: {[any]: any}, n2: number?, s3: string?) -- line: 98
		return table.concat(t4, ",") .. tostring(n2) .. tostring(s3)
	end
	local function mergeWithExisting(s4: string, t5: {[any]: any}) -- line: 102
		-- upvalues: t3 (copy)
		local v34 = t3[s4]

		if v34 then
			local t6 = {}
			local t7 = { table.unpack(v34.getProfileInsights(false)) }
			local v37 = false

			for _, v39 in t7 do
				t6[v39.targetUserId] = true
			end

			for _, v41 in t5 do
				if not t6[v41.targetUserId] then
					t6[v41.targetUserId] = true
					table.insert(t7, v41)
					v37 = true
				end
			end

			if v37 then
				return t7
			end

			return (v34.getProfileInsights(false))
		end

		return t5
	end

	return {
		getProfileInsightsByUserId = function(t8: {[any]: any}) -- line: 129
			-- upvalues: createSignal (copy), t2 (copy), ProfileInsightsModel (copy), makeHttpCall (copy)
			local userIds = t8.userIds
			local count = t8.count
			local rankingStrategy = t8.rankingStrategy

			if not userIds or #userIds == 0 then
				return createSignal({
					status = "success",
					data = {}
				})
			end

			local v46 = table.concat(userIds, ",") .. tostring(count) .. tostring(rankingStrategy)

			if t2[v46] then
				local v47 = createSignal
				local v48 = t2[v46]

				return v47({
					status = "success",
					data = v48
				})
			end

			t2[v46] = ProfileInsightsModel.createProfileInsightsSignalList()

			local v49 = t2[v46]
			local t9 = {
				status = "fetching",
				data = v49
			}
			local v51, v52 = createSignal(t9)

			makeHttpCall(userIds, count, rankingStrategy, function(p6, p7) -- line: 148
				-- upvalues: t2 (copy), v46 (copy), ProfileInsightsModel (copy), v52 (copy)
				if p6 and p7.userInsights then
					t2[v46].setProfileInsights(ProfileInsightsModel.createProfileInsightsList(p7.userInsights))

					local v69 = t2[v46]
					local t10 = {
						status = "success",
						data = v69
					}

					v52(t10)

					return
				end

				local t11 = {
					status = "failed",
					data = {}
				}

				v52(t11)
			end)

			return v51
		end,
		getProfileInsightsByPage = function(t12: {[any]: any}) -- line: 163
			-- upvalues: HttpService (copy), t3 (copy), ProfileInsightsModel (copy), createSignal (copy), t2 (copy), mergeWithExisting (copy), makeHttpCall (copy)
			local v54 = if not t12.pageId then HttpService:GenerateGUID(false) else t12.pageId
			local userIds = t12.userIds
			local count = t12.count
			local rankingStrategy = t12.rankingStrategy

			if not t3[v54] then
				t3[v54] = ProfileInsightsModel.createProfileInsightsSignalList()
			end

			if not userIds or #userIds == 0 then
				local v58 = createSignal
				local v59 = t3[v54]

				return v58({
					status = "success",
					data = v59
				})
			end

			local v60 = table.concat(userIds, ",") .. tostring(count) .. tostring(rankingStrategy)

			if t2[v60] then
				t3[v54].setProfileInsights((mergeWithExisting(v54, t2[v60].getProfileInsights(false))))

				local v61 = createSignal
				local v62 = t3[v54]

				return v61({
					status = "success",
					data = v62
				})
			end

			t2[v60] = ProfileInsightsModel.createProfileInsightsSignalList()

			local v63 = createSignal
			local v64 = t3[v54]
			local v65, v66 = v63({
				status = "success",
				data = v64
			})

			makeHttpCall(userIds, count, rankingStrategy, function(p8, p9) -- line: 185
				-- upvalues: ProfileInsightsModel (copy), t2 (copy), v60 (copy), t3 (copy), v54 (copy), mergeWithExisting (copy), v66 (copy)
				if p8 and p9.userInsights then
					local v74 = ProfileInsightsModel.createProfileInsightsList(p9.userInsights)

					t2[v60].setProfileInsights(v74)
					t3[v54].setProfileInsights((mergeWithExisting(v54, v74)))

					local v75 = v66
					local v76 = t3[v54]

					v75({
						status = "success",
						data = v76
					})

					return
				end

				v66({
					status = "failed",
					data = {}
				})
			end)

			return v65
		end
	}
end)
