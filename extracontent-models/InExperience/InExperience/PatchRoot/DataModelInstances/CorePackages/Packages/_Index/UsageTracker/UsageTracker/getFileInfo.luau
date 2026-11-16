local CoreScriptSyncService = game:GetService("CoreScriptSyncService")

local function getFileInfo(value: string, p: string?, flag: boolean?)
	local game = game

	for _, childName in string.split(value, ".") do
		if game == nil then
			break
		end

		game = game:FindFirstChild(childName)
	end

	if typeof(game) ~= "Instance" or not game:IsA("ModuleScript") then
		warn("path led to non-ModuleScript:", value, game.ClassName)
		game = nil
	end

	local scriptFilePath

	if not game then
		return game, scriptFilePath
	end

	scriptFilePath = CoreScriptSyncService:GetScriptFilePath(game)

	if p then
		local v, v2 = string.find(scriptFilePath, p, 1, true)

		if v then
			if not flag then
				v = v2 + 1
			end

			scriptFilePath = string.sub(scriptFilePath, v)
		end
	end

	return game, scriptFilePath
end

return getFileInfo
