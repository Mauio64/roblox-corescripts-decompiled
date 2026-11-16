local function registerAppComponents()
	require("@luauforge/bundled/ils").registerCommonComponents()
	require("@luauforge/bundled/hVn")()
end

return registerAppComponents
