local Parent = script:FindFirstAncestor("ServerDrivenUi").Parent
local CentralOverlayType = require(Parent.RobloxAppEnums).CentralOverlayType
local SetCentralOverlay = require(Parent.CentralOverlay).Actions.SetCentralOverlay
local SduiCoreSystem = require(Parent.SduiCoreSystem)
local SduiActionType = SduiCoreSystem.SduiActionType
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType

return function(p1, _, p3, p4) -- line: 15
	-- upvalues: SduiErrorType (copy), SduiActionType (copy), SetCentralOverlay (copy), CentralOverlayType (copy)
	local v11 = p1 and p1.actionParams or nil

	if v11 == nil then
		p3.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
			message = "Missing actionParams",
			name = SduiActionType.OpenJoinFriends
		}, p3.appPage)

		return
	end

	assert(v11, "actionParams must exist")

	local placeId = v11.placeId

	if placeId == nil then
		p3.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
			propName = "placeId",
			name = SduiActionType.OpenJoinFriends,
			message = `Missing placeId: { placeId }`
		}, p3.appPage)

		return
	end

	local universeId = v11.universeId

	if universeId == nil then
		p3.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
			propName = "universeId",
			name = SduiActionType.OpenJoinFriends,
			message = `Missing universeId: { universeId }`
		}, p3.appPage)

		return
	end

	if p4 then
		local AbsoluteSize = p4.AbsoluteSize
		local AbsolutePosition = p4.AbsolutePosition
		local t1 = {
			placeId = tostring(placeId),
			universeId = tostring(universeId)
		}

		p3.dependencies.dispatch(SetCentralOverlay(CentralOverlayType.PlacesList, {
			game = t1,
			anchorSpaceSize = AbsoluteSize,
			anchorSpacePosition = AbsolutePosition
		}))

		return
	end

	p3.dependencies.logger.reportError(SduiErrorType.FailedToExecuteAction, {
		message = "Failed to execute -- missing guiObject anchor",
		name = SduiActionType.OpenJoinFriends
	}, p3.appPage)
end
