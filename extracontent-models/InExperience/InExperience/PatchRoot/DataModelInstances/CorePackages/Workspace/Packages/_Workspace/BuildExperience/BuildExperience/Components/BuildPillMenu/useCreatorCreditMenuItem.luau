local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent

require(BuildExperienceParent.Foundation)

local React = require(BuildExperienceParent.React)
local SignalsReact = require(BuildExperienceParent.SignalsReact)
local getCreatorCreditStore = require(BuildExperienceParent.DataHydration.CreatorCredit).getCreatorCreditStore
local LocalizationStrings = require(BuildExperience.LocalizationStrings)

return {
	ITEM_ID = "creator-credit-ai-usage",
	useCreatorCreditMenuItem = function(t1: {[any]: any}?) -- line: 34
		-- upvalues: React (copy), getCreatorCreditStore (copy), SignalsReact (copy), LocalizationStrings (copy)
		local v8 = if t1 == nil then nil else t1.onOpenCreatorCreditPage
		local v9 = React.useCallback(function() -- line: 37
			-- upvalues: v8 (copy)
			if v8 then
				v8()
			end
		end, { v8 })
		local v10 = getCreatorCreditStore(false)
		local v11 = React.useMemo(function() -- line: 48
			-- upvalues: v10 (copy)
			return v10.getQuotaSummary()
		end, { v10 })
		local v12 = SignalsReact.useSignalState(v11.data)

		return {
			item = React.useMemo(function() -- line: 53
				-- upvalues: v12 (copy), LocalizationStrings (copy)
				local t2 = nil

				if v12 ~= nil then
					t2 = {
						type = "Hint",
						text = LocalizationStrings.formatCreatorCreditPercentUsed(v12.freeTrialPctUsed)
					}
				end

				return {
					id = "creator-credit-ai-usage",
					text = LocalizationStrings.CREATOR_CREDIT_MENU_ITEM,
					trailing = t2
				}
			end, { v12 }),
			activate = v9
		}
	end
}
