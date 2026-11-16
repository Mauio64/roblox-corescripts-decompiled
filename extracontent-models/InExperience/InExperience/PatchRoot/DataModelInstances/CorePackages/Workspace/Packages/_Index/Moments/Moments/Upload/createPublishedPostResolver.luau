local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

require(parent.MomentsTypes)
local Promise = require(parent.Promise)
local SharedFlags = require(parent.SharedFlags)
local Signals = require(parent.Signals)
require(parent.DataHydration.MomentsStoreTypes)
local MomentsGetMomentsUserStore = require(parent.DataHydration.MomentsGetMomentsUserStore)
local getLocalUserId = require(Moments.Utils.getLocalUserId)
local shouldShowMomentInFeed = require(Moments.Stores.GetMomentsStore.shouldShowMomentInFeed)
local postLifecycleSubscription = require(script.Parent.postLifecycleSubscription)

game:DefineFastInt("MomentsPublishedPostPollIntervalSeconds", 10)
game:DefineFastInt("MomentsPublishedPostMaxPollAttempts", 30)

local logger = nil
local function getLogger() -- 14 equivalent calls inferred from this helper
	if logger == nil then
		local Loggers = require(parent.Loggers)
		logger = Loggers.Logger:new("Moments.Upload")
	end

	return logger
end

local count = 0

local function waitForLifecycleChange(p: number, p2: number, p3: number, wait): boolean
	local function v() end
	local thread = nil
	local v2 = {
		Promise.new(function(callback)
			v = Signals.createEffect(function(p4)
				if postLifecycleSubscription.getWakeVersion(p4, p2) ~= p and thread == nil then
					thread = task.defer(function()
						thread = nil
						callback(true)
					end)
				end
			end)
		end),
		(Promise.new(function(callback)
			wait(p3)
			callback(false)
		end))
	}
	local _, v3 = Promise.race(v2):await()
	v()

	if thread ~= nil then
		task.cancel(thread)
	end

	return v3 == true
end

local function fetchPage(p, p2: number, nextCursor: string?) -- 2 equivalent calls inferred from this helper
	local v, v2 = p.getFreshUserMoments(p2, nextCursor):await()
	return if v then v2 else nil
end

local function addToSnapshot(p, p2)
	for _, moment in p2.moments do
		p.knownMomentIds[moment.momentId] = true
		local feedItemId = moment.recommendationMetadata.feedItemId

		if feedItemId ~= nil then
			p.knownMomentIds[feedItemId] = true
		end
	end

	for _, v in p2.excludedMomentIds or {} do
		p.knownMomentIds[v] = true
	end
end

local function isKnown(p, moment): boolean -- 1 equivalent call inferred from this helper
	local feedItemId = moment.recommendationMetadata.feedItemId

	if p.knownMomentIds[moment.momentId] == true then
		return true
	elseif feedItemId == nil then
		return false
	else
		return p.knownMomentIds[feedItemId] == true
	end
end

local function trim(value: string?) -- 3 equivalent calls inferred from this helper
	return string.match(value or "", "^%s*(.-)%s*$") or ""
end

local function textMatches(value: string?, value2: string?): boolean
	local v = trim(value) -- inferred equivalent call
	local v2 = trim(value2) -- inferred equivalent call

	if v == v2 then
		return true
	end

	local v3 = utf8.len(v)

	if v3 == nil or v3 ~= utf8.len(v2) then
		return false
	end

	local v4 = {}

	for _, v5 in utf8.codes(v) do
		table.insert(v4, v5)
	end

	local count2 = 0

	for _, v5 in utf8.codes(v2) do
		count2 += 1

		if v5 ~= v4[count2] and v5 ~= 35 then
			return false
		end
	end

	return true
end

local function getMusicAssetId(edits) -- 4 equivalent calls inferred from this helper
	local music

	if edits ~= nil then
		music = edits.music
	end

	if music == nil then
		return nil
	end

	return (tonumber(music.assetId))
end

local function getOverlayTexts(p)
	local texts = {}

	for _, v in (p == nil or p.textOverlays == nil) and {} or p.textOverlays do
		table.insert(texts, v.text)
	end

	return texts
end

local function getTextLength(description: string?) -- 2 equivalent calls inferred from this helper
	return (utf8.len(trim(description))) -- inferred equivalent call
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

local function isKnownPlace(p: number?): boolean -- 2 equivalent calls inferred from this helper
	return p ~= nil and p > 0
end

local function placeMatches(placeId: number?, placeId2: number?): boolean -- 1 equivalent call inferred from this helper
	return not isKnownPlace(placeId) or not isKnownPlace(placeId2) or placeId == placeId2 -- inferred equivalent call
end

local function evaluate(moment, k: number, data)
	local metadata = moment.metadata
	return {
		moment = moment,
		position = k,
		visible = shouldShowMomentInFeed(moment),
		captureType = metadata.captureType == data.captureType,
		caption = textMatches(data.description, metadata.description),
		music = getMusicAssetId(data.edits) == getMusicAssetId(metadata.edits), -- inferred equivalent call
		overlays = overlayTextsMatch(data.edits, metadata.edits),
		place = placeMatches(data.placeId, metadata.placeId) -- inferred equivalent call
	}
