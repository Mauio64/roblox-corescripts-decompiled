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
local t7 = {
	"rbxasset://textures/ui/Moments/Reactions/thumbs-up-large.png",
	"rbxasset://textures/ui/Moments/Reactions/heart-large.png",
	"rbxasset://textures/ui/Moments/Reactions/laugh-joy-large.png",
	"rbxasset://textures/ui/Moments/Reactions/fire-large.png",
	"rbxasset://textures/ui/Moments/Reactions/crying-large.png",
	"rbxasset://textures/ui/Moments/Reactions/skull-large.png"
}

local function rngFor(n1: number) -- line: 133
	return Random.new(n1 * 2654435761 + 2026)
end
local function cycle(t8: {[any]: any}, n2: number) -- line: 137
	return t8[(n2 - 1) % #t8 + 1]
end
local function makeMomentFeedItem(n3: number) -- line: 143
	-- upvalues: t6 (copy), t1 (copy), t2 (copy), t5 (copy), t7 (copy), t4 (copy), t3 (copy), MomentStatus (copy)
	local random = Random.new(n3 * 2654435761 + 2026)
	local v18 = random:NextNumber()
	local v19 = n3 > 1 and v18 < 0.28
	local v20 = t6[random:NextInteger(1, #t6)]
	local v21 = t1[random:NextInteger(1, #t1)]
	local v22 = t2[random:NextInteger(1, #t2)]
	local v23 = random:NextNumber()
	local v24 = random:NextInteger(0, 12)
	local t9

	if #t5 > 0 and (v19 or v23 < 0.45) then
		t9 = {}

		local v26 = t5

		t9.assetId = v26[(n3 - 1) % #v26 + 1]
		t9.startTime = v24
	else
		t9 = nil
	end

	local t10 = nil

	if random:NextNumber() < 0.6 then
		t10 = {}

		local t11 = {
			rotation = 0,
			scale = 1,
			zIndex = 1
		}
		local v29 = t7

		t11.stickerURI = v29[(n3 - 1) % #v29 + 1]
		t11.position = UDim2.fromScale(random:NextNumber() * 0.6 + 0.2, random:NextNumber() * 0.5 + 0.25)
		t11.stickerSize = random:NextInteger(50, 200)
		t10[1] = t11
	end

	local v31

	if v19 then
		local v30 = t4

		v31 = v30[(n3 - 1) % #v30 + 1]
	else
		local v32 = t3

		v31 = v32[(n3 - 1) % #v32 + 1]
	end

	local t12 = {
		isModerated = false,
		assetId = v31,
		creatorId = v22,
		momentId = `mock-moment-{ n3 }`,
		status = MomentStatus.Public,
		metadata = {
			assetTotalDuration = 10,
			captureType = if not v19 then Enum.CaptureType.Video else Enum.CaptureType.Screenshot,
			description = v20,
			placeId = v21.placeId,
			universeId = v21.universeId,
			edits = {
				music = t9,
				stickerOverlays = t10
			}
		},
		recommendationMetadata = {
			configName = "MaximizeJoins",
			locationId = "Trending",
			feedItemId = `mock-item-{ n3 }`,
			tracingId = `mock-trace-{ n3 }`
		}
	}

	return {
		kind = "moment",
		moment = t12
	}
end

return {
	makeMomentFeedItem = makeMomentFeedItem,
	buildMomentFeedItems = function(n4: number, n5: number) -- line: 245
		-- upvalues: makeMomentFeedItem (copy)
		local t13 = {}

		for i = 0, n5 - 1 do
			table.insert(t13, (makeMomentFeedItem(n4 + i)))
		end

		return t13
	end
}
