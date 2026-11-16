local parent = script:FindFirstAncestor("ServerDrivenUi").Parent
local RobloxAppEnums = require(parent.RobloxAppEnums)
local CentralOverlayType = RobloxAppEnums.CentralOverlayType
local CentralOverlay = require(parent.CentralOverlay)
local SetCentralOverlay = CentralOverlay.Actions.SetCentralOverlay

local SduiCoreSystem = require(parent.SduiCoreSystem)
local SduiActionType = SduiCoreSystem.SduiActionType
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType

return function(p, _, p2, p3)
	local actionParams = p and p.actionParams or nil

	if actionParams == nil then
		p2.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{ name = SduiActionType.OpenJoinFriends, message = "Missing actionParams" },
			p2.appPage
		)
		return
	end

	assert(actionParams, "actionParams must exist")
	local placeId = actionParams.placeId

	if placeId == nil then
		p2.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{
				name = SduiActionType.OpenJoinFriends,
				message = `Missing placeId: {nil}`,
				propName = "placeId"
			},
			p2.appPage
		)
		return
	end

	local universeId = actionParams.universeId

	if universeId == nil then
		p2.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{
				name = SduiActionType.OpenJoinFriends,
				message = `Missing universeId: {nil}`,
				propName = "universeId"
			},
			p2.appPage
		)
		return
	end

	if not p3 then
		p2.dependencies.logger.reportError(
			SduiErrorType.FailedToExecuteAction,
			{
				name = SduiActionType.OpenJoinFriends,
				message = "Failed to execute -- missing guiObject anchor"
			},
			p2.appPage
		)

		return
	end

	local absoluteSize = p3.AbsoluteSize
	local absolutePosition = p3.AbsolutePosition
	local Game = { placeId = tostring(placeId), universeId = tostring(universeId) }

	p2.dependencies.dispatch(SetCentralOverlay(CentralOverlayType.PlacesList, {
		game = Game,
		anchorSpaceSize = absoluteSize,
		anchorSpacePosition = absolutePosition
	}))
end
