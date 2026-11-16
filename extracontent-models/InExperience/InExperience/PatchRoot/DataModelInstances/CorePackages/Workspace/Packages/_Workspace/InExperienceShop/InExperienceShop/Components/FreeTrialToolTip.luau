local InExperienceShop = script:FindFirstAncestor("InExperienceShop")
local parent = InExperienceShop.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local SignalsReact = require(parent.SignalsReact)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local FFlagEnableExperienceShopGlobalIcon = require(InExperienceShop.Flags.FFlagEnableExperienceShopGlobalIcon)
local GetShopGlobalIconStore = require(InExperienceShop.Stores.GetShopGlobalIconStore)
local submitFreeTrialTooltips = require(InExperienceShop.submitFreeTrialTooltips)

local EducationalTooltip = Foundation.EducationalTooltip
local OverlayProvider = Foundation.OverlayProvider
local ButtonVariant = Foundation.Enums.ButtonVariant
local PopoverSide = Foundation.Enums.PopoverSide
local PopoverAlign = Foundation.Enums.PopoverAlign

local function FreeTrialToolTip(props)
	local v = SignalsReact.useSignalState(submitFreeTrialTooltips.getActiveTooltip)

	local current2 = SignalsReact.useSignalState(function(p)
		if FFlagEnableExperienceShopGlobalIcon then
			return GetShopGlobalIconStore(p).getIconInstance(p)
		end

		return nil
	end)

	local anchorRef = React.useRef(current2)
	anchorRef.current = current2
	local v2

	if v == nil then
		v2 = false
	else
		v2 = v.slot == "EducationTooltipOnShopIcon"
	end

	if not v2 then
		anchorRef = props.anchorRef
	end

	local state, setState = React.useState(false)
	React.useEffect(function()
		setState(anchorRef ~= nil and anchorRef.current ~= nil)
	end, { anchorRef, current2, props.anchorRef })

	local state2, setState2 = React.useState(false)
	local v3 = React.useCallback(function(p: string)
		setState2(true)
		submitFreeTrialTooltips.dismiss(p)
	end, {})
	local action

	if v == nil then
		action = nil
	else
		action = v.action
	end

	local gamePassId

	if v == nil then
		gamePassId = nil
	else
		gamePassId = v.gamePassId
	end

	local onActivated = React.useCallback(function()
		submitFreeTrialTooltips.reportActivated()
		v3("activated")

		if action ~= "promptGamePassPurchase" or gamePassId == nil then
			props.onOpenShop()
			return
		end

		local initiateShopItemPurchase = require(InExperienceShop.initiateShopItemPurchase)
		initiateShopItemPurchase(gamePassId, "GamePass")
	end, { v3, props.onOpenShop, action, gamePassId })

	local v4 = useLocalization({
		title = v == nil and "" or v.title,
		actionText = v == nil and "" or v.actionText
	})
	local v5

	if v == nil then
		v5 = false
	else
		v5 = state and not state2
	end

	local v6

	if v2 then
		v6 = v5 and current2 ~= nil
	else
		v6 = v5 and props.visible == true
	end

	local tooltipQueue = props.tooltipQueue
	local current3

	if tooltipQueue == nil then
		current3 = false
	else
		current3 = tooltipQueue.isCurrentTooltip("TRIAL_AVAILABLE_TOOLTIP") == true
	end

	local ref = React.useRef(tooltipQueue)
	React.useEffect(function()
		ref.current = tooltipQueue
	end, { tooltipQueue })

	local v7 = v == nil and 0 or v.delayMs
	local v8 = v == nil and 0 or v.durationMs
	React.useEffect(function()
		local current = ref.current

		if not v6 or current == nil or props.priority == nil then
			return
		end

		current.registerTooltip("TRIAL_AVAILABLE_TOOLTIP", props.priority, v7, v8)
		return function()
			current.unregisterTooltip("TRIAL_AVAILABLE_TOOLTIP")
		end
	end, { v6, props.priority, v7, v8 })

	local ref2 = React.useRef(false)
	React.useEffect(function()
		if ref2.current and not current3 and v6 then
			v3("timeout")
		end

		ref2.current = current3
	end, { current3, v6, v3 })
	local v9

	if v6 == true then
		v9 = current3
	else
		v9 = false
	end

	React.useEffect(function()
		if not v9 then
			return
		end

		submitFreeTrialTooltips.reportMounted()
		submitFreeTrialTooltips.reportViewed()
	end, { v9 })

	if v9 and v ~= nil then
		return React.createElement(OverlayProvider, nil, {
			Tooltip = React.createElement(EducationalTooltip, {
				anchorRef = anchorRef,
				title = v4.title .. string.rep(" ", 10),
				side = PopoverSide.Bottom,
				align = PopoverAlign.Start,
				isOpen = true,
				actions = {
					{
						text = v4.actionText,
						variant = ButtonVariant.Emphasis,
						onActivated = onActivated,
						width = UDim.new(1, 0)
					}
				},
				onClose = function()
					v3("user")
				end,
				onPressedOutside = function()
					v3("user")
				end,
				testId = "trial-available-tooltip"
			})
		})
	end

	return nil
end

return React.memo(FreeTrialToolTip)
