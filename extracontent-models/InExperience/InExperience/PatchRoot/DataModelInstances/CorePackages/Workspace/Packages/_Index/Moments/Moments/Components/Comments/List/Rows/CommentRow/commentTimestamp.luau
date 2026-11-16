local function getAgeMilliseconds(p: number, p2: number) -- 2 equivalent calls inferred from this helper
	return (math.max(p2 - p, 0))
end

local function getNextBucketBoundary(p: number, ageMilliseconds: number, p2: number, p3: number) -- 6 equivalent calls inferred from this helper
	return p + math.min((math.floor(ageMilliseconds / p2) + 1) * p2, p3)
end

local CommentTimestamp = {}

function CommentTimestamp.parseTimestamp(p: string)
	if p == "" then
		return nil
	end

	local success, result = pcall(DateTime.fromIsoDate, p)

	if success and result ~= nil then
		return result.UnixTimestampMillis
	end

	return nil
end

function CommentTimestamp.getRelativeAge(p: number?, p2: number)
	if p == nil then
		return nil
	end

	local ageMilliseconds = getAgeMilliseconds(p, p2) -- inferred equivalent call

	if ageMilliseconds < 60000 then
		return { unit = "now", count = 0 }
	end

	if ageMilliseconds < 3600000 then
		return {
			unit = "minutes",
			count = math.floor(ageMilliseconds / 60000)
		}
	end

	if ageMilliseconds < 86400000 then
		return {
			unit = "hours",
			count = math.floor(ageMilliseconds / 3600000)
		}
	end

	if ageMilliseconds < 604800000 then
		return {
			unit = "days",
			count = math.floor(ageMilliseconds / 86400000)
		}
	end

	if ageMilliseconds < 2592000000 then
		return {
			unit = "weeks",
			count = math.floor(ageMilliseconds / 604800000)
		}
	end

	if ageMilliseconds < 31536000000 then
		return {
			unit = "months",
			count = math.floor(ageMilliseconds / 2592000000)
		}
	end

	return {
		unit = "years",
		count = math.floor(ageMilliseconds / 31536000000)
	}
end

function CommentTimestamp.getNextChangeTimestamp(p: number?, p2: number)
	if p == nil then
		return nil
	end

	local ageMilliseconds = getAgeMilliseconds(p, p2) -- inferred equivalent call

	if ageMilliseconds < 60000 then
		return p + 60000
	end

	if ageMilliseconds < 3600000 then
		return getNextBucketBoundary(p, ageMilliseconds, 60000, 3600000) -- inferred equivalent call
	end

	if ageMilliseconds < 86400000 then
		return getNextBucketBoundary(p, ageMilliseconds, 3600000, 86400000) -- inferred equivalent call
	end

	if ageMilliseconds < 604800000 then
		return getNextBucketBoundary(p, ageMilliseconds, 86400000, 604800000) -- inferred equivalent call
	end

	if ageMilliseconds < 2592000000 then
		return getNextBucketBoundary(p, ageMilliseconds, 604800000, 2592000000) -- inferred equivalent call
	end

	if ageMilliseconds < 31536000000 then
		return getNextBucketBoundary(p, ageMilliseconds, 2592000000, 31536000000) -- inferred equivalent call
	end

	return getNextBucketBoundary(p, ageMilliseconds, 31536000000, 1e999) -- inferred equivalent call
end

return CommentTimestamp
