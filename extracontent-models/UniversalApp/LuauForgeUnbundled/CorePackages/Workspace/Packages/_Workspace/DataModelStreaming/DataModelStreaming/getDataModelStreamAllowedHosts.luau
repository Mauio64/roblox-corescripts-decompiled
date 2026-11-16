game:DefineFastFlag("LuaAppEnableDataModelStreamForConsoles", false)

local function getDataModelStreamAllowedHosts()
	local dataModelStreamAllowedHosts = { "ws://localhost:5051", "ws://10.0.2.2:5051" }

	if game:GetFastFlag("LuaAppEnableDataModelStreamForConsoles") then
		table.insert(dataModelStreamAllowedHosts, "ws://10.110.101.185:5051")
	end

	return dataModelStreamAllowedHosts
end

return getDataModelStreamAllowedHosts
