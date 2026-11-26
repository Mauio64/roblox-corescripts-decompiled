local appPage = require("@luauforge/bundled/hHo").AppPage
local module = require("@luauforge/bundled/hHu")
local module2 = require("@luauforge/bundled/hHx")
local module3 = require("@luauforge/bundled/hHO")

local module4 = require("@luauforge/bundled/hHP")
local module5 = require("@luauforge/bundled/hIg")
local module6 = require("@luauforge/bundled/hHI")
local module7 = require("@luauforge/bundled/hIc")
local module8 = require("@luauforge/bundled/hIf")
local module9 = require("@luauforge/bundled/hJJ")

local module10 = require("@luauforge/bundled/hHJ")

local v5 = {
	MissingPurchaseFlowUuid = "MissingPurchaseFlowUuid",
	MissingInputData = "MissingInputData",
	MissingRobuxBalance = "MissingRobuxBalance",
	ContentNotReady = "ContentNotReady",
	PageFetchFailed = "PageFetchFailed"
}

local function getSkippedReason(data): nil | string
	if module10 and data.isPageFetchFailed then
		return "PageFetchFailed"
	end

	if data.purchaseFlowUuid == nil or data.purchaseFlowUuid == "" then
		return "MissingPurchaseFlowUuid"
	end

	if data.inputData == nil then
		return "MissingInputData"
	end

	if not data.isBalanceFetchSettled then
		return "MissingRobuxBalance"
	end

	if module10 and not data.isRenderedReady then
		return "ContentNotReady"
	end

	return nil
end

local function useTrackBuyRobuxPageShown(current, p2)
	local v6 = module2.useInputData(appPage.BuyRobux, module6.PageEntryIdentifier)
	local v7 = module3.useSignalState(module7().getSignal(module6.PageScopeFieldRobuxBalanceFetchSettled))

	local v8 = if module10 then module2.useUiStatus(appPage.BuyRobux) == module2.UiStatus.Error else nil

	local v9 = p2
	local v10

	if module10 then
		v10 = module3.useSignalState(module7().getSignal(module6.PageScopeFieldHasRenderedSduiContent)) == true
	end

	if module10 then
		v9 = if p2 then v10 == true and v8 ~= true else p2
	end

	local ref = module.useRef(nil)
	local ref2 = module.useRef(nil)
	ref2.current = {
		purchaseFlowUuid = current,
		isPageDataReady = p2,
		isRenderedReady = v10,
		isPageFetchFailed = v8,
		inputData = v6,
		isBalanceFetchSettled = v7
	}

	module.useEffect(function()
		if current == nil or current == "" or ref.current == current or not v9 or v6 == nil or not v7 then
			return
		end

		ref.current = current
		module9(module8(current), v6)
		module4.trackCounter("PageShownTracked")
	end, { v6, v9, current, v7 })

	module.useEffect(function()
		return function()
			local current2 = ref2.current

			if
				current2 == nil
				or not current2.isPageDataReady
				or ref.current ~= nil and ref.current == current2.purchaseFlowUuid
			then
				return
			end

			local v11

			if module10 and current2.isPageFetchFailed then
				v11 = v5.PageFetchFailed
			elseif current2.purchaseFlowUuid == nil or current2.purchaseFlowUuid == "" then
				v11 = v5.MissingPurchaseFlowUuid
			elseif current2.inputData == nil then
				v11 = v5.MissingInputData
			elseif current2.isBalanceFetchSettled then
				if module10 and not current2.isRenderedReady then
					v11 = v5.ContentNotReady
				end
			else
				v11 = v5.MissingRobuxBalance
			end

			if v11 ~= nil then
				module4.trackCounter("PageShownSkipped", { reason = v11 })
			end
		end
	end, {})

	module.useEffect(function()
		return function()
			if current ~= nil then
				module5.remove(current)
			end
		end
	end, { current })
end

return useTrackBuyRobuxPageShown
