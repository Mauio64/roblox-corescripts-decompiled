local function registerAppComponents()
	require("@luauforge/bundled/isP").registerCommonComponents()
	require("@luauforge/bundled/ifk")()
end

return registerAppComponents
