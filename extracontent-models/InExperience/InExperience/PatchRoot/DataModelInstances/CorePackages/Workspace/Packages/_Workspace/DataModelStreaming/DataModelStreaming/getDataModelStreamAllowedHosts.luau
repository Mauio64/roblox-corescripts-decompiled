game:DefineFastFlag("LuaAppEnableDataModelStreamForConsoles", false)

local function getDataModelStreamAllowedHosts() -- line: 3
	local t1 = {
		"ws://localhost:5051",
		"ws://10.0.2.2:5051"
	}

	if game:GetFastFlag("LuaAppEnableDataModelStreamForConsoles") then
		table.insert(t1, "ws://10.110.101.185:5051")
	end

	return t1
end

return getDataModelStreamAllowedHosts
