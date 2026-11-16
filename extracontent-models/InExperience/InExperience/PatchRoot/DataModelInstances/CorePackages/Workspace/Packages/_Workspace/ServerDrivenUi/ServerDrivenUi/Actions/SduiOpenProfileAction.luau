local parent = script:FindFirstAncestor("ServerDrivenUi").Parent
local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local NavigationRodux = require(parent.NavigationRodux)
local NavigateDown = NavigationRodux.Thunks.NavigateDown
local SharedFlags = require(parent.SharedFlags)
local FFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local navigationCommands

if FFlagSignalsNavP3Dispatch then
	local RobloxAppNavigation = require(parent.RobloxAppNavigation)
	navigationCommands = RobloxAppNavigation.NavigationCommands
else
	navigationCommands = nil
end

local SduiCoreSystem = require(parent.SduiCoreSystem)

local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local SduiActionType = SduiCoreSystem.SduiActionType

return function(p, _, p2, _)
	local actionParams = p and p.actionParams or nil

	if actionParams == nil then
		p2.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{ name = SduiActionType.OpenProfile, message = "Missing actionParams" },
			p2.appPage
		)
		return
	end

	assert(actionParams, "actionParams must exist")
	local profileId = actionParams.profileId

	if profileId == nil then
		p2.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{
				name = SduiActionType.OpenProfile,
				message = "Missing actionParam: profileId",
				propName = "profileId"
			},
			p2.appPage
		)
		return
	end

	local profileType = actionParams.profileType

	if profileType == nil then
		p2.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{
				name = SduiActionType.OpenProfile,
				message = "Missing actionParam: profileType",
				propName = "profileType"
			},
			p2.appPage
		)
		return
	end

	local profileType2 = profileType == "Group" and "Community" or profileType

	local v = {
		name = AppPage.ProfilePlatform,
		detail = profileId,
		extraProps = { profileType = profileType2, source = actionParams.source }
	}

	if FFlagSignalsNavP3Dispatch then
		navigationCommands.down(navigationCommands.fromLegacyPage(v))
	else
		p2.dependencies.dispatch(NavigateDown(v))
	end
end
