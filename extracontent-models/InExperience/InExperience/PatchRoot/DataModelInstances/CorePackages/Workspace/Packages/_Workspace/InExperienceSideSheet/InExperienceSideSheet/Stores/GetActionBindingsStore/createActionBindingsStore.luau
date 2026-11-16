local ContextActionService = game:GetService("ContextActionService")

local InExperienceSideSheet = script:FindFirstAncestor("InExperienceSideSheet")
local parent = InExperienceSideSheet.Parent

local Signals = require(parent.Signals)

local AnalyticsConstants = require(InExperienceSideSheet.Analytics.AnalyticsConstants)
local SidesheetAnalytics = require(InExperienceSideSheet.Analytics.SidesheetAnalytics)

local Enums = require(InExperienceSideSheet.Common.Enums)

local GetIntegrationsStore = require(InExperienceSideSheet.Stores.GetIntegrationsStore)

local closePeoplePageOpenedWithSideSheet = require(InExperienceSideSheet.Utils.closePeoplePageOpenedWithSideSheet)
local getSideSheetVisibility = require(InExperienceSideSheet.Utils.getSideSheetVisibility)
local toggleSideSheet = require(InExperienceSideSheet.Utils.toggleSideSheet)

local Flags = require(InExperienceSideSheet.Flags)
local SharedFlags = require(parent.SharedFlags)
local FFlagSideSheetOpenPeoplePage = Flags.FFlagSideSheetOpenPeoplePage
local FFlagShowSwitchServerButton = SharedFlags.FFlagShowSwitchServerButton
local PioneerUtils = require(parent.PioneerUtils)
local isPioneerLaunch = PioneerUtils.isPioneerLaunch

local function createActionBinding(keyCodes)
	local signal, setIsEnabled = Signals.createSignal(true)
	local signal2, setOnActivated = Signals.createSignal(function()
		return function() end
	end)

	return {
		keyCodes = keyCodes,
		getOnActivated = signal2,
		setOnActivated = setOnActivated,
		getIsEnabled = signal,
		setIsEnabled = setIsEnabled
	}
end

local function createActionBindingsStore()
	local sessionActionBindings = {
		[Enums.ActionBinding.Leave] = createActionBinding({ Enum.KeyCode.L, Enum.KeyCode.ButtonX }),
		[Enums.ActionBinding.Respawn] = createActionBinding({ Enum.KeyCode.R, Enum.KeyCode.ButtonY })
	}

	if FFlagShowSwitchServerButton or isPioneerLaunch() then
		sessionActionBindings[Enums.ActionBinding.SwitchServer] = createActionBinding(nil)
	end

	local effect = Signals.createEffect(function(p)
		local sessionActionIntegrations = GetIntegrationsStore(p).getSessionActionIntegrations(p)

		for _, sessionActionIntegration in sessionActionIntegrations do
			local v = sessionActionBindings[sessionActionIntegration.id]

			if v then
				v.setOnActivated(function()
					return function()
						sessionActionIntegration.activated()

						if FFlagSideSheetOpenPeoplePage then
							closePeoplePageOpenedWithSideSheet()
						end

						toggleSideSheet(false)
						SidesheetAnalytics.logSidesheetClosed(AnalyticsConstants.Source.ItemSelected)
					end
				end)
			end
		end
	end)

	local effect2 = Signals.createEffect(function(p)
		if getSideSheetVisibility(p) then
			for k, v in sessionActionBindings do
				if not (not (isPioneerLaunch() or FFlagShowSwitchServerButton) or v.keyCodes ~= nil) then
					continue
				end

				local function fn(_, p2, _)
					if p2 == Enum.UserInputState.Begin then
						v.getOnActivated()()
					end
				end

				if v.getIsEnabled(p) then
					ContextActionService:BindCoreAction(k, fn, false, unpack(v.keyCodes))
				else
					ContextActionService:UnbindCoreAction(k)
				end
			end
		else
			for k in sessionActionBindings do
				ContextActionService:UnbindCoreAction(k)
			end
		end
	end)

	return {
		sessionActionBindings = sessionActionBindings,
		cleanUp = function()
			effect2()
			effect()
		end
	}
end

return createActionBindingsStore
