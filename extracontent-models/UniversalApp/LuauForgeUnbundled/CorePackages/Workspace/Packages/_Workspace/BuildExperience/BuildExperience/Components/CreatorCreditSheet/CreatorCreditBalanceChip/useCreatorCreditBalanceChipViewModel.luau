local LocalizationService = game:GetService("LocalizationService")

local CreatorCredit = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/CreatorCredit")
local numberLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Localization").NumberLocalization
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SignalsReact")

require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/CreatorCreditSheet/CreatorCreditBalanceChip/CreatorCreditBalanceChipView")
local useOpenBuyRobuxWebView = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/CreatorCreditSheet/useOpenBuyRobuxWebView")
local FFlagBuildExperienceModelPicker = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceModelPicker")
local GetBuildCreatorCreditRefreshStore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/GetBuildCreatorCreditRefreshStore")

local function formatBalance(p2)
	return numberLocalization.localize(
		string.format("%.0f", (math.floor(p2))),
		LocalizationService.RobloxLocaleId
	)
end

local function useCreatorCreditBalanceChipViewModel()
	local creatorCreditStore = CreatorCredit.getCreatorCreditStore(false)
	local v5 = React.useMemo(function()
		return creatorCreditStore.getQuotaSummary()
	end, { creatorCreditStore })
	local v6 = SignalsReact.useSignalState(v5.data)
	local v8 = useOpenBuyRobuxWebView((React.useCallback(function()
		if FFlagBuildExperienceModelPicker then
			GetBuildCreatorCreditRefreshStore(false).refresh()
		else
			creatorCreditStore.refreshQuotaSummary():catch(function() end)
		end
	end, { creatorCreditStore })))
	local v10

	if v6 ~= nil then
		local robuxBalance = v6.robuxBalance
		v10 = numberLocalization.localize(
			string.format("%.0f", (math.floor(robuxBalance))),
			LocalizationService.RobloxLocaleId
		)
	end

	return { balanceText = v10, onActivated = v8 }
end

return useCreatorCreditBalanceChipViewModel
