local centralOverlayType = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/RobloxAppEnums").CentralOverlayType
local setCentralOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/CentralOverlay").Actions.SetCentralOverlay

local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiCoreSystem")
local sduiActionType = SduiCoreSystem.SduiActionType
local sduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType

return function(p2, p3, p4, p5)
	local actionParams = p2 and p2.actionParams or nil

	if actionParams == nil then
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{ name = sduiActionType.OpenJoinFriends, message = "Missing actionParams" },
			p4.appPage
		)
		return
	end

	assert(actionParams, "actionParams must exist")
	local placeId = actionParams.placeId

	if placeId == nil then
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = sduiActionType.OpenJoinFriends,
				message = `Missing placeId: {nil}`,
				propName = "placeId"
			},
			p4.appPage
		)
		return
	end

	local universeId = actionParams.universeId

	if universeId == nil then
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = sduiActionType.OpenJoinFriends,
				message = `Missing universeId: {nil}`,
				propName = "universeId"
			},
			p4.appPage
		)
		return
	end

	if not p5 then
		p4.dependencies.logger.reportError(
			sduiErrorType.FailedToExecuteAction,
			{
				name = sduiActionType.OpenJoinFriends,
				message = "Failed to execute -- missing guiObject anchor"
			},
			p4.appPage
		)

		return
	end

	local absoluteSize = p5.AbsoluteSize
	local absolutePosition = p5.AbsolutePosition
	local v5 = { placeId = tostring(placeId), universeId = tostring(universeId) }

	p4.dependencies.dispatch(setCentralOverlay(centralOverlayType.PlacesList, {
		game = v5,
		anchorSpaceSize = absoluteSize,
		anchorSpacePosition = absolutePosition
	}))
end
