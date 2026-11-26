local momentStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/MomentsTypes").Enums.MomentStatus

local v5 = {
	{ placeId = 185655149, universeId = 8357232245 },
	{ placeId = 920587237, universeId = 245662005 },
	{ placeId = 6516141723, universeId = 2440500276 },
	{ placeId = 4924922222, universeId = 1685831367 }
}

local v6 = {
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

local v7 = {
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

local v8 = { 8508980527, 109251559, 78447821, 595029580, 394647606, 68073547, 3537138 }

local v9 = { 1848354536, 5410086218, 139180277700549, 139434270800490 }

local v10 = {
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

local v11 = {
	"rbxasset://textures/ui/Moments/Reactions/thumbs-up-large.png",
	"rbxasset://textures/ui/Moments/Reactions/heart-large.png",
	"rbxasset://textures/ui/Moments/Reactions/laugh-joy-large.png",
	"rbxasset://textures/ui/Moments/Reactions/fire-large.png",
	"rbxasset://textures/ui/Moments/Reactions/crying-large.png",
	"rbxasset://textures/ui/Moments/Reactions/skull-large.png"
}

local function rngFor(p2)
	return Random.new(2026 + p2 * 2654435761)
end

local function cycle(list, p2)
	return list[(p2 - 1) % #list + 1]
end

local function makeMomentFeedItem(p2)
	local random = Random.new(2026 + p2 * 2654435761)

	local number = random:NextNumber()
	local v12 = p2 > 1 and number < 0.28

	local v13 = v10[random:NextInteger(1, #v10)]

	local v14 = v5[random:NextInteger(1, #v5)]
	local v15 = v6[random:NextInteger(1, #v6)]

	local number2 = random:NextNumber()
	local integer = random:NextInteger(0, 12)
	local v16

	if #v9 > 0 and (v12 or number2 < 0.45) then
		v16 = { assetId = 0, startTime = 0 }
		local v17 = v9
		v16.assetId = v17[(p2 - 1) % #v17 + 1]
		v16.startTime = integer
	end

	local v17

	if random:NextNumber() < 0.6 then
		local v19 = v11
		v17 = {
			{
				stickerURI = v19[(p2 - 1) % #v19 + 1],
				position = UDim2.fromScale(
					random:NextNumber() * 0.6 + 0.2,
					random:NextNumber() * 0.5 + 0.25
				),
				stickerSize = random:NextInteger(50, 200),
				rotation = 0,
				scale = 1,
				zIndex = 1
			}
		}
	end

	local v18

	if v12 then
		local v19 = v8
		v18 = v19[(p2 - 1) % #v19 + 1]
	else
		local v19 = v7
		v18 = v19[(p2 - 1) % #v19 + 1]
	end

	local v19 = {
		assetId = v18,
		creatorId = v15,
		isModerated = false,
		momentId = `mock-moment-{p2}`,
		status = momentStatus.Public,
		metadata = 0,
		recommendationMetadata = 0
	}

	local v21 = if v12 then Enum.CaptureType.Screenshot else Enum.CaptureType.Video
	v19.metadata = {
		assetTotalDuration = 10,
		captureType = v21,
		description = v13,
		placeId = v14.placeId,
		universeId = v14.universeId,
		edits = { music = v16, stickerOverlays = v17 }
	}

	v19.recommendationMetadata = {
		feedItemId = `mock-item-{p2}`,
		tracingId = `mock-trace-{p2}`,
		configName = "MaximizeJoins",
		locationId = "Trending"
	}

	return { kind = "moment", moment = v19 }
end

return {
	makeMomentFeedItem = makeMomentFeedItem,
	buildMomentFeedItems = function(p2, p3)
		local momentFeedItems = {}

		for i = 0, p3 - 1 do
			table.insert(momentFeedItems, makeMomentFeedItem(p2 + i))
		end

		return momentFeedItems
	end
}
