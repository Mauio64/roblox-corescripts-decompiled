local parent = script:FindFirstAncestor("Moments").Parent

local Localization = require(parent.Localization)
local React = require(parent.React)

local commentTimestamp = require(script.Parent.commentTimestamp)

local useLocalization = Localization.Hooks.useLocalization

local v = {
	minutes = "Feature.Moments.Label.CommentTimestampMinutes",
	hours = "Feature.Moments.Label.CommentTimestampHours",
	days = "Feature.Moments.Label.CommentTimestampDays",
	weeks = "Feature.Moments.Label.CommentTimestampWeeks",
	months = "Feature.Moments.Label.CommentTimestampMonths",
	years = "Feature.Moments.Label.CommentTimestampYears"
}

local function useCommentTimestamp(p: string)
	local v2 = React.useMemo(function()
		return commentTimestamp.parseTimestamp(p)
	end, { p })
	local state, setState = React.useState(function()
		return DateTime.now().UnixTimestampMillis
	end)

	React.useEffect(function()
		setState(DateTime.now().UnixTimestampMillis)

		if v2 == nil then
			return
		end

		local flag = false
		local thread = nil
		local function scheduleUpdate()
			local unixTimestampMillis = DateTime.now().UnixTimestampMillis
			local nextChangeTimestamp = commentTimestamp.getNextChangeTimestamp(v2, unixTimestampMillis)

			if nextChangeTimestamp == nil then
				thread = nil
				return
			end

			local v3 = math.max(0, nextChangeTimestamp - unixTimestampMillis) / 1000
			thread = task.delay(v3, function()
				thread = nil

				if flag then
					return
				end

				setState(DateTime.now().UnixTimestampMillis)
				scheduleUpdate()
			end)
		end

		scheduleUpdate()
		return function()
			flag = true

			if thread ~= nil then
				task.cancel(thread)
				thread = nil
			end
		end
	end, { v2 })

	local relativeAge = commentTimestamp.getRelativeAge(v2, state)
	local v3 = useLocalization({
		timestamp = relativeAge ~= nil and (relativeAge.unit == "now" and "Feature.Moments.Label.CommentTimestampNow" or {
			v[relativeAge.unit],
			count = relativeAge.count
		}) or nil
	})

	return if relativeAge ~= nil then v3.timestamp else nil
end

return useCommentTimestamp
