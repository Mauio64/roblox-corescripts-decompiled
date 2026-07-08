local CorePackages = game:GetService("CorePackages")
local VRService = game:GetService("VRService")
local GuiService = game:GetService("GuiService")
local Rodux = require(CorePackages.Packages.Rodux)
local Cryo = require(CorePackages.Packages.Cryo)
local PlayerList = require(CorePackages.Workspace.Packages.PlayerList)
local ParentParent = script.Parent.Parent
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
local FFlagPlayerListPersistVisibility = require(ParentParent.Flags.FFlagPlayerListPersistVisibility)
local FFlagAddNewPlayerListMobileFocusNav = PlayerList.Flags.FFlagAddNewPlayerListMobileFocusNav
local FFlagPlayerListUseMobileOnSmallDisplay = PlayerList.Flags.FFlagPlayerListUseMobileOnSmallDisplay
local v23 = if not FFlagPlayerListPersistVisibility then nil else UserSettings().GameSettings
local t1 = {
	isMinimized = false,
	isVisible = true,
	isSmallTouchDevice = false,
	performanceStatsVisible = false,
	playerlistCoreGuiEnabled = true,
	isTenFootInterface = false,
	isUsingGamepad = false,
	hasPermissionToVoiceChat = false,
	subjectToChinaPolicies = true,
	setVisible = not FFlagPlayerListUseMobileOnSmallDisplay and (not FFlagPlayerListPersistVisibility or v23.PlayerListVisible),
	vrEnabled = VRService.VREnabled,
	inspectMenuEnabled = GuiService:GetInspectMenuEnabled(),
	tempHideKeys = {}
}

local function updateIsVisible(p1) -- line: 48
	-- upvalues: Cryo (copy)
	p1.isVisible = p1.setVisible

	if not p1.isTenFootInterface then
		p1.isVisible = p1.isVisible
	end

	p1.isVisible = p1.isVisible and Cryo.isEmpty(p1.tempHideKeys)

	return p1
end

return (Rodux.createReducer(t1, {
	[SetPlayerListVisibility.name] = function(p2, p3) -- line: 61
		-- upvalues: FFlagPlayerListPersistVisibility (copy), v23 (copy), Cryo (copy)
		if FFlagPlayerListPersistVisibility and (not p2.isSmallTouchDevice and not p2.isTenFootInterface) then
			v23.PlayerListVisible = p3.isVisible
		end

		local v29 = Cryo.Dictionary.join(p2, {
			setVisible = p3.isVisible
		})

		v29.isVisible = v29.setVisible

		if not v29.isTenFootInterface then
			v29.isVisible = v29.isVisible
		end

		v29.isVisible = v29.isVisible and Cryo.isEmpty(v29.tempHideKeys)

		return v29
	end,
	[SetPlayerListEnabled.name] = function(p4, p5) -- line: 73
		-- upvalues: FFlagAddNewPlayerListMobileFocusNav (copy), Cryo (copy)
		local v32 = nil

		if FFlagAddNewPlayerListMobileFocusNav and not p5.isEnabled then
			v32 = false
		end

		local v33 = Cryo.Dictionary.join(p4, {
			playerlistCoreGuiEnabled = p5.isEnabled,
			setVisible = if not FFlagAddNewPlayerListMobileFocusNav then nil else v32
		})

		v33.isVisible = v33.setVisible

		if not v33.isTenFootInterface then
			v33.isVisible = v33.isVisible
		end

		v33.isVisible = v33.isVisible and Cryo.isEmpty(v33.tempHideKeys)

		return v33
	end,
	[SetTempHideKey.name] = function(p6, p7) -- line: 87
		-- upvalues: Cryo (copy)
		local tempHideValue = p7.tempHideValue

		if tempHideValue == nil then
			tempHideValue = Cryo.None
		end

		local v37 = Cryo.Dictionary.join(p6, {
			tempHideKeys = Cryo.Dictionary.join(p6.tempHideKeys, {
				[p7.tempHideKey] = tempHideValue
			})
		})

		v37.isVisible = v37.setVisible

		if not v37.isTenFootInterface then
			v37.isVisible = v37.isVisible
		end

		v37.isVisible = v37.isVisible and Cryo.isEmpty(v37.tempHideKeys)

		return v37
	end,
	[SetPerformanceStatsVisible.name] = function(p8, p9) -- line: 99
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p8, {
			performanceStatsVisible = p9.isVisible
		})
	end,
	[SetSmallTouchDevice.name] = function(p10, p11) -- line: 105
		-- upvalues: Cryo (copy)
		local v42 = Cryo.Dictionary.join(p10, {
			isSmallTouchDevice = p11.isSmallTouchDevice
		})

		v42.isVisible = v42.setVisible

		if not v42.isTenFootInterface then
			v42.isVisible = v42.isVisible
		end

		v42.isVisible = v42.isVisible and Cryo.isEmpty(v42.tempHideKeys)

		return v42
	end,
	[SetTenFootInterface.name] = function(p12, p13) -- line: 111
		-- upvalues: Cryo (copy)
		local setVisible = p12.setVisible

		if p13.isTenFootInterface then
			setVisible = false
		end

		local v46 = Cryo.Dictionary.join(p12, {
			isTenFootInterface = p13.isTenFootInterface,
			setVisible = setVisible
		})

		v46.isVisible = v46.setVisible

		if not v46.isTenFootInterface then
			v46.isVisible = v46.isVisible
		end

		v46.isVisible = v46.isVisible and Cryo.isEmpty(v46.tempHideKeys)

		return v46
	end,
	[SetInspectMenuEnabled.name] = function(p14, p15) -- line: 122
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p14, {
			inspectMenuEnabled = p15.enabled
		})
	end,
	[SetIsUsingGamepad.name] = function(p16, p17) -- line: 128
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p16, {
			isUsingGamepad = p17.isUsingGamepad
		})
	end,
	[SetHasPermissionToVoiceChat.name] = function(p18, p19) -- line: 134
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p18, {
			hasPermissionToVoiceChat = p19.hasPermissionToVoiceChat
		})
	end,
	[SetMinimized.name] = function(p20, p21) -- line: 140
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p20, {
			isMinimized = p21.isMinimized
		})
	end,
	[SetSubjectToChinaPolicies.name] = function(p22, p23) -- line: 146
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p22, {
			subjectToChinaPolicies = p23.subjectToChinaPolicies
		})
	end
}))
