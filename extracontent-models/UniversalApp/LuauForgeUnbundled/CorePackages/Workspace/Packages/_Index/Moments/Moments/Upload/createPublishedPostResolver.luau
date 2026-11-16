require("@game/CorePackages/Workspace/Packages/_Index/Moments/MomentsTypes")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Promise")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SharedFlags")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Signals")
require("@game/CorePackages/Workspace/Packages/_Index/Moments/DataHydration/MomentsStoreTypes")
local MomentsGetMomentsUserStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/DataHydration/MomentsGetMomentsUserStore")
local getLocalUserId = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Utils/getLocalUserId")
local shouldShowMomentInFeed = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Stores/GetMomentsStore/shouldShowMomentInFeed")
local postLifecycleSubscription = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Upload/postLifecycleSubscription")

game:DefineFastInt("MomentsPublishedPostPollIntervalSeconds", 10)
game:DefineFastInt("MomentsPublishedPostMaxPollAttempts", 30)

local logger = nil
local function getLogger()
	if logger == nil then
		logger = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Loggers").Logger:new("Moments.Upload")
	end

	return logger
end

local count = 0

local function waitForLifecycleChange(p2, p3, p4, wait2): boolean
	local function v5() end
	local thread = nil
	local v6 = {
		Promise.new(function(callback)
			v5 = Signals.createEffect(function(p5)
				if postLifecycleSubscription.getWakeVersion(p5, p3) ~= p2 and thread == nil then
					thread = task.defer(function()
						thread = nil
						callback(true)
					end)
				end
			end)
		end),
		(Promise.new(function(callback)
			wait2(p4)
			callback(false)
		end))
	}
	local v7, v8 = Promise.race(v6):await()
	v5()

	if thread ~= nil then
		task.cancel(thread)
	end

	return v8 == true
end

local function fetchPage(p2, p3, p4)
	local v5, v6 = p2.getFreshUserMoments(p3, p4):await()

	if v5 then
		return v6
	end

	return nil
end

local function addToSnapshot(p2, p3)
	for k, moment in p3.moments do
		p2.knownMomentIds[moment.momentId] = true
		local feedItemId = moment.recommendationMetadata.feedItemId

		if feedItemId ~= nil then
			p2.knownMomentIds[feedItemId] = true
		end
	end

	for k, v5 in p3.excludedMomentIds or {} do
		p2.knownMomentIds[v5] = true
	end
end

local function isKnown(p2, p3)
	local feedItemId = p3.recommendationMetadata.feedItemId
	local v5

	if p2.knownMomentIds[p3.momentId] == true then
		v5 = true
	else
		v5 = not (feedItemId == nil) and p2.knownMomentIds[feedItemId] == true
	end

	return v5
end

local function trim(value)
	return string.match(value or "", "^%s*(.-)%s*$") or ""
end

local function textMatches(value, value2): boolean
	local v5 = string.match(value or "", "^%s*(.-)%s*$") or ""
	local v6 = string.match(value2 or "", "^%s*(.-)%s*$") or ""

	if v5 == v6 then
		return true
	end

	local v7 = utf8.len(v5)

	if v7 == nil or v7 ~= utf8.len(v6) then
		return false
	end

	local v8 = {}

	for k, v9 in utf8.codes(v5) do
		table.insert(v8, v9)
	end

	local count2 = 0

	for k, v9 in utf8.codes(v6) do
		count2 += 1

		if v9 ~= v8[count2] and v9 ~= 35 then
			return false
		end
	end

	return true
end

local function getMusicAssetId(p2)
	local music = if p2 ~= nil then p2.music else nil

	if music == nil then
		return nil
	end

	return (tonumber(music.assetId))
end

local function getOverlayTexts(p2)
	local texts = {}

	for k, v5 in (p2 == nil or p2.textOverlays == nil) and {} or p2.textOverlays do
		table.insert(texts, v5.text)
	end

	return texts
end

local function getTextLength(value)
	return (utf8.len(string.match(value or "", "^%s*(.-)%s*$") or ""))
end

local function overlayTextsMatch(edits, edits2): boolean
	local overlayTexts = getOverlayTexts(edits)
	local overlayTexts2 = getOverlayTexts(edits2)

	if #overlayTexts ~= #overlayTexts2 then
		return false
	end

	for k, overlayText in overlayTexts do
		if not textMatches(overlayText, overlayTexts2[k]) then
			return false
		end
	end

	return true
end

local function isKnownPlace(p2): boolean
	return p2 ~= nil and p2 > 0
end

