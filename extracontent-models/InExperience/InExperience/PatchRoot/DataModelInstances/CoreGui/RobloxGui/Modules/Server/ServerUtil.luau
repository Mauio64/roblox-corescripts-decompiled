local v1 = game:DefineFastFlag("ServerCoreScriptSourceCode", false)
local t1 = {
	getFFlagServerCoreScriptSourceCode = function() -- line: 6
		-- upvalues: v1 (copy)
		return v1
	end
}

if v1 then
	local InsertService = game:GetService("InsertService")
	local Modules = game:GetService("CoreGui"):WaitForChild("RobloxGui", 1e999).Modules

	local function getRelativePathArray(p1, p2) -- line: 15
		local t2 = {}

		while p2 ~= p1 do
			if p2 == nil then
				return nil
			end

			table.insert(t2, 1, p2.Name)
			p2 = p2.Parent
		end

		return t2
	end

	function t1.getSourceForServerScript(p3) -- line: 27
		-- upvalues: Modules (copy), getRelativePathArray (copy)
		if p3.Source ~= "" then
			return p3.Source
		end

		local v11 = Modules
		local SourceCode = Modules.SourceCode
		local v13 = getRelativePathArray(v11, p3)

		if v13 == nil then
			error("Instance is not a descendant of the byte code root")
		end

		for i = 1, #v13 do
			SourceCode = SourceCode:FindFirstChild(v13[i])
		end

		if SourceCode == nil then
			error("No source found for instance")
		end

		return SourceCode.Source
	end

	local function isByteCodeMode() -- line: 52
		return script.Source == ""
	end

	function t1.initSourceCodeFolder() -- line: 56
		-- upvalues: InsertService (copy), Modules (copy)
		if script.Source ~= "" then
			return
		end

		local v15 = InsertService:LoadLocalAsset("rbxasset://models/ServerCoreScripts.rbxm")
		local Folder = Instance.new("Folder")

		Folder.Name = "SourceCode"
		Folder.Parent = Modules

		local Server = v15.Server
		local Common = v15.Common

		Server.Parent = Folder
		Common.Parent = Folder
	end
end

return t1
