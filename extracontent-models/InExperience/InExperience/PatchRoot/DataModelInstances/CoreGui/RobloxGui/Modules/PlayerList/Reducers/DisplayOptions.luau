local CorePackages = game:GetService("CorePackages")
local VRService = game:GetService("VRService")
local GuiService = game:GetService("GuiService")

local Rodux = require(CorePackages.Packages.Rodux)
local Cryo = require(CorePackages.Packages.Cryo)

local PlayerList = require(CorePackages.Workspace.Packages.PlayerList)

local parent = script.Parent.Parent

local Actions = script.Parent.Parent.Actions
local SetPlayerListVisibility = require(Actions.SetPlayerListVisibility)
local SetPlayerListEnabled = require(Actions.SetPlayerListEnabled)
local SetTempHideKey = require(Actions.SetTempHideKey)
local SetPerformanceStatsVisible = require(Actions.SetPerformanceStatsVisible)
local SetSmallTouchDevice = require(Actions.SetSmallTouchDevice)
local SetTenFootInterface = require(Actions.SetTenFootInterface)
local SetInspectMenuEnabled = require(Actions.SetInspectMenuEnabled)
local SetIsUsingGamepad = require(Actions.SetIsUsingGamepad)
local SetHasPermissionToVoiceChat = require(Actions.SetHasPermissionToVoiceChat)
local SetMinimized = require(Actions.SetMinimized)
local SetSubjectToChinaPolicies = require(Actions.SetSubjectToChinaPolicies)

local FFlagPlayerListPersistVisibility = require(parent.Flags.FFlagPlayerListPersistVisibility)
local FFlagAddNewPlayerListMobileFocusNav = PlayerList.Flags.FFlagAddNewPlayerListMobileFocusNav
local FFlagPlayerListUseMobileOnSmallDisplay = PlayerList.Flags.FFlagPlayerListUseMobileOnSmallDisplay
local gameSettings

if FFlagPlayerListPersistVisibility then
	gameSettings = UserSettings().GameSettings
else
	gameSettings = nil
end

local v = {
	isMinimized = false,
	setVisible = not FFlagPlayerListUseMobileOnSmallDisplay and (not FFlagPlayerListPersistVisibility or gameSettings.PlayerListVisible),
	isVisible = true,
	isSmallTouchDevice = false,
	performanceStatsVisible = false,
	vrEnabled = VRService.VREnabled,
	inspectMenuEnabled = GuiService:GetInspectMenuEnabled(),
	playerlistCoreGuiEnabled = true,
	isTenFootInterface = false,
	isUsingGamepad = false,
	hasPermissionToVoiceChat = false,
	tempHideKeys = {},
	subjectToChinaPolicies = true
}

local function updateIsVisible(state) -- 5 equivalent calls inferred from this helper
	state.isVisible = state.setVisible

	if not state.isTenFootInterface then
		state.isVisible = state.isVisible
	end

	state.isVisible = state.isVisible and Cryo.isEmpty(state.tempHideKeys)
	return state
end

return (Rodux.createReducer(v, {
	[SetPlayerListVisibility.name] = function(p, p2)
		if FFlagPlayerListPersistVisibility and not (p.isSmallTouchDevice or p.isTenFootInterface) then
			gameSettings.PlayerListVisible = p2.isVisible
		end

		return updateIsVisible(Cryo.Dictionary.join(p, { setVisible = p2.isVisible })) -- inferred equivalent call
	end,
	[SetPlayerListEnabled.name] = function(p, p2)
		local setVisible

		if FFlagAddNewPlayerListMobileFocusNav and not p2.isEnabled then
			setVisible = false
		end

		local join = Cryo.Dictionary.join
		local v2 = { playerlistCoreGuiEnabled = p2.isEnabled, setVisible = 0 }

		if not FFlagAddNewPlayerListMobileFocusNav then
			setVisible = nil
		end

		v2.setVisible = setVisible
		return updateIsVisible(join(p, v2)) -- inferred equivalent call
	end,
	[SetTempHideKey.name] = function(p, p2)
		local v2 = p2.tempHideValue

		if v2 == nil then
			v2 = Cryo.None
		end

		return updateIsVisible(Cryo.Dictionary.join(p, { -- inferred equivalent call
			tempHideKeys = Cryo.Dictionary.join(p.tempHideKeys, { [p2.tempHideKey] = v2 })
		}))
	end,
	[SetPerformanceStatsVisible.name] = function(p, p2)
		return Cryo.Dictionary.join(p, { performanceStatsVisible = p2.isVisible })
	end,
	[SetSmallTouchDevice.name] = function(p, p2)
		return updateIsVisible(Cryo.Dictionary.join(p, { -- inferred equivalent call
			isSmallTouchDevice = p2.isSmallTouchDevice
		}))
	end,
	[SetTenFootInterface.name] = function(p, p2)
		local setVisible = p.setVisible

		if p2.isTenFootInterface then
			setVisible = false
		end

		return updateIsVisible(Cryo.Dictionary.join(p, { -- inferred equivalent call
			isTenFootInterface = p2.isTenFootInterface,
			setVisible = setVisible
		}))
	end,
	[SetInspectMenuEnabled.name] = function(p, p2)
		return Cryo.Dictionary.join(p, { inspectMenuEnabled = p2.enabled })
	end,
	[SetIsUsingGamepad.name] = function(p, p2)
		return Cryo.Dictionary.join(p, { isUsingGamepad = p2.isUsingGamepad })
	end,
	[SetHasPermissionToVoiceChat.name] = function(p, p2)
		return Cryo.Dictionary.join(p, { hasPermissionToVoiceChat = p2.hasPermissionToVoiceChat })
	end,
	[SetMinimized.name] = function(p, p2)
		return Cryo.Dictionary.join(p, { isMinimized = p2.isMinimized })
	end,
	[SetSubjectToChinaPolicies.name] = function(p, p2)
		return Cryo.Dictionary.join(p, { subjectToChinaPolicies = p2.subjectToChinaPolicies })
	end
}))
