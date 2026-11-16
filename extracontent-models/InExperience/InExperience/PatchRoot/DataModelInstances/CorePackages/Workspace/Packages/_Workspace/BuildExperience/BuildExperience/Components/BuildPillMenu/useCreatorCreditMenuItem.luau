local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local LocalizationService = game:GetService("LocalizationService")

local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local NumberLocalization = Localization.NumberLocalization
local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)
local Localization2 = require(parent.Localization)
local useLocalization = Localization2.Hooks.useLocalization

local CreatorCredit = require(parent.DataHydration.CreatorCredit)
local getCreatorCreditStore = CreatorCredit.getCreatorCreditStore
local LocalizationStrings = require(BuildExperience.LocalizationStrings)

local IconName = Foundation.Enums.IconName

local function formatNumber(p: number) -- 3 equivalent calls inferred from this helper
	return NumberLocalization.localize(string.format("%.0f", (math.floor(p))), LocalizationService.RobloxLocaleId)
end

return {
	useCreatorCreditMenuItem = function(p)
		local onOpenCreatorCreditPage

		if p == nil then
			onOpenCreatorCreditPage = nil
		else
			onOpenCreatorCreditPage = p.onOpenCreatorCreditPage
		end

		local activate = React.useCallback(function()
			if onOpenCreatorCreditPage then
				onOpenCreatorCreditPage()
			end
		end, { onOpenCreatorCreditPage })

		local creatorCreditStore = getCreatorCreditStore(false)
		local v = React.useMemo(function()
			return creatorCreditStore.getQuotaSummary()
		end, { creatorCreditStore })
		local v2 = SignalsReact.useSignalState(v.data)
		local v3 = { menuItem = LocalizationStrings.CREATOR_CREDIT_MENU_ITEM, usage = 0 }
		local usage

		if v2 ~= nil then
			if v2.freeTrialPctUsed < 100 or not v2.limitSettings.additionalUsageEnabled then
				usage = {
					LocalizationStrings.CREATOR_CREDIT_PERCENT_USED,
					PERCENT = math.clamp(math.floor(v2.freeTrialPctUsed + 0.5), 0, 100)
				}
			elseif v2.limitSettings.dailyLimitSet then
				usage = { [1] = nil, [1] = nil, LocalizationStrings.CREATOR_CREDIT_ROBUX_USAGE }
				usage.USED = formatNumber(v2.robuxSpentToday) -- inferred equivalent call
				usage.LIMIT = formatNumber(v2.limitSettings.dailyLimit) -- inferred equivalent call
			else
				usage = { [1] = nil, LocalizationStrings.CREATOR_CREDIT_USAGE_USED }
				usage.USED = formatNumber(v2.robuxSpentToday) -- inferred equivalent call
			end
		end

		v3.usage = usage
		local v4 = useLocalization(v3)

		local menuItem = v4.menuItem

		return {
			item = React.useMemo(function()
				local trailing

				if v2 ~= nil then
					local v5

					if v2.freeTrialPctUsed >= 100 then
						v5 = v2.limitSettings.additionalUsageEnabled
					else
						v5 = false
					end

					local icon

					if v5 then
						icon = IconName.Robux
					end

					trailing = {
						type = "Badge",
						icon = icon,
						text = v4.usage or ""
					}
				end

				return { id = "creator-credit-ai-usage", text = menuItem, trailing = trailing }
			end, { v2, v4, menuItem }),
			activate = activate
		}
	end,
	ITEM_ID = "creator-credit-ai-usage"
}
