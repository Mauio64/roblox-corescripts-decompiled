local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local LocalizationService = game:GetService("LocalizationService")
local Foundation = require(BuildExperienceParent.Foundation)
local NumberLocalization = require(BuildExperienceParent.Localization).NumberLocalization
local React = require(BuildExperienceParent.React)
local SignalsReact = require(BuildExperienceParent.SignalsReact)
local getCreatorCreditStore = require(BuildExperienceParent.DataHydration.CreatorCredit).getCreatorCreditStore
local FFlagBuildExperienceCreatorCreditUsageBadge = require(BuildExperience.Flags.FFlagBuildExperienceCreatorCreditUsageBadge)
local LocalizationStrings = require(BuildExperience.LocalizationStrings)
local IconName = Foundation.Enums.IconName

local function formatNumber(n1: number) -- line: 33
	-- upvalues: NumberLocalization (copy), LocalizationService (copy)
	return NumberLocalization.localize(string.format("%.0f", (math.floor(n1))), LocalizationService.RobloxLocaleId)
end

return {
	ITEM_ID = "creator-credit-ai-usage",
	useCreatorCreditMenuItem = function(t1: {[any]: any}?) -- line: 41
		-- upvalues: React (copy), getCreatorCreditStore (copy), SignalsReact (copy), FFlagBuildExperienceCreatorCreditUsageBadge (copy), IconName (copy), LocalizationStrings (copy), NumberLocalization (copy), LocalizationService (copy), formatNumber (copy)
		local v15 = if t1 == nil then nil else t1.onOpenCreatorCreditPage
		local v16 = React.useCallback(function() -- line: 44
			-- upvalues: v15 (copy)
			if v15 then
				v15()
			end
		end, { v15 })
		local v17 = getCreatorCreditStore(false)
		local v18 = React.useMemo(function() -- line: 55
			-- upvalues: v17 (copy)
			return v17.getQuotaSummary()
		end, { v17 })
		local v19 = SignalsReact.useSignalState(v18.data)

		return {
			item = React.useMemo(function() -- line: 60
				-- upvalues: v19 (copy), FFlagBuildExperienceCreatorCreditUsageBadge (copy), IconName (copy), LocalizationStrings (copy), NumberLocalization (copy), LocalizationService (copy), formatNumber (copy)
				local t2 = nil

				if v19 ~= nil then
					if FFlagBuildExperienceCreatorCreditUsageBadge then
						local v21 = v19.freeTrialPctUsed >= 100 and v19.limitSettings.additionalUsageEnabled
						local v22 = if not v21 then nil else IconName.Robux
						local v23 = LocalizationStrings.formatCreatorCreditPercentUsed(v19.freeTrialPctUsed)

						if v21 then
							if v19.limitSettings.dailyLimitSet then
								local formatCreatorCreditRobuxUsage = LocalizationStrings.formatCreatorCreditRobuxUsage
								local robuxSpentToday = v19.robuxSpentToday

								v23 = formatCreatorCreditRobuxUsage(NumberLocalization.localize(string.format("%.0f", (math.floor(robuxSpentToday))), LocalizationService.RobloxLocaleId), formatNumber(v19.limitSettings.dailyLimit))
							else
								v23 = LocalizationStrings.formatCreatorCreditRobuxUsageUnlimited(formatNumber(v19.robuxSpentToday))
							end
						end

						t2 = {
							type = "Badge",
							icon = v22,
							text = v23
						}
					else
						t2 = {
							type = "Hint",
							text = LocalizationStrings.formatCreatorCreditPercentUsed(v19.freeTrialPctUsed)
						}
					end
				end

				return {
					id = "creator-credit-ai-usage",
					text = LocalizationStrings.CREATOR_CREDIT_MENU_ITEM,
					trailing = t2
				}
			end, { v19 }),
			activate = v16
		}
	end
}
