local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/RobloxAppEnums").AppPage
local navigateDown = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/NavigationRodux").Thunks.NavigateDown
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/RobloxAppNavigation").NavigationCommands else nil

local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiCoreSystem")

local sduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local sduiActionType = SduiCoreSystem.SduiActionType

return function(p2, p3, p4, p5)
	local actionParams = p2 and p2.actionParams or nil

	if actionParams == nil then
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{ name = sduiActionType.OpenProfile, message = "Missing actionParams" },
			p4.appPage
		)
		return
	end

	assert(actionParams, "actionParams must exist")
	local profileId = actionParams.profileId

	if profileId == nil then
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = sduiActionType.OpenProfile,
				message = "Missing actionParam: profileId",
				propName = "profileId"
			},
			p4.appPage
		)
		return
	end

	local profileType = actionParams.profileType

	if profileType == nil then
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = sduiActionType.OpenProfile,
				message = "Missing actionParam: profileType",
				propName = "profileType"
			},
			p4.appPage
		)
		return
	end

	local v5 = profileType == "Group" and "Community" or profileType

	local v6 = {
		name = appPage.ProfilePlatform,
		detail = profileId,
		extraProps = { profileType = v5, source = actionParams.source }
	}

	if fFlagSignalsNavP3Dispatch then
		navigationCommands.down(navigationCommands.fromLegacyPage(v6))
	else
		p4.dependencies.dispatch(navigateDown(v6))
	end
end
