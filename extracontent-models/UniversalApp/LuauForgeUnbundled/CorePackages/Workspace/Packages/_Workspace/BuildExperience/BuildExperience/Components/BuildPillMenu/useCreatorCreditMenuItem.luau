local LocalizationService = game:GetService("LocalizationService")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local numberLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Localization").NumberLocalization
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SignalsReact")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Localization").Hooks.useLocalization

local getCreatorCreditStore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/CreatorCredit").getCreatorCreditStore
local LocalizationStrings = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/LocalizationStrings")

local iconName = Foundation.Enums.IconName

local function formatNumber(p2)
	return numberLocalization.localize(
		string.format("%.0f", (math.floor(p2))),
		LocalizationService.RobloxLocaleId
	)
end

return {
	useCreatorCreditMenuItem = function(p2)
		local onOpenCreatorCreditPage = if p2 ~= nil then p2.onOpenCreatorCreditPage else nil

		local v5 = React.useCallback(function()
			if onOpenCreatorCreditPage then
				onOpenCreatorCreditPage()
			end
		end, { onOpenCreatorCreditPage })

		local creatorCreditStore = getCreatorCreditStore(false)
		local v6 = React.useMemo(function()
			return creatorCreditStore.getQuotaSummary()
		end, { creatorCreditStore })
		local v7 = SignalsReact.useSignalState(v6.data)
		local v9 = { menuItem = LocalizationStrings.CREATOR_CREDIT_MENU_ITEM, usage = 0 }
		local v10

		if v7 ~= nil then
			if v7.freeTrialPctUsed < 100 or not v7.limitSettings.additionalUsageEnabled then
				v10 = {
					LocalizationStrings.CREATOR_CREDIT_PERCENT_USED,
					PERCENT = math.clamp(math.floor(v7.freeTrialPctUsed + 0.5), 0, 100)
				}
			elseif v7.limitSettings.dailyLimitSet then
				v10 = { [1] = nil, [1] = nil, LocalizationStrings.CREATOR_CREDIT_ROBUX_USAGE }
				local robuxSpentToday = v7.robuxSpentToday
				v10.USED = numberLocalization.localize(
					string.format("%.0f", (math.floor(robuxSpentToday))),
					LocalizationService.RobloxLocaleId
				)
				local dailyLimit = v7.limitSettings.dailyLimit
				v10.LIMIT = numberLocalization.localize(
					string.format("%.0f", (math.floor(dailyLimit))),
					LocalizationService.RobloxLocaleId
				)
			else
				v10 = { [1] = nil, LocalizationStrings.CREATOR_CREDIT_USAGE_USED }
				local robuxSpentToday = v7.robuxSpentToday
				v10.USED = numberLocalization.localize(
					string.format("%.0f", (math.floor(robuxSpentToday))),
					LocalizationService.RobloxLocaleId
				)
			end
		end

		v9.usage = v10
		local v11 = useLocalization(v9)

		local menuItem = v11.menuItem

		return {
			item = React.useMemo(function()
				local v12

				if v7 ~= nil then
					local v13 = v7.freeTrialPctUsed >= 100 and v7.limitSettings.additionalUsageEnabled
					v12 = {
						type = "Badge",
						icon = if v13 then iconName.Robux else nil,
						text = v11.usage or ""
					}
				end

				return {
					id = "creator-credit-ai-usage",
					text = menuItem,
					trailing = v12
				}
			end, { v7, v11, menuItem }),
			activate = v5
		}
	end,
	ITEM_ID = "creator-credit-ai-usage"
}
