local AvatarExperienceCommon = script:FindFirstAncestor("AvatarExperienceCommon")
local parent = AvatarExperienceCommon.Parent

local AvatarExperienceUIKit = require(parent.AvatarExperienceUIKit)
local useRemainingTime = AvatarExperienceUIKit.Hooks.useRemainingTime
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local getRemainingTimeText = require(AvatarExperienceCommon.Utils.getRemainingTimeText)

local function useRemainingTimeText(p: string?)
	local v = useRemainingTime(p)
	local number = v == nil and 0 or v.value

	local v2 = useLocalization({
		daySingular = "Feature.InExperienceShop.Label.Timer.Day.Singular",
		dayPlural = {
			"Feature.InExperienceShop.Label.Timer.Day.Plural",
			number = number
		},
		hourSingular = "Feature.InExperienceShop.Label.Timer.Hour.Singular",
		hourPlural = {
			"Feature.InExperienceShop.Label.Timer.Hour.Plural",
			number = number
		},
		minuteSingular = "Feature.InExperienceShop.Label.Timer.Minute.Singular",
		minutePlural = {
			"Feature.InExperienceShop.Label.Timer.Minute.Plural",
			number = number
		},
		secondSingular = "Feature.InExperienceShop.Label.Timer.Second.Singular",
		secondPlural = {
			"Feature.InExperienceShop.Label.Timer.Second.Plural",
			number = number
		}
	})

	if v == nil or v.value <= 0 then
		return nil
	end

	return getRemainingTimeText(v, v2)
end

return useRemainingTimeText
