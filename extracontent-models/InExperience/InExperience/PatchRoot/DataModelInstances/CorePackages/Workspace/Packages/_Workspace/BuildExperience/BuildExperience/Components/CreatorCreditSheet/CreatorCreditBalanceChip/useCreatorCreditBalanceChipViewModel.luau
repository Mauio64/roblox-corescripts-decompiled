local Parent = script:FindFirstAncestor("BuildExperience").Parent
local LocalizationService = game:GetService("LocalizationService")
local CreatorCredit = require(Parent.DataHydration.CreatorCredit)
local NumberLocalization = require(Parent.Localization).NumberLocalization
local React = require(Parent.React)
local SignalsReact = require(Parent.SignalsReact)

require(script.Parent.CreatorCreditBalanceChipView)

local useOpenBuyRobuxWebView = require(script.Parent.Parent.useOpenBuyRobuxWebView)

local function formatBalance(n1: number) -- line: 17
	-- upvalues: NumberLocalization (copy), LocalizationService (copy)
	return NumberLocalization.localize(string.format("%.0f", (math.floor(n1))), LocalizationService.RobloxLocaleId)
end
local function useCreatorCreditBalanceChipViewModel() -- line: 21
	-- upvalues: CreatorCredit (copy), React (copy), SignalsReact (copy), useOpenBuyRobuxWebView (copy), NumberLocalization (copy), LocalizationService (copy)
	local v11 = CreatorCredit.getCreatorCreditStore(false)
	local v12 = React.useMemo(function() -- line: 23
		-- upvalues: v11 (copy)
		return v11.getQuotaSummary()
	end, { v11 })
	local v13 = SignalsReact.useSignalState(v12.data)
	local v14 = React.useCallback(function() -- line: 27
		-- upvalues: v11 (copy)
		v11.refreshQuotaSummary():catch(function() -- line: 28
		end)
	end, { v11 })
	local v15 = useOpenBuyRobuxWebView(v14)
	local t1 = {}
	local v18

	if v13 ~= nil then
		local robuxBalance = v13.robuxBalance

		v18 = NumberLocalization.localize(string.format("%.0f", (math.floor(robuxBalance))), LocalizationService.RobloxLocaleId)
	else
		v18 = nil
	end

	t1.balanceText = v18
	t1.onActivated = v15

	return t1
end

return useCreatorCreditBalanceChipViewModel
