local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")
local CurrencyTransfersParent = CurrencyTransfers.Parent
local React = require(CurrencyTransfersParent.React)
local SharedFlags = require(CurrencyTransfersParent.SharedFlags)
local InExperienceTransferFlow = require(CurrencyTransfers.Flows.InExperienceTransferFlow)
local InExperienceTransferUpsellApp = require(CurrencyTransfers.Components.InExperienceTransferUpsellApp)
local useInExperienceTransferListenerEffect = require(CurrencyTransfers.Hooks.useInExperienceTransferListenerEffect)

local function InExperienceTransferApp() -- line: 10
	-- upvalues: React (copy), useInExperienceTransferListenerEffect (copy), InExperienceTransferFlow (copy), SharedFlags (copy), InExperienceTransferUpsellApp (copy)
	local v9, v10 = React.useState(nil)
	local v11 = React.useCallback(function(p1) -- line: 13
		-- upvalues: v10 (copy)
		v10(function(p2) -- line: 16
			-- upvalues: p1 (copy)
			if p2 ~= nil then
				return p2
			end

			return p1
		end)
	end, {})
	local v12 = React.useCallback(function() -- line: 24
		-- upvalues: v10 (copy)
		v10(nil)
	end, {})

	useInExperienceTransferListenerEffect(v11)

	local v13 = React.useMemo(function() -- line: 33
		-- upvalues: v9 (copy), InExperienceTransferFlow (copy), v12 (copy)
		if v9 == nil then
			return nil
		end

		return InExperienceTransferFlow({
			initiateResponse = v9,
			onClose = v12
		})
	end, {
		v9,
		v12
	})
	local v14 = if not SharedFlags.GetEngineFeatureEnablePromptRobuxTransferDedicatedUpsellEvent() then nil else React.createElement(InExperienceTransferUpsellApp)
	local v15 = if not v13 then nil else React.createElement("ScreenGui", {
		DisplayOrder = 8,
		ScreenInsets = Enum.ScreenInsets.None,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	}, {
		InExperienceTransferFlow = v13
	})

	if not v15 and not v14 then
		return nil
	end

	if not v14 then
		return v15
	end

	return React.createElement(React.Fragment, nil, {
		FlowScreen = v15,
		UpsellApp = v14
	})
end

return InExperienceTransferApp
