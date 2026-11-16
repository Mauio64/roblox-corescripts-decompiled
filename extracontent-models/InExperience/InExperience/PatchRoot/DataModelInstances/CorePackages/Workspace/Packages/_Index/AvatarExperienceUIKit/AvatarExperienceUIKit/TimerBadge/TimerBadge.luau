local AvatarExperienceUIKit = script:FindFirstAncestor("AvatarExperienceUIKit")
local parent = AvatarExperienceUIKit.Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Badge = Foundation.Badge
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local useRemainingTime = require(AvatarExperienceUIKit.Utils.useRemainingTime)

local function getTimerText(p, data) -- 1 equivalent call inferred from this helper
	local unit = p.unit
	local v = p.value ~= 1

	if unit == "days" then
		return if v then data.dayPlural else data.daySingular
	elseif unit == "hours" then
		return if v then data.hourPlural else data.hourSingular
	elseif unit == "minutes" then
		if v then
			return data.minutePlural
		end

		return data.minuteSingular
	elseif v then
		return data.secondPlural
	else
		return data.secondSingular
	end
end

local function TimerBadge(props)
	local v = useRemainingTime(props.endTime)

	local number = not v and 0 or v.value

	local v2 = useLocalization({
		daySingular = "Feature.Catalog.Label.Timer.Day.Singular",
		dayPlural = {
			"Feature.Catalog.Label.Timer.Day.Plural",
			number = number
		},
		hourSingular = "Feature.Catalog.Label.Timer.Hour.Singular",
		hourPlural = {
			"Feature.Catalog.Label.Timer.Hour.Plural",
			number = number
		},
		minuteSingular = "Feature.Catalog.Label.Timer.Minute.Singular",
		minutePlural = {
			"Feature.Catalog.Label.Timer.Minute.Plural",
			number = number
		},
		secondSingular = "Feature.Catalog.Label.Timer.Second.Singular",
		secondPlural = {
			"Feature.Catalog.Label.Timer.Second.Plural",
			number = number
		}
	})

	if not v or v.value < 0 then
		return nil
	end

	return React.createElement(Badge, {
		LayoutOrder = props.LayoutOrder,
		text = getTimerText(v, v2), -- inferred equivalent call
		variant = props.badgeVariant
	})
end

return TimerBadge
