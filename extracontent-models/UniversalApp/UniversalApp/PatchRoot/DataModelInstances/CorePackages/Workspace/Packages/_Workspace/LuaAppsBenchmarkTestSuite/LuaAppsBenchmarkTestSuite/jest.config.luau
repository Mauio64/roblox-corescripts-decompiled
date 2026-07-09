local ParentParent = script.Parent.Parent

local function getBenchmarkProject(p1, s1: string) -- line: 4
	local ok, result = pcall(require, p1)

	if not ok then
		error(`Failed to load benchmark package "{ s1 }": { result }\n` .. `Expected { s1 } to export ["jest.bench.config"] from src/init.lua ` .. "and ensure rotriever.toml does not exclude jest.bench.config.lua.")
	end

	if type(result) ~= "table" then
		error(`Benchmark package "{ s1 }" returned { type(result) } instead of an exports table.`)
	end

	local v7 = result["jest.bench.config"]

	if typeof(v7) ~= "Instance" or not v7:IsA("ModuleScript") then
		error(`Benchmark package "{ s1 }" is missing an exported ["jest.bench.config"] ModuleScript. ` .. "Export it from src/init.lua and ensure rotriever.toml does not exclude jest.bench.config.lua.")
	end

	return v7
end

return {
	displayName = "LuaAppsBenchmarks",
	testTimeout = 30000,
	projects = {
		getBenchmarkProject(ParentParent.AppChat, "AppChat"),
		(getBenchmarkProject(ParentParent.ExpChat, "ExpChat"))
	}
}
