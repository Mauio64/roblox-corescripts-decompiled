local useRemainingTime = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceUIKit").Hooks.useRemainingTime
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/Localization").Hooks.useLocalization

local getRemainingTimeText = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Utils/getRemainingTimeText")

local function useRemainingTimeText(p2)
	local v5 = useRemainingTime(p2)
	local v6 = v5 == nil and 0 or v5.value

	local v7 = useLocalization({
		daySingular = "Feature.InExperienceShop.Label.Timer.Day.Singular",
		dayPlural = {
			"Feature.InExperienceShop.Label.Timer.Day.Plural",
			number = v6
		},
		hourSingular = "Feature.InExperienceShop.Label.Timer.Hour.Singular",
		hourPlural = {
			"Feature.InExperienceShop.Label.Timer.Hour.Plural",
			number = v6
		},
		minuteSingular = "Feature.InExperienceShop.Label.Timer.Minute.Singular",
		minutePlural = {
			"Feature.InExperienceShop.Label.Timer.Minute.Plural",
			number = v6
		},
		secondSingular = "Feature.InExperienceShop.Label.Timer.Second.Singular",
		secondPlural = {
			"Feature.InExperienceShop.Label.Timer.Second.Plural",
			number = v6
		}
	})

	if v5 == nil or v5.value <= 0 then
		return nil
	end

	return getRemainingTimeText(v5, v7)
end

return useRemainingTimeText
