local appPage = require("@luauforge/bundled/hwj").AppPage
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceShop/React")
local module2 = require("@luauforge/bundled/hwr")
local module3 = require("@luauforge/bundled/hwG")

local module4 = require("@luauforge/bundled/hwH")
local module5 = require("@luauforge/bundled/hwY")
local module6 = require("@luauforge/bundled/hwC")
local module7 = require("@luauforge/bundled/hwU")
local module8 = require("@luauforge/bundled/hwX")
local module9 = require("@luauforge/bundled/hyw")

local v5 = {
	MissingPurchaseFlowUuid = "MissingPurchaseFlowUuid",
	MissingInputData = "MissingInputData",
	MissingRobuxBalance = "MissingRobuxBalance"
}

local function getSkippedReason(data): nil | string
	if data.purchaseFlowUuid == nil or data.purchaseFlowUuid == "" then
		return "MissingPurchaseFlowUuid"
	end

	if data.inputData == nil then
		return "MissingInputData"
	end

	if data.isBalanceFetchSettled then
		return nil
	end

	return "MissingRobuxBalance"
end

local function useTrackBuyRobuxPageShown(current, p2)
	local v6 = module2.useInputData(appPage.BuyRobux, module6.PageEntryIdentifier)
	local v7 = module3.useSignalState(module7().getSignal(module6.PageScopeFieldRobuxBalanceFetchSettled))

	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)
	ref2.current = {
		purchaseFlowUuid = current,
		isPageDataReady = p2,
		inputData = v6,
		isBalanceFetchSettled = v7
	}

	React.useEffect(function()
		if current == nil or current == "" or ref.current == current or not p2 or v6 == nil or not v7 then
			return
		end

		ref.current = current
		module9(module8(current), v6)
		module4.trackCounter("PageShownTracked")
	end, { v6, p2, current, v7 })

	React.useEffect(function()
		return function()
			local current2 = ref2.current

			if
				current2 == nil
				or not current2.isPageDataReady
				or ref.current ~= nil and ref.current == current2.purchaseFlowUuid
			then
				return
			end

			local v8

			if current2.purchaseFlowUuid == nil or current2.purchaseFlowUuid == "" then
				v8 = v5.MissingPurchaseFlowUuid
			elseif current2.inputData == nil then
				v8 = v5.MissingInputData
			elseif not current2.isBalanceFetchSettled then
				v8 = v5.MissingRobuxBalance
			end

			if v8 ~= nil then
				module4.trackCounter("PageShownSkipped", { reason = v8 })
			end
		end
	end, {})

	React.useEffect(function()
		return function()
			if current ~= nil then
				module5.remove(current)
			end
		end
	end, { current })
end

return useTrackBuyRobuxPageShown
