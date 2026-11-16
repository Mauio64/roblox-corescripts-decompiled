local fFlagServerCoreScriptSourceCode = game:DefineFastFlag("ServerCoreScriptSourceCode", false)

local ServerUtil = {}

function ServerUtil.getFFlagServerCoreScriptSourceCode()
	return fFlagServerCoreScriptSourceCode
end

if not fFlagServerCoreScriptSourceCode then
	return ServerUtil
end

local InsertService = game:GetService("InsertService")
local CoreGui = game:GetService("CoreGui")
local modules = CoreGui:WaitForChild("RobloxGui", 1e999).Modules

local function getRelativePathArray(modules2, instance)
	local result = {}

	while instance ~= modules2 do
		if instance == nil then
			return nil
		end

		table.insert(result, 1, instance.Name)
		instance = instance.Parent
	end

	return result
end

function ServerUtil.getSourceForServerScript(p)
	if p.Source ~= "" then
		return p.Source
	end

	local sourceCode = modules.SourceCode

	local relativePathArray = getRelativePathArray(modules, p)

	if relativePathArray == nil then
		error("Instance is not a descendant of the byte code root")
	end

	for i = 1, #relativePathArray do
		sourceCode = sourceCode:FindFirstChild(relativePathArray[i])
	end

	if sourceCode == nil then
		error("No source found for instance")
	end

	return sourceCode.Source
end

local function isByteCodeMode(): boolean -- 1 equivalent call inferred from this helper
	return script.Source == ""
end

function ServerUtil.initSourceCodeFolder()
	if not isByteCodeMode() then -- inferred equivalent call
		return
	end

	local localAsset = InsertService:LoadLocalAsset("rbxasset://models/ServerCoreScripts.rbxm")
	local sourceCode = Instance.new("Folder")
	sourceCode.Name = "SourceCode"
	sourceCode.Parent = modules

	local server = localAsset.Server
	local common = localAsset.Common
	server.Parent = sourceCode
	common.Parent = sourceCode
end

return ServerUtil
