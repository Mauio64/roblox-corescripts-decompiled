local React = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/React")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/SharedFlags")

local module3 = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Flows/InExperienceTransferFlow")
local InExperienceTransferUpsellApp = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Components/InExperienceTransferUpsellApp")
local useInExperienceTransferListenerEffect = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Hooks/useInExperienceTransferListenerEffect")

local function InExperienceTransferApp()
	local state, setState = React.useState(nil)

	local v5 = React.useCallback(function(p2)
		setState(function(p3)
			if p3 == nil then
				return p2
			end

			return p3
		end)
	end, {})

	local v6 = React.useCallback(function()
		setState(nil)
	end, {})

	useInExperienceTransferListenerEffect(v5)

	local v7 = React.useMemo(function()
		if state == nil then
			return nil
		end

		return module3({ initiateResponse = state, onClose = v6 })
	end, { state, v6 })
	local v8

	if SharedFlags.GetEngineFeatureEnablePromptRobuxTransferDedicatedUpsellEvent() then
		v8 = React.createElement(InExperienceTransferUpsellApp)
	end

	local v9

	if v7 then
		v9 = React.createElement(
			"ScreenGui",
			{
				ScreenInsets = Enum.ScreenInsets.None,
				ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
				DisplayOrder = 8
			},
			{ InExperienceTransferFlow = v7 }
		)
	end

	if v9 or v8 then
		if v8 then
			return React.createElement(React.Fragment, nil, {
				FlowScreen = v9,
				UpsellApp = v8
			})
		end

		return v9
	end

	return nil
end

return InExperienceTransferApp
