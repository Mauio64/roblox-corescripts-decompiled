local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")
local parent = CurrencyTransfers.Parent
local React = require(parent.React)
local SharedFlags = require(parent.SharedFlags)

local InExperienceTransferFlow = require(CurrencyTransfers.Flows.InExperienceTransferFlow)
local InExperienceTransferUpsellApp = require(CurrencyTransfers.Components.InExperienceTransferUpsellApp)
local useInExperienceTransferListenerEffect = require(CurrencyTransfers.Hooks.useInExperienceTransferListenerEffect)

local function InExperienceTransferApp()
	local state, setState = React.useState(nil)

	local v = React.useCallback(function(p)
		setState(function(p2)
			return if p2 == nil then p else p2
		end)
	end, {})

	local onClose = React.useCallback(function()
		setState(nil)
	end, {})

	useInExperienceTransferListenerEffect(v)

	local inExperienceTransferFlow = React.useMemo(function()
		if state == nil then
			return nil
		end

		return InExperienceTransferFlow({ initiateResponse = state, onClose = onClose })
	end, { state, onClose })
	local upsellApp

	if SharedFlags.GetEngineFeatureEnablePromptRobuxTransferDedicatedUpsellEvent() then
		upsellApp = React.createElement(InExperienceTransferUpsellApp)
	end

	local flowScreen

	if inExperienceTransferFlow then
		flowScreen = React.createElement(
			"ScreenGui",
			{
				ScreenInsets = Enum.ScreenInsets.None,
				ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
				DisplayOrder = 8
			},
			{ InExperienceTransferFlow = inExperienceTransferFlow }
		)
	end

	if flowScreen or upsellApp then
		if upsellApp then
			return React.createElement(React.Fragment, nil, {
				FlowScreen = flowScreen,
				UpsellApp = upsellApp
			})
		end

		return flowScreen
	end

	return nil
end

return InExperienceTransferApp
