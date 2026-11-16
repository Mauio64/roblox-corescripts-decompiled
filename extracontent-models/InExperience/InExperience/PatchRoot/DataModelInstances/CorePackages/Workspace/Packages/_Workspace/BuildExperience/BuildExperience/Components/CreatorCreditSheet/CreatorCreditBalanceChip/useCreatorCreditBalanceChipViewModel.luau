local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local LocalizationService = game:GetService("LocalizationService")

local CreatorCredit = require(parent.DataHydration.CreatorCredit)
local Localization = require(parent.Localization)
local NumberLocalization = Localization.NumberLocalization
local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)

require(script.Parent.CreatorCreditBalanceChipView)
local useOpenBuyRobuxWebView = require(script.Parent.Parent.useOpenBuyRobuxWebView)
local FFlagBuildExperienceModelPicker = require(BuildExperience.Flags.FFlagBuildExperienceModelPicker)
local GetBuildCreatorCreditRefreshStore = require(BuildExperience.Stores.GetBuildCreatorCreditRefreshStore)

local function formatBalance(robuxBalance: number) -- 1 equivalent call inferred from this helper
	return NumberLocalization.localize(
		string.format("%.0f", (math.floor(robuxBalance))),
		LocalizationService.RobloxLocaleId
	)
end

local function useCreatorCreditBalanceChipViewModel()
	local creatorCreditStore = CreatorCredit.getCreatorCreditStore(false)
	local v = React.useMemo(function()
		return creatorCreditStore.getQuotaSummary()
	end, { creatorCreditStore })
	local v2 = SignalsReact.useSignalState(v.data)
	local onActivated = useOpenBuyRobuxWebView((React.useCallback(function()
		if FFlagBuildExperienceModelPicker then
			GetBuildCreatorCreditRefreshStore(false).refresh()
		else
			creatorCreditStore.refreshQuotaSummary():catch(function() end)
		end
	end, { creatorCreditStore })))
	local balanceText

	if v2 ~= nil then
		balanceText = formatBalance(v2.robuxBalance) -- inferred equivalent call
	end

	return { balanceText = balanceText, onActivated = onActivated }
end

return useCreatorCreditBalanceChipViewModel
