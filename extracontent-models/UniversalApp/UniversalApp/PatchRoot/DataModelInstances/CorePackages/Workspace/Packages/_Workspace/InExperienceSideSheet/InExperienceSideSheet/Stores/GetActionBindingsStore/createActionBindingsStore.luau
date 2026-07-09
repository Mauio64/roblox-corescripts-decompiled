local ContextActionService = game:GetService("ContextActionService")
local InExperienceSideSheet = script:FindFirstAncestor("InExperienceSideSheet")
local InExperienceSideSheetParent = InExperienceSideSheet.Parent
local Signals = require(InExperienceSideSheetParent.Signals)
local AnalyticsConstants = require(InExperienceSideSheet.Analytics.AnalyticsConstants)
local SidesheetAnalytics = require(InExperienceSideSheet.Analytics.SidesheetAnalytics)
local Enums = require(InExperienceSideSheet.Common.Enums)
local GetIntegrationsStore = require(InExperienceSideSheet.Stores.GetIntegrationsStore)
local getSideSheetVisibility = require(InExperienceSideSheet.Utils.getSideSheetVisibility)
local toggleSideSheet = require(InExperienceSideSheet.Utils.toggleSideSheet)

local function createActionBinding(t1: {[any]: any}) -- line: 31
	-- upvalues: Signals (copy)
	local v14, v15 = Signals.createSignal(true)
	local v16, v17 = Signals.createSignal(function() -- line: 33
		return function() -- line: 34
		end
	end)

	return {
		keyCodes = t1,
		getOnActivated = v16,
		setOnActivated = v17,
		getIsEnabled = v14,
		setIsEnabled = v15
	}
end
local function createActionBindingsStore() -- line: 46
	-- upvalues: Enums (copy), createActionBinding (copy), Signals (copy), GetIntegrationsStore (copy), toggleSideSheet (copy), SidesheetAnalytics (copy), AnalyticsConstants (copy), getSideSheetVisibility (copy), ContextActionService (copy)
	local t2 = {
		[Enums.ActionBinding.Leave] = createActionBinding({
			Enum.KeyCode.L,
			Enum.KeyCode.ButtonX
		}),
		[Enums.ActionBinding.Respawn] = createActionBinding({
			Enum.KeyCode.R,
			Enum.KeyCode.ButtonY
		})
	}
	local v19 = Signals.createEffect(function(p1) -- line: 53
		-- upvalues: GetIntegrationsStore (copy), t2 (copy), toggleSideSheet (copy), SidesheetAnalytics (copy), AnalyticsConstants (copy)
		for _, v23 in (GetIntegrationsStore(p1).getSessionActionIntegrations(p1)) do
			local v24 = t2[v23.id]

			if v24 then
				v24.setOnActivated(function() -- line: 61
					-- upvalues: v23 (copy), toggleSideSheet (copy), SidesheetAnalytics (copy), AnalyticsConstants (copy)
					return function() -- line: 62
						-- upvalues: v23 (copy), toggleSideSheet (copy), SidesheetAnalytics (copy), AnalyticsConstants (copy)
						v23.activated()
						toggleSideSheet(false)
						SidesheetAnalytics.logSidesheetClosed(AnalyticsConstants.Source.ItemSelected)
					end
				end)
			end
		end
	end)
	local v20 = Signals.createEffect(function(p2) -- line: 73
		-- upvalues: getSideSheetVisibility (copy), t2 (copy), ContextActionService (copy)
		if getSideSheetVisibility(p2) then
			for v26, v27 in t2 do
				if v27.getIsEnabled(p2) then
					ContextActionService:BindCoreAction(v26, function(_, p4, _) -- line: 76
						-- upvalues: v27 (copy)
						if p4 == Enum.UserInputState.Begin then
							v27.getOnActivated()()
						end
					end, false, unpack(v27.keyCodes))
				else
					ContextActionService:UnbindCoreAction(v26)
				end
			end

			return
		end

		for v28 in t2 do
			ContextActionService:UnbindCoreAction(v28)
		end
	end)

	return {
		sessionActionBindings = t2,
		cleanUp = function() -- line: 96
			-- upvalues: v20 (copy), v19 (copy)
			v20()
			v19()
		end
	}
end

return createActionBindingsStore
