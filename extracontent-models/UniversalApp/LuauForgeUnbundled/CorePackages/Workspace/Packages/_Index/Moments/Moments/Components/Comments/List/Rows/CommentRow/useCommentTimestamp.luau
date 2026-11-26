local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Localization")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")

local commentTimestamp = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/List/Rows/CommentRow/commentTimestamp")

local useLocalization = Localization.Hooks.useLocalization

local v5 = {
	minutes = "Feature.Moments.Label.CommentTimestampMinutes",
	hours = "Feature.Moments.Label.CommentTimestampHours",
	days = "Feature.Moments.Label.CommentTimestampDays",
	weeks = "Feature.Moments.Label.CommentTimestampWeeks",
	months = "Feature.Moments.Label.CommentTimestampMonths",
	years = "Feature.Moments.Label.CommentTimestampYears"
}

local function useCommentTimestamp(p2)
	local v6 = React.useMemo(function()
		return commentTimestamp.parseTimestamp(p2)
	end, { p2 })
	local state, setState = React.useState(function()
		return DateTime.now().UnixTimestampMillis
	end)

	React.useEffect(function()
		setState(DateTime.now().UnixTimestampMillis)

		if v6 == nil then
			return
		end

		local flag = false
		local thread = nil
		local function scheduleUpdate()
			local unixTimestampMillis = DateTime.now().UnixTimestampMillis
			local nextChangeTimestamp = commentTimestamp.getNextChangeTimestamp(v6, unixTimestampMillis)

			if nextChangeTimestamp == nil then
				thread = nil
				return
			end

			local v7 = math.max(0, nextChangeTimestamp - unixTimestampMillis) / 1000
			thread = task.delay(v7, function()
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
	end, { v6 })

	local relativeAge = commentTimestamp.getRelativeAge(v6, state)
	local v7 = useLocalization({
		timestamp = relativeAge ~= nil and (relativeAge.unit == "now" and "Feature.Moments.Label.CommentTimestampNow" or {
			v5[relativeAge.unit],
			count = relativeAge.count
		}) or nil
	})

	if relativeAge == nil then
		return nil
	end

	return v7.timestamp
end

return useCommentTimestamp
