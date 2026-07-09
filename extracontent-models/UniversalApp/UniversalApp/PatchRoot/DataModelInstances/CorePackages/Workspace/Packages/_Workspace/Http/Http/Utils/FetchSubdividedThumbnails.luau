local Http = script:FindFirstAncestor("Http")
local HttpParent = Http.Parent
local Thumbnail = require(Http.Models).Thumbnail
local PerformFetch = require(Http.PerformFetch)
local ArgCheck = require(HttpParent.ArgCheck)
local Promise = require(HttpParent.Promise)
local Result = require(HttpParent.Result)
local tutils = require(HttpParent.tutils)
local u9 = math.max(0, tonumber(settings():GetFVariable("LuaAppNonFinalThumbnailMaxRetries")) or 0)
local u10 = math.max(0, tonumber(settings():GetFVariable("LuaAppThumbnailsApiRetryTimeMultiplier")) or 0)
local t3 = {
	_fetchIcons = function(p1, p2, p3, p4, p5, p6, p7, p8) -- line: 20
		-- upvalues: Result (copy), Thumbnail (copy), Promise (copy)
		local function keyMapperForCurrentRequestNameAndSize(p9) -- line: 30
			-- upvalues: p5 (copy), p6 (copy), p4 (copy)
			return p5({
				targetId = p9,
				requestName = p6,
				iconSize = p4
			})
		end
		local function getTableOfFailedResults(p10) -- line: 38
			-- upvalues: p5 (copy), p6 (copy), p4 (copy), Result (copy)
			local t1 = {}

			for _, v in pairs(p10) do
				t1[p5({
					targetId = v,
					requestName = p6,
					iconSize = p4
				})] = Result.new(false, {
					targetId = v
				})
			end

			return t1
		end

		return p7(p2, p3, p4):andThen(function(p11) -- line: 49
			-- upvalues: getTableOfFailedResults (copy), p3 (copy), Thumbnail (copy), p4 (copy), p5 (copy), p6 (copy), Result (copy), p1 (copy), p8 (copy), Promise (copy)
			local v42 = getTableOfFailedResults(p3)
			local t2 = {}
			local v44 = p11 and (p11.responseBody and p11.responseBody.data)

			if typeof(v44) == "table" then
				for _, v in pairs(v44) do
					if Thumbnail.isCompleteThumbnailData(v) then
						local str = tostring(v.targetId)
						local v48 = false

						if Thumbnail.checkStateIsFinal(v.state) then
							t2[str] = Thumbnail.fromThumbnailData(v, p4)
							v48 = true
						end

						v42[p5({
							targetId = str,
							requestName = p6,
							iconSize = p4
						})] = Result.new(v48, v)
					end
				end
			end

			p1:dispatch(p8(t2))

			return Promise.resolve(v42)
		end, function(_) -- line: 69
			-- upvalues: getTableOfFailedResults (copy), p3 (copy), Promise (copy)
			local v50 = getTableOfFailedResults(p3)

			return Promise.resolve(v50)
		end)
	end
}

function t3._fetch(p13, p14, p15, p16, p17, p18, p19, p20) -- line: 75
	-- upvalues: t3 (copy), u9 (ref), u10 (ref), Thumbnail (copy), tutils (copy), Promise (copy)
	return t3._fetchIcons(p13, p14, p15, p16, p17, p18, p19, p20):andThen(function(p21) -- line: 95
		-- upvalues: u9 (ref), u10 (ref), Thumbnail (copy), tutils (copy), Promise (copy), t3 (copy), p13 (copy), p14 (copy), p15 (copy), p16 (copy), p17 (copy), p18 (copy), p19 (copy), p20 (copy)
		local t4 = {}
		local u53 = p21

		if _G.__TESTEZ_RUNNING_TEST__ then
			u9 = 1
			u10 = 0.001
		end

		local function retry(p22) -- line: 104
			-- upvalues: u53 (ref), Thumbnail (copy), t4 (copy), tutils (copy), Promise (copy), u10 (ref), t3 (copy), p13 (copy), p14 (copy), p15 (copy), p16 (copy), p17 (copy), p18 (copy), p19 (copy), p20 (copy), retry (copy)
			local t5 = {}

			for k, v in pairs(u53) do
				local v66, v67 = v:unwrap()

				if v66 and Thumbnail.checkStateIsFinal(v67.state) then
					t4[k] = v
				else
					table.insert(t5, v67)
				end
			end

			if tutils.fieldCount(t5) == 0 then
				return Promise.resolve(t4)
			end

			return Promise.new(function(resolve, _) -- line: 122
				-- upvalues: u10 (ref), p22 (copy)
				coroutine.wrap(function() -- line: 123
					-- upvalues: u10 (ref), p22 (copy), resolve (copy)
					wait(u10 * math.pow(2, p22 - 1))
					resolve()
				end)()
			end):andThen(function() -- line: 130
				-- upvalues: t3 (copy), p13 (copy), p14 (copy), p15 (copy), p16 (copy), p17 (copy), p18 (copy), p19 (copy), p20 (copy)
				return t3._fetchIcons(p13, p14, p15, p16, p17, p18, p19, p20)
			end):andThen(function(p24) -- line: 142
				-- upvalues: u53 (ref), p22 (copy), retry (copy), Promise (copy), t4 (copy)
				u53 = p24

				if p22 > 1 then
					return retry(p22 - 1)
				end

				return Promise.resolve(t4)
			end)
		end

		return retry(u9)
	end)
end
function t3.Fetch(p25, p26, p27, p28, p29, p30) -- line: 156
	-- upvalues: ArgCheck (copy), t3 (copy), PerformFetch (copy)
	ArgCheck.isType(p26, "table", "requests")
	ArgCheck.isType(p28, "string", "requestName")
	ArgCheck.isNonNegativeNumber(#p26, "requests count")
	t3.KeyMapper = p27

	return PerformFetch.Batch(p26, p27, function(p31, p32) -- line: 162
		-- upvalues: t3 (copy), p25 (copy), p27 (copy), p28 (copy), p29 (copy), p30 (copy)
		local t6 = {}
		local iconSize = nil

		for _, v in ipairs(p32) do
			local targetId = v.targetId

			iconSize = v.iconSize
			table.insert(t6, targetId)
		end

		return t3._fetch(p31, p25, t6, iconSize, p27, p28, p29, p30)
	end)
end

return t3
