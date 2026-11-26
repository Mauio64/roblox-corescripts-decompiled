local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceUIKit/React")
local badge = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceUIKit/Foundation").Badge
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceUIKit/Localization").Hooks.useLocalization

local useRemainingTime = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceUIKit/AvatarExperienceUIKit/Utils/useRemainingTime")

local function getTimerText(p2, data)
	local unit = p2.unit
	local v5 = p2.value ~= 1

	if unit == "days" then
		if v5 then
			return data.dayPlural
		end

		return data.daySingular
	elseif unit == "hours" then
		if v5 then
			return data.hourPlural
		end

		return data.hourSingular
	elseif unit == "minutes" then
		if v5 then
			return data.minutePlural
		end

		return data.minuteSingular
	elseif v5 then
		return data.secondPlural
	else
		return data.secondSingular
	end
end

local function TimerBadge(props)
	local v5 = useRemainingTime(props.endTime)

	local v6 = not v5 and 0 or v5.value

	local v7 = useLocalization({
		daySingular = "Feature.Catalog.Label.Timer.Day.Singular",
		dayPlural = {
			"Feature.Catalog.Label.Timer.Day.Plural",
			number = v6
		},
		hourSingular = "Feature.Catalog.Label.Timer.Hour.Singular",
		hourPlural = {
			"Feature.Catalog.Label.Timer.Hour.Plural",
			number = v6
		},
		minuteSingular = "Feature.Catalog.Label.Timer.Minute.Singular",
		minutePlural = {
			"Feature.Catalog.Label.Timer.Minute.Plural",
			number = v6
		},
		secondSingular = "Feature.Catalog.Label.Timer.Second.Singular",
		secondPlural = {
			"Feature.Catalog.Label.Timer.Second.Plural",
			number = v6
		}
	})

	if not v5 or v5.value < 0 then
		return nil
	end

	local createElement = React.createElement
	local v9 = { LayoutOrder = props.LayoutOrder, text = 0, variant = 0 }
	local unit = v5.unit
	local v10 = v5.value ~= 1
	local v11

	if unit == "days" then
		v11 = if v10 then v7.dayPlural else v7.daySingular
	elseif unit == "hours" then
		v11 = if v10 then v7.hourPlural else v7.hourSingular
	elseif unit == "minutes" then
		v11 = if v10 then v7.minutePlural else v7.minuteSingular
	else
		v11 = if v10 then v7.secondPlural else v7.secondSingular
	end

	v9.text = v11
	v9.variant = props.badgeVariant
	return createElement(badge, v9)
end

return TimerBadge