local function placeMatches(p2, p3)
	local v6 = p2 == nil or not (p2 > 0)

	if v6 then
		return v6
	end

	v6 = p3 == nil or not (p3 > 0) or p2 == p3
	return v6
end

local function evaluate(moment, k, data)
	local metadata = moment.metadata
	local v5 = {
		moment = moment,
		position = k,
		visible = shouldShowMomentInFeed(moment),
		captureType = metadata.captureType == data.captureType,
		caption = textMatches(data.description, metadata.description),
		music = 0,
		overlays = 0,
		place = 0
	}
	local edits = data.edits
	local music = if edits ~= nil then edits.music else nil
	local assetId = if music ~= nil then tonumber(music.assetId) else nil

	local edits2 = metadata.edits
	local music2 = if edits2 ~= nil then edits2.music else nil
	local v6 = if music2 ~= nil then tonumber(music2.assetId) else nil

	v5.music = assetId == v6
	v5.overlays = overlayTextsMatch(data.edits, metadata.edits)
	local placeId = data.placeId
	local placeId2 = metadata.placeId
	local v8 = placeId == nil or not (placeId > 0)

	if not v8 then
		v8 = placeId2 == nil or not (placeId2 > 0) or placeId == placeId2
	end

	v5.place = v8
	return v5
end

local function isMatch(data)
	return data.visible
		and data.captureType
		and data.caption
		and data.music
		and data.overlays
		and data.place
end

local function findPublishedPost(p2, p3, p4)
	local result = {}
	local v5 = nil

	for k, moment in p2.moments do
		local feedItemId = moment.recommendationMetadata.feedItemId
		local v6

		if p3.knownMomentIds[moment.momentId] == true then
			v6 = true
		else
			v6 = not (feedItemId == nil) and p3.knownMomentIds[feedItemId] == true
		end

		if v6 then
			continue
		end

		local v7 = evaluate(moment, k, p4)
		table.insert(result, v7)

		if not (v5 == nil and v7.visible and v7.captureType and v7.caption) then
			continue
		end

		if not (v7.music and v7.overlays and v7.place) then
			continue
		end

		v5 = moment
	end

	return v5, result
end

