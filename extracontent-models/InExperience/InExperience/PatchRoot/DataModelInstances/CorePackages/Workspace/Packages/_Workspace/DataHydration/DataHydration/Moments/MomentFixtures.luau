local Parent = script:FindFirstAncestor("DataHydration").Parent
local MomentStatus = require(Parent.MomentsTypes).Enums.MomentStatus
local t1 = {
	{
		placeId = 185655149,
		universeId = 8357232245
	},
	{
		placeId = 920587237,
		universeId = 245662005
	},
	{
		placeId = 6516141723,
		universeId = 2440500276
	},
	{
		placeId = 4924922222,
		universeId = 1685831367
	}
}
local t2 = {
	9113446962,
	1062804083,
	10067664364,
	11045762650,
	3358829679,
	2649867028,
	7715672989,
	3617978804,
	10378728341,
	10790642201,
	2539415890
}
local t3 = {
	5608386285,
	5608368298,
	5670824523,
	5608370112,
	5608330602,
	5608310319,
	5670809466,
	5608327482,
	5608304953,
	5608281849
}
local t4 = {
	8508980527,
	109251559,
	78447821,
	595029580,
	394647606,
	68073547,
	3537138
}
local t5 = {
	1848354536,
	5410086218,
	139180277700549,
	139434270800490
}
local t6 = {
	"first try, no way",
	"we actually cooked today",
	"had to clip this one",
	"caught it in 4k",
	"POV: the plan finally worked",
	"blink and you'll miss it",
	"best run i've had",
	"ok that was actually clean",
	"10/10 would run it back",
	"real ones were here",
	"the comeback nobody saw coming",
	"saving this forever",
	"certified moment fr",
	"me when it all comes together",
	"took way too many tries",
	"we move regardless",
	"outplayed and not sorry",
	"this one's going in the highlights",
	"trust the process they said",
	"peak gameplay right here"
}

local function rngFor(n1: number) -- line: 123
	return Random.new(n1 * 2654435761 + 2026)
end
local function cycle(t7: {[any]: any}, n2: number) -- line: 127
	return t7[(n2 - 1) % #t7 + 1]
end
local function makeMomentFeedItem(n3: number) -- line: 133
	-- upvalues: t6 (copy), t1 (copy), t2 (copy), t5 (copy), t4 (copy), t3 (copy), MomentStatus (copy)
	local random = Random.new(n3 * 2654435761 + 2026)
	local v17 = random:NextNumber()
	local v18 = n3 > 1 and v17 < 0.28
	local v19 = t6[random:NextInteger(1, #t6)]
	local v20 = t1[random:NextInteger(1, #t1)]
	local v21 = t2[random:NextInteger(1, #t2)]
	local v22 = random:NextNumber()
	local v23 = random:NextInteger(0, 12)
	local t8

	if #t5 > 0 and (v18 or v22 < 0.45) then
		t8 = {}

		local v25 = t5

		t8.assetId = v25[(n3 - 1) % #v25 + 1]
		t8.startTime = v23
	else
		t8 = nil
	end

	local v27

	if v18 then
		local v26 = t4

		v27 = v26[(n3 - 1) % #v26 + 1]
	else
		local v28 = t3

		v27 = v28[(n3 - 1) % #v28 + 1]
	end

	local t9 = {
		isModerated = false,
		assetId = v27,
		creatorId = v21,
		momentId = `mock-moment-{ n3 }`,
		status = MomentStatus.Public,
		metadata = {
			assetTotalDuration = 10,
			captureType = if not v18 then Enum.CaptureType.Video else Enum.CaptureType.Screenshot,
			description = v19,
			placeId = v20.placeId,
			universeId = v20.universeId,
			edits = {
				music = t8
			}
		},
		recommendationMetadata = {
			configName = "MaximizeJoins",
			locationId = "Trending",
			itemId = `mock-item-{ n3 }`,
			tracingId = `mock-trace-{ n3 }`
		}
	}

	return {
		kind = "moment",
		moment = t9
	}
end

return {
	makeMomentFeedItem = makeMomentFeedItem,
	buildMomentFeedItems = function(n4: number, n5: number) -- line: 217
		-- upvalues: makeMomentFeedItem (copy)
		local t10 = {}

		for i = 0, n5 - 1 do
			table.insert(t10, (makeMomentFeedItem(n4 + i)))
		end

		return t10
	end
}
