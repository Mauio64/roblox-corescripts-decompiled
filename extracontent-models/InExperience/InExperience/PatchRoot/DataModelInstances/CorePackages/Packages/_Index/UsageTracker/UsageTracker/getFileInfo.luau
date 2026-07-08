local CoreScriptSyncService = game:GetService("CoreScriptSyncService")

local function getFileInfo(s1: string, s2: string?, b1: boolean?) -- line: 4
	-- upvalues: CoreScriptSyncService (copy)
	local _game = game

	for _, v8 in string.split(s1, ".") do
		if _game == nil then
			break
		end

		_game = _game:FindFirstChild(v8)
	end

	if typeof(_game) ~= "Instance" or not _game:IsA("ModuleScript") then
		warn("path led to non-ModuleScript:", s1, _game.ClassName)
		_game = nil
	end

	local ScriptFilePath = nil

	if _game then
		ScriptFilePath = CoreScriptSyncService:GetScriptFilePath(_game)

		if s2 then
			local start, stop = string.find(ScriptFilePath, s2, 1, true)

			if start then
				ScriptFilePath = string.sub(ScriptFilePath, if not b1 then stop + 1 else start)
			end
		end
	end

	return _game, ScriptFilePath
end

return getFileInfo
