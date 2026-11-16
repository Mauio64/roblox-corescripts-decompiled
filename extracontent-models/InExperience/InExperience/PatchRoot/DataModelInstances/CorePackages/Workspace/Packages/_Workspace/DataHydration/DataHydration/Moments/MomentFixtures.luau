local parent = script:FindFirstAncestor("DataHydration").Parent

local MomentsTypes = require(parent.MomentsTypes)

local MomentStatus = MomentsTypes.Enums.MomentStatus

local v = {
	{ placeId = 185655149, universeId = 8357232245 },
	{ placeId = 920587237, universeId = 245662005 },
	{ placeId = 6516141723, universeId = 2440500276 },
	{ placeId = 4924922222, universeId = 1685831367 }
}

local v2 = {
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

local v3 = {
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

local v4 = { 8508980527, 109251559, 78447821, 595029580, 394647606, 68073547, 3537138 }

local v5 = { 1848354536, 5410086218, 139180277700549, 139434270800490 }

local v6 = {
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

local v7 = {
	"rbxasset://textures/ui/Moments/Reactions/thumbs-up-large.png",
	"rbxasset://textures/ui/Moments/Reactions/heart-large.png",
	"rbxasset://textures/ui/Moments/Reactions/laugh-joy-large.png",
	"rbxasset://textures/ui/Moments/Reactions/fire-large.png",
	"rbxasset://textures/ui/Moments/Reactions/crying-large.png",
	"rbxasset://textures/ui/Moments/Reactions/skull-large.png"
}

local function rngFor(p: number) -- 1 equivalent call inferred from this helper
	return Random.new(p * 2654435761 + 2026)
end

local function cycle(list, p: number) -- 4 equivalent calls inferred from this helper
	return list[(p - 1) % #list + 1]
end

local function makeMomentFeedItem(p: number)
	local v8 = rngFor(p) -- inferred equivalent call
	local number = v8:NextNumber()
	local v9

	if p > 1 then
		v9 = number < 0.28
	else
		v9 = false
	end

	local description = v6[v8:NextInteger(1, #v6)]

	local v10 = v[v8:NextInteger(1, #v)]
	local creatorId = v2[v8:NextInteger(1, #v2)]

	local number2 = v8:NextNumber()
	local integer = v8:NextInteger(0, 12)
	local music

	if #v5 > 0 and (v9 or number2 < 0.45) then
		music = { assetId = 0, startTime = 0 }
		music.assetId = cycle(v5, p) -- inferred equivalent call
		music.startTime = integer
	end

	local stickerOverlays

	if v8:NextNumber() < 0.6 then
		stickerOverlays = {
			{
				stickerURI = cycle(v7, p), -- inferred equivalent call
				position = UDim2.fromScale(v8:NextNumber() * 0.6 + 0.2, v8:NextNumber() * 0.5 + 0.25),
				stickerSize = v8:NextInteger(50, 200),
				rotation = 0,
				scale = 1,
				zIndex = 1
			}
		}
	end

	local assetId

	if v9 then
		assetId = cycle(v4, p) -- inferred equivalent call
	else
		assetId = cycle(v3, p) -- inferred equivalent call
	end

	local moment = {
		assetId = assetId,
		creatorId = creatorId,
		isModerated = false,
		momentId = `mock-moment-{p}`,
		status = MomentStatus.Public,
		metadata = 0,
		recommendationMetadata = 0
	}
	local captureType

	if v9 then
		captureType = Enum.CaptureType.Screenshot
	else
		captureType = Enum.CaptureType.Video
	end

	moment.metadata = {
		assetTotalDuration = 10,
		captureType = captureType,
		description = description,
		placeId = v10.placeId,
		universeId = v10.universeId,
		edits = { music = music, stickerOverlays = stickerOverlays }
	}

	moment.recommendationMetadata = {
		feedItemId = `mock-item-{p}`,
		tracingId = `mock-trace-{p}`,
		configName = "MaximizeJoins",
		locationId = "Trending"
	}

	return { kind = "moment", moment = moment }
end

return {
	makeMomentFeedItem = makeMomentFeedItem,
	buildMomentFeedItems = function(p: number, p2: number)
		local momentFeedItems = {}

		for i = 0, p2 - 1 do
			table.insert(momentFeedItems, makeMomentFeedItem(p + i))
		end

		return momentFeedItems
	end
}
