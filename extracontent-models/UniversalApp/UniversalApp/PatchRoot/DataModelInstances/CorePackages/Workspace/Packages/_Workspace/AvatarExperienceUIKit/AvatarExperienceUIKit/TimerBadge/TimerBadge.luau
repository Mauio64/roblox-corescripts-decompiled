local AvatarExperienceUIKit = script:FindFirstAncestor("AvatarExperienceUIKit")
local AvatarExperienceUIKitParent = AvatarExperienceUIKit.Parent
local React = require(AvatarExperienceUIKitParent.React)
local Badge = require(AvatarExperienceUIKitParent.Foundation).Badge
local useLocalization = require(AvatarExperienceUIKitParent.Localization).Hooks.useLocalization
local useRemainingTime = require(AvatarExperienceUIKit.Utils.useRemainingTime)

local function getTimerText(p1, t1: {[any]: any}) -- line: 23
	local unit = p1.unit
	local v12 = p1.value ~= 1

	if unit == "days" then
		if v12 then
			return t1.dayPlural
		end

		return t1.daySingular
	end

	if unit == "hours" then
		if v12 then
			return t1.hourPlural
		end

		return t1.hourSingular
	end

	if unit == "minutes" then
		if v12 then
			return t1.minutePlural
		end

		return t1.minuteSingular
	end

	if v12 then
		return t1.secondPlural
	end

	return t1.secondSingular
end
local function TimerBadge(t2: {[any]: any}) -- line: 38
	-- upvalues: useRemainingTime (copy), useLocalization (copy), React (copy), Badge (copy)
	local v14 = useRemainingTime(t2.endTime)
	local v15 = not v14 and 0 or v14.value
	local v16 = useLocalization({
		daySingular = "Feature.Catalog.Label.Timer.Day.Singular",
		hourSingular = "Feature.Catalog.Label.Timer.Hour.Singular",
		minuteSingular = "Feature.Catalog.Label.Timer.Minute.Singular",
		secondSingular = "Feature.Catalog.Label.Timer.Second.Singular",
		dayPlural = {
			"Feature.Catalog.Label.Timer.Day.Plural",
			number = v15
		},
		hourPlural = {
			"Feature.Catalog.Label.Timer.Hour.Plural",
			number = v15
		},
		minutePlural = {
			"Feature.Catalog.Label.Timer.Minute.Plural",
			number = v15
		},
		secondPlural = {
			"Feature.Catalog.Label.Timer.Second.Plural",
			number = v15
		}
	})

	if not v14 or v14.value < 0 then
		return nil
	end

	local createElement = React.createElement
	local v18 = Badge
	local t3 = {
		LayoutOrder = t2.LayoutOrder
	}
	local unit = v14.unit
	local v21 = v14.value ~= 1

	t3.text = if unit ~= "days" then if unit ~= "hours" then if unit ~= "minutes" then if not v21 then v16.secondSingular else v16.secondPlural else if not v21 then v16.minuteSingular else v16.minutePlural else if not v21 then v16.hourSingular else v16.hourPlural else if not v21 then v16.daySingular else v16.dayPlural
	t3.variant = t2.badgeVariant

	return createElement(v18, t3)
end

return TimerBadge
