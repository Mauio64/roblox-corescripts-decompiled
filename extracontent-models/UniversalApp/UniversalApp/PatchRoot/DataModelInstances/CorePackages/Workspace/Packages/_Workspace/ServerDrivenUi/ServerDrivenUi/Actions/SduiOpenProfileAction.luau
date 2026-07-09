local Parent = script:FindFirstAncestor("ServerDrivenUi").Parent
local AppPage = require(Parent.RobloxAppEnums).AppPage
local NavigateDown = require(Parent.NavigationRodux).Thunks.NavigateDown
local FFlagSignalsNavP3Dispatch = require(Parent.SharedFlags).FFlagSignalsNavP3Dispatch
local v5 = if not FFlagSignalsNavP3Dispatch then nil else require(Parent.RobloxAppNavigation).NavigationCommands
local SduiCoreSystem = require(Parent.SduiCoreSystem)
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local SduiActionType = SduiCoreSystem.SduiActionType

return function(p1, _, p3, _) -- line: 19
	-- upvalues: SduiErrorType (copy), SduiActionType (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v5 (copy), NavigateDown (copy)
	local v13 = p1 and p1.actionParams or nil

	if v13 == nil then
		p3.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
			message = "Missing actionParams",
			name = SduiActionType.OpenProfile
		}, p3.appPage)

		return
	end

	assert(v13, "actionParams must exist")

	local profileId = v13.profileId

	if profileId == nil then
		p3.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
			message = "Missing actionParam: profileId",
			propName = "profileId",
			name = SduiActionType.OpenProfile
		}, p3.appPage)

		return
	end

	local profileType = v13.profileType

	if profileType == nil then
		p3.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
			message = "Missing actionParam: profileType",
			propName = "profileType",
			name = SduiActionType.OpenProfile
		}, p3.appPage)

		return
	end

	local v16 = if profileType ~= "Group" then profileType else "Community"
	local t1 = {
		name = AppPage.ProfilePlatform,
		detail = profileId,
		extraProps = {
			profileType = v16,
			source = v13.source
		}
	}

	if FFlagSignalsNavP3Dispatch then
		v5.down(v5.fromLegacyPage(t1))

		return
	end

	p3.dependencies.dispatch(NavigateDown(t1))
end