end

local function isMatch(data) -- 2 equivalent calls inferred from this helper
	return data.visible and data.captureType and data.caption and data.music and data.overlays and data.place
end

local function findPublishedPost(clone, p, p2)
	local result = {}
	local v = nil

	for k, moment in clone.moments do
		if isKnown(p, moment) then -- inferred equivalent call
			continue
		end

		local v2 = evaluate(moment, k, p2)
		table.insert(result, v2)

		if v == nil and isMatch(v2) then -- inferred equivalent call
			v = moment
		end
	end

	return v, result
end

local function logIds(p: string, list)
	for i = 1, #list, 6 do
		local v = math.min(i + 6 - 1, #list)
		getLogger():debug("event={} from={} ids=[{}]", p, tostring(i), table.concat(list, ",", i, v)) -- inferred equivalent call
	end
end

local function logSnapshotPage(p: number, p2: number, data)
	local excludedMomentIds = data.excludedMomentIds or {}
	getLogger():debug( -- inferred equivalent call
		"event=published_post_snapshot_page resolverId={} page={} moments={} excluded={} hasNext={}",
		tostring(p),
		tostring(p2),
		tostring(#data.moments),
		tostring(#excludedMomentIds),
		(tostring(data.nextCursor ~= nil))
	)

	local v = {}

	for _, moment in data.moments do
		table.insert(v, `{moment.momentId}:{moment.assetId}`)
	end

	logIds("published_post_snapshot_moments", v)
	logIds("published_post_snapshot_excluded", excludedMomentIds)
end

local function logExpectation(data)
	local logger2 = getLogger() -- inferred equivalent call
	logger2:debug(
		"event=published_post_expectation captureType={} captionLength={} musicAssetId={} overlayCount={} placeId={}",
		data.captureType.Name,
		tostring(getTextLength(data.description)), -- inferred equivalent call
		tostring(getMusicAssetId(data.edits)), -- inferred equivalent call
		tostring(#getOverlayTexts(data.edits)),
		(tostring(data.placeId))
	)
end

local function logCandidate(count2: number, data)
	local moment = data.moment
	local metadata = moment.metadata
	local logger2 = getLogger() -- inferred equivalent call
	logger2:debug(
		"event=published_post_candidate attempt={} position={} momentId={} feedItemId={} assetId={} status={} matched={} visible={} captureType={} caption={} music={} overlays={} place={} storedCaptureType={} storedCaptionLength={} storedMusicAssetId={} storedOverlayCount={} storedPlaceId={}",
		tostring(count2),
		tostring(data.position),
		moment.momentId,
		tostring(moment.recommendationMetadata.feedItemId),
		tostring(moment.assetId),
		tostring(moment.status),
		tostring(isMatch(data)), -- inferred equivalent call
		tostring(data.visible),
		tostring(data.captureType),
		tostring(data.caption),
		tostring(data.music),
		tostring(data.overlays),
		tostring(data.place),
		metadata.captureType.Name,
		tostring(getTextLength(metadata.description)), -- inferred equivalent call
		tostring(getMusicAssetId(metadata.edits)), -- inferred equivalent call
		tostring(#getOverlayTexts(metadata.edits)),
		(tostring(metadata.placeId))
	)
end

local function createPublishedPostResolver(p, options)
	local v = options or {}
	local v2

	if v.userStore == nil then
		v2 = MomentsGetMomentsUserStore(false)
	else
		v2 = v.userStore
	end

	local wait = v.wait or function(duration: number)
		task.wait(duration)
	end

	local v3 = 0
	local v4 = nil
	local v5 = nil

	local function isCurrent(): boolean -- 1 equivalent call inferred from this helper
		return v3 ~= 0 and v3 == count
	end

	local function takeSnapshot(p2: number)
		local v6 = nil

		for i = 1, 3 do
			if i > 1 then
				wait(2)
			end

			local v7
			v7, v6 = v2.getFreshUserMoments(p2, nil):await()

			if not v7 then
				v6 = nil
			end

			if v6 ~= nil then
				break
			end

			getLogger():debug( -- inferred equivalent call
				"event=published_post_snapshot_read_failed resolverId={} attempt={}",
				tostring(v3),
				(tostring(i))
			)
		end

		if v6 == nil then
			return nil
		end

		local v7 = { knownMomentIds = {} }
		addToSnapshot(v7, v6)
		logSnapshotPage(v3, 1, v6)

		local nextCursor = v6.nextCursor

		for i = 2, 3 do
			if nextCursor == nil then
				break
			end

			local page = fetchPage(v2, p2, nextCursor) -- inferred equivalent call

			if page == nil then
				break
			end

			addToSnapshot(v7, page)
			logSnapshotPage(v3, i, page)

			if page.nextCursor == nextCursor then
				nextCursor = nil
			else
				nextCursor = page.nextCursor
			end
		end

		return v7
	end

	return {
		captureSnapshot = function()
			count += 1
			v3 = count

			if v.getLocalUserId == nil then
				v4 = getLocalUserId()
			else
				v4 = v.getLocalUserId()
			end

			getLogger():debug( -- inferred equivalent call
				"event=published_post_snapshot_started resolverId={} hasUser={}",
				tostring(v3),
				(tostring(v4 ~= nil))
			)

			logExpectation(p)

			local v6 = v4
			v5 = Promise.new(function(callback)
				local v7

				if v6 ~= nil then
					v7 = takeSnapshot(v6)
				end

				callback(v7)
			end)
		end,
		resolve = function(p2: string?)
			if v5 == nil then
				getLogger():debug("event=published_post_unresolved reason=no_snapshot_started") -- inferred equivalent call
				return nil
			else
				local v6, v7 = v5:await()
				local v8 = v4

				if v6 and v7 ~= nil and v8 ~= nil then
					local fastInt = game:GetFastInt("MomentsPublishedPostPollIntervalSeconds")
					local fastInt2 = game:GetFastInt("MomentsPublishedPostMaxPollAttempts")
					getLogger():debug( -- inferred equivalent call
						"event=published_post_polling resolverId={} intervalSeconds={} maxAttempts={}",
						tostring(v3),
						tostring(fastInt),
						(tostring(fastInt2))
					)

					local v9 = SharedFlags.FFlagMomentsOptimisticProfilePending and p2 ~= nil

					local v10 = not v9 and 0 or postLifecycleSubscription.getWakeVersion(false, v8)

					local v11 = os.clock() + fastInt
					local count2 = 0
					local count3 = 0

					while count2 < fastInt2 do
						if v9 then
							if
								count3 > 0
								and not waitForLifecycleChange(v10, v8, math.max(0, v11 - os.clock()), wait)
							then
								count2 += 1
								v11 = os.clock() + fastInt
							end

							v10 = postLifecycleSubscription.getWakeVersion(false, v8)
						else
							wait(fastInt)
							count2 += 1
						end

						count3 += 1

						if isCurrent() or SharedFlags.FFlagMomentsOptimisticProfilePending and p2 ~= nil then -- inferred equivalent call
							if SharedFlags.FFlagMomentsOptimisticProfilePending and p2 ~= nil then
								local v12 = false

								for _, v13 in v2.getPendingUserMoments(false)[v8] or {} do
									if v13.moment.momentId == p2 then
										if v13.publishedMoment ~= nil then
											return v13.publishedMoment
										end

										v12 = true
										break
									end
								end

								if not v12 then
									return nil
								end
							end

							local clone = fetchPage(v2, v8) -- inferred equivalent call

							if SharedFlags.FFlagMomentsOptimisticProfilePending and p2 ~= nil and clone ~= nil then
								local set = {}

								for _, v12 in v2.getPendingUserMoments(false)[v8] or {} do
									local publishedMoment = v12.publishedMoment

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

								for _, moment in clone.moments do
									local feedItemId = moment.recommendationMetadata.feedItemId

									if set[moment.momentId] or not (feedItemId == nil or not set[feedItemId]) then
										continue
									end

									table.insert(moments, moment)
								end

								clone = table.clone(clone)
								clone.moments = moments
							end

							if clone == nil then
								getLogger():debug( -- inferred equivalent call
									"event=published_post_poll_read_failed resolverId={} attempt={}",
									tostring(v3),
									(tostring(count3))
								)
							else
								local publishedPost, v12 = findPublishedPost(clone, v7, p)
								local excludedMomentIds = clone.excludedMomentIds or {}
								getLogger():debug( -- inferred equivalent call
									"event=published_post_poll resolverId={} attempt={} moments={} excluded={} unknown={}",
									tostring(v3),
									tostring(count3),
									tostring(#clone.moments),
									tostring(#excludedMomentIds),
									(tostring(#v12))
								)

								for _, v13 in v12 do
									logCandidate(count3, v13)
								end

								if publishedPost ~= nil then
									if
										SharedFlags.FFlagMomentsOptimisticProfilePending
										and p2 ~= nil
										and not v2.resolvePendingUserMoment(v8, p2, publishedPost)
									then
										return nil
									end

									v2.invalidateUser(v8)
									getLogger():debug( -- inferred equivalent call
										"event=published_post_resolved resolverId={} attempt={} momentId={} feedItemId={} assetId={}",
										tostring(v3),
										tostring(count3),
										publishedPost.momentId,
										tostring(publishedPost.recommendationMetadata.feedItemId),
										(tostring(publishedPost.assetId))
									)

									return publishedPost
								end
							end
						else
							getLogger():debug( -- inferred equivalent call
								"event=published_post_unresolved resolverId={} reason=superseded attempt={}",
								tostring(v3),
								(tostring(count3))
							)

							return nil
						end
					end

					getLogger():debug( -- inferred equivalent call
						"event=published_post_unresolved resolverId={} reason=budget_exhausted attempts={}",
						tostring(v3),
						(tostring(fastInt2))
					)

					return nil
				end

				getLogger():debug( -- inferred equivalent call
					"event=published_post_unresolved resolverId={} reason=snapshot_unavailable",
					(tostring(v3))
				)

				return nil
			end
		end,
		isCurrent = isCurrent
	}
end

return createPublishedPostResolver