local function logIds(p2, list)
	for i = 1, #list, 6 do
		local v5 = math.min(i + 6 - 1, #list)

		if logger == nil then
			logger = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Loggers").Logger:new("Moments.Upload")
		end

		logger:debug("event={} from={} ids=[{}]", p2, tostring(i), table.concat(list, ",", i, v5))
	end
end

local function logSnapshotPage(p2, p3, data)
	local excludedMomentIds = data.excludedMomentIds or {}

	if logger == nil then
		logger = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Loggers").Logger:new("Moments.Upload")
	end

	logger:debug(
		"event=published_post_snapshot_page resolverId={} page={} moments={} excluded={} hasNext={}",
		tostring(p2),
		tostring(p3),
		tostring(#data.moments),
		tostring(#excludedMomentIds),
		(tostring(data.nextCursor ~= nil))
	)

	local v5 = {}

	for k, moment in data.moments do
		table.insert(v5, `{moment.momentId}:{moment.assetId}`)
	end

	logIds("published_post_snapshot_moments", v5)
	logIds("published_post_snapshot_excluded", excludedMomentIds)
end

local function logExpectation(data)
	if logger == nil then
		logger = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Loggers").Logger:new("Moments.Upload")
	end

	local v5 = logger

	local name = data.captureType.Name
	local description = data.description
	local v7 = tostring((utf8.len(string.match(description or "", "^%s*(.-)%s*$") or "")))
	local edits = data.edits
	local music = if edits ~= nil then edits.music else nil
	local v8 = if music ~= nil then tonumber(music.assetId) else nil

	v5:debug(
		"event=published_post_expectation captureType={} captionLength={} musicAssetId={} overlayCount={} placeId={}",
		name,
		v7,
		tostring(v8),
		tostring(#getOverlayTexts(data.edits)),
		(tostring(data.placeId))
	)
end

local function logCandidate(count2, data)
	local moment = data.moment
	local metadata = moment.metadata

	if logger == nil then
		logger = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Loggers").Logger:new("Moments.Upload")
	end

	local v5 = logger

	local v7 = tostring(count2)
	local position = tostring(data.position)
	local momentId = moment.momentId
	local feedItemId = tostring(moment.recommendationMetadata.feedItemId)
	local assetId = tostring(moment.assetId)
	local status = tostring(moment.status)
	local place = tostring(data.visible and data.captureType and data.caption and data.music and data.overlays and data.place)
	local visible = tostring(data.visible)
	local captureType = tostring(data.captureType)
	local caption = tostring(data.caption)
	local music = tostring(data.music)
	local overlays = tostring(data.overlays)
	local place2 = tostring(data.place)
	local name = metadata.captureType.Name
	local description = metadata.description
	local v8 = tostring((utf8.len(string.match(description or "", "^%s*(.-)%s*$") or "")))
	local edits = metadata.edits
	local music2 = if edits ~= nil then edits.music else nil
	local v9 = if music2 ~= nil then tonumber(music2.assetId) else nil

	v5:debug(
		"event=published_post_candidate attempt={} position={} momentId={} feedItemId={} assetId={} status={} matched={} visible={} captureType={} caption={} music={} overlays={} place={} storedCaptureType={} storedCaptionLength={} storedMusicAssetId={} storedOverlayCount={} storedPlaceId={}",
		v7,
		position,
		momentId,
		feedItemId,
		assetId,
		status,
		place,
		visible,
		captureType,
		caption,
		music,
		overlays,
		place2,
		name,
		v8,
		tostring(v9),
		tostring(#getOverlayTexts(metadata.edits)),
		(tostring(metadata.placeId))
	)
end

local function createPublishedPostResolver(p2, options)
	local v5 = options or {}
	local v6 = if v5.userStore == nil then MomentsGetMomentsUserStore(false) else v5.userStore

	local wait2 = v5.wait or function(duration)
		task.wait(duration)
	end

	local v7 = 0
	local v8 = nil
	local v9 = nil

	local function takeSnapshot(p3)
		local v10 = nil

		for i = 1, 3 do
			if i > 1 then
				wait2(2)
			end

			local v11
			v11, v10 = v6.getFreshUserMoments(p3, nil):await()

			if not v11 then
				v10 = nil
			end

			if v10 ~= nil then
				break
			end

			if logger == nil then
				logger = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Loggers").Logger:new("Moments.Upload")
			end

			logger:debug(
				"event=published_post_snapshot_read_failed resolverId={} attempt={}",
				tostring(v7),
				(tostring(i))
			)
		end

		if v10 == nil then
			return nil
		end

		local v11 = { knownMomentIds = {} }
		addToSnapshot(v11, v10)
		logSnapshotPage(v7, 1, v10)

		local nextCursor = v10.nextCursor

		for i = 2, 3 do
			if nextCursor == nil then
				break
			end

			local v12, v13 = v6.getFreshUserMoments(p3, nextCursor):await()

			if not v12 then
				v13 = nil
			end

			if v13 == nil then
				break
			end

			addToSnapshot(v11, v13)
			logSnapshotPage(v7, i, v13)

			nextCursor = if v13.nextCursor ~= nextCursor then v13.nextCursor else nil
		end

		return v11
	end

	return {
		captureSnapshot = function()
			count += 1
			v7 = count

			v8 = if v5.getLocalUserId == nil then getLocalUserId() else v5.getLocalUserId()

			if logger == nil then
				logger = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Loggers").Logger:new("Moments.Upload")
			end

			logger:debug(
				"event=published_post_snapshot_started resolverId={} hasUser={}",
				tostring(v7),
				(tostring(v8 ~= nil))
			)

			logExpectation(p2)

			local v10 = v8
			v9 = Promise.new(function(callback)
				local v11 = if v10 ~= nil then takeSnapshot(v10) else nil
				callback(v11)
			end)
		end,
		resolve = function(p3)
			if v9 == nil then
				if logger == nil then
					logger = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Loggers").Logger:new("Moments.Upload")
				end

				logger:debug("event=published_post_unresolved reason=no_snapshot_started")
				return nil
			else
				local v10, v11 = v9:await()
				local v12 = v8

				if v10 and v11 ~= nil and v12 ~= nil then
					local fastInt = game:GetFastInt("MomentsPublishedPostPollIntervalSeconds")
					local fastInt2 = game:GetFastInt("MomentsPublishedPostMaxPollAttempts")

					if logger == nil then
						logger = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Loggers").Logger:new("Moments.Upload")
					end

					logger:debug(
						"event=published_post_polling resolverId={} intervalSeconds={} maxAttempts={}",
						tostring(v7),
						tostring(fastInt),
						(tostring(fastInt2))
					)

					local v13 = SharedFlags.FFlagMomentsOptimisticProfilePending and p3 ~= nil

					local v14 = not v13 and 0 or postLifecycleSubscription.getWakeVersion(false, v12)

					local v15 = os.clock() + fastInt
					local count2 = 0
					local count3 = 0

					while count2 < fastInt2 do
						if v13 then
							if
								count3 > 0
								and not waitForLifecycleChange(
									v14,
									v12,
									math.max(0, v15 - os.clock()),
									wait2
								)
							then
								count2 += 1
								v15 = os.clock() + fastInt
							end

							v14 = postLifecycleSubscription.getWakeVersion(false, v12)
						else
							wait2(fastInt)
							count2 += 1
						end

						count3 += 1
						local v16 = not (v7 == 0) and v7 == count

						if v16 or SharedFlags.FFlagMomentsOptimisticProfilePending and p3 ~= nil then
							if SharedFlags.FFlagMomentsOptimisticProfilePending and p3 ~= nil then
								local v17 = false

								for k, v19 in v6.getPendingUserMoments(false)[v12] or {} do
									if v19.moment.momentId == p3 then
										if v19.publishedMoment ~= nil then
											return v19.publishedMoment
										end

										v17 = true
										break
									end
								end

								if not v17 then
									return nil
								end
							end

							local v17, v18 = v6.getFreshUserMoments(v12, nil):await()

							if not v17 then
								v18 = nil
							end

							if
								SharedFlags.FFlagMomentsOptimisticProfilePending
								and p3 ~= nil
								and v18 ~= nil
							then
								local set = {}

								for k, v19 in v6.getPendingUserMoments(false)[v12] or {} do
									local publishedMoment = v19.publishedMoment

									if publishedMoment == nil then
										continue
									end

									set[publishedMoment.momentId] = true
									local feedItemId = publishedMoment.recommendationMetadata.feedItemId

									if feedItemId ~= nil and feedItemId ~= "" then
										set[feedItemId] = true
									end
								end

								local moments = {}

								for k, moment in v18.moments do
									local feedItemId = moment.recommendationMetadata.feedItemId

									if
										set[moment.momentId]
										or not (feedItemId == nil or not set[feedItemId])
									then
										continue
									end

									table.insert(moments, moment)
								end

								v18 = table.clone(v18)
								v18.moments = moments
							end

							if v18 == nil then
								if logger == nil then
									logger = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Loggers").Logger:new("Moments.Upload")
								end

								logger:debug(
									"event=published_post_poll_read_failed resolverId={} attempt={}",
									tostring(v7),
									(tostring(count3))
								)
							else
								local publishedPost, v19 = findPublishedPost(v18, v11, p2)
								local excludedMomentIds = v18.excludedMomentIds or {}

								if logger == nil then
									logger = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Loggers").Logger:new("Moments.Upload")
								end

								logger:debug(
									"event=published_post_poll resolverId={} attempt={} moments={} excluded={} unknown={}",
									tostring(v7),
									tostring(count3),
									tostring(#v18.moments),
									tostring(#excludedMomentIds),
									(tostring(#v19))
								)

								for k, v20 in v19 do
									logCandidate(count3, v20)
								end

								if publishedPost ~= nil then
									if
										SharedFlags.FFlagMomentsOptimisticProfilePending
										and p3 ~= nil
										and not v6.resolvePendingUserMoment(v12, p3, publishedPost)
									then
										return nil
									end

									v6.invalidateUser(v12)

									if logger == nil then
										logger = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Loggers").Logger:new("Moments.Upload")
									end

									logger:debug(
										"event=published_post_resolved resolverId={} attempt={} momentId={} feedItemId={} assetId={}",
										tostring(v7),
										tostring(count3),
										publishedPost.momentId,
										tostring(publishedPost.recommendationMetadata.feedItemId),
										(tostring(publishedPost.assetId))
									)

									return publishedPost
								end
							end
						else
							if logger == nil then
								logger = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Loggers").Logger:new("Moments.Upload")
							end

							logger:debug(
								"event=published_post_unresolved resolverId={} reason=superseded attempt={}",
								tostring(v7),
								(tostring(count3))
							)

							return nil
						end
					end

					if logger == nil then
						logger = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Loggers").Logger:new("Moments.Upload")
					end

					logger:debug(
						"event=published_post_unresolved resolverId={} reason=budget_exhausted attempts={}",
						tostring(v7),
						(tostring(fastInt2))
					)

					return nil
				end

				if logger == nil then
					logger = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Loggers").Logger:new("Moments.Upload")
				end

				logger:debug(
					"event=published_post_unresolved resolverId={} reason=snapshot_unavailable",
					(tostring(v7))
				)

				return nil
			end
		end,
		isCurrent = function(): boolean
			return v7 ~= 0 and v7 == count
		end
	}
end

return createPublishedPostResolver
