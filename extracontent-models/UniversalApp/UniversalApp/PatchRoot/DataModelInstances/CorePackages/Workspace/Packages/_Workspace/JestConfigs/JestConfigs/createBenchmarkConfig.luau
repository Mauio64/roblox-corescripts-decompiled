local setupFiles = require(script.Parent.setupFiles)
local v2 = table.freeze({
	testTimeout = 30000,
	testMatch = table.freeze({ "**/*.bench" }),
	setupFilesAfterEnv = table.freeze({
		setupFiles.UIBloxInitializer,
		setupFiles.createPromiseRejectionHandler()
	})
})

local function createBenchmarkConfig(s1: string, t1: {[any]: any}?) -- line: 12
	-- upvalues: v2 (copy)
	assert(type(s1) == "string" and #s1 > 0, "displayName is required")

	local t2 = {
		displayName = s1
	}

	for v7, v8 in v2 do
		t2[v7] = if type(v8) ~= "table" then v8 else table.clone(v8)
	end

	if t1 then
		for v9, v10 in t1 do
			t2[v9] = v10
		end
	end

	return t2
end

return createBenchmarkConfig
