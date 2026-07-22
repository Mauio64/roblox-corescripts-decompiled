local Parent = script:FindFirstAncestor("ServerDrivenUi").Parent
local SduiCoreSystem = require(Parent.SduiCoreSystem)
local SduiActionType = SduiCoreSystem.SduiActionType
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local PinExperienceShortcut = SduiActionType.PinExperienceShortcut

local function isPinShortcutServiceEnabled() -- line: 16
	return game:GetEngineFeature("PinShortcutServiceEnabled")
end
local function SduiPinShortcutAction(p1, _, p3, _) -- line: 20
	-- upvalues: SduiErrorType (copy), PinExperienceShortcut (copy)
	local v12 = if not p1 then nil else p1.actionParams

	if v12 == nil then
		p3.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
			message = "Missing actionParams",
			name = PinExperienceShortcut
		}, p3.appPage)

		return
	end

	local num = tonumber(v12.placeId)

	if num == nil then
		p3.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
			message = "Missing placeId",
			propName = "placeId",
			name = PinExperienceShortcut
		}, p3.appPage)

		return
	end

	local v14 = tonumber(v12.universeId) or 0
	local v15 = v12.gameName or ""

	if not game:GetEngineFeature("PinShortcutServiceEnabled") then
		return
	end

	task.spawn(function() -- line: 57
		-- upvalues: p3 (copy), SduiErrorType (copy), PinExperienceShortcut (copy), num (copy), v14 (copy), v15 (copy)
		local ok, result = pcall(game.GetService, game, "PinShortcutService")

		if not ok or result == nil then
			p3.dependencies.logger.reportError(SduiErrorType.FailedToExecuteAction, {
				message = "PinShortcutService unavailable",
				name = PinExperienceShortcut
			}, p3.appPage)

			return
		end

		local ok2, result2 = pcall(function() -- line: 66
			-- upvalues: result (copy), num (copy), v14 (copy), v15 (copy)
			result:PinExperience(num, v14, v15)
		end)

		if not ok2 then
			p3.dependencies.logger.reportError(SduiErrorType.FailedToExecuteAction, {
				name = PinExperienceShortcut,
				message = tostring(result2)
			}, p3.appPage)
		end
	end)
end

return SduiPinShortcutAction
