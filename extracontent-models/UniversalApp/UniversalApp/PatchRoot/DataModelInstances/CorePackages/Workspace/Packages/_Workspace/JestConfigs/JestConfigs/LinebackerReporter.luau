local function getDataModelService(s1: string) -- line: 4
	local ok, result = pcall(function() -- line: 5
		-- upvalues: s1 (copy)
		local s1_2 = game:GetService(s1)
		local _ = s1_2.Name

		return s1_2
	end)

	return ok and result or nil
end

local s2 = "FileSystemService"
local ok, result = pcall(function() -- line: 5
	-- upvalues: s2 (copy)
	local s2_2 = game:GetService(s2)
	local _ = s2_2.Name

	return s2_2
end)
local u5 = ok and result or nil
local s3 = "HttpService"
local ok2, result2 = pcall(function() -- line: 5
	-- upvalues: s3 (copy)
	local s3_2 = game:GetService(s3)
	local _ = s3_2.Name

	return s3_2
end)
local u9 = ok2 and result2 or nil
local t1 = {}

t1.__index = t1

function t1.new(p1, p2, p3) -- line: 19
	-- upvalues: t1 (copy)
	local self = setmetatable({}, t1)

	self._globalConfig = p1
	self._options = p2
	self._context = p3
	self._results = {}

	return self
end

local function parseRunPrefix(s4: string) -- line: 28
	return s4:match("([^/\\]+)%.json$") or (s4:match("([^/\\]+)$") or "")
end
local function extractFastFlagVariant(s5: string) -- line: 32
	if s5:sub(-16) == "-fastFlags-allOn" then
		return "allOn"
	end

	if s5:sub(-17) == "-fastFlags-allOff" then
		return "allOff"
	end

	return "default"
end
local function extractSuiteName(s6: string) -- line: 42
	return (s6:gsub("%-fastFlags%-allOn$", ""):gsub("%-fastFlags%-allOff$", ""))
end
local function formatTestResults(p4, p5, p6) -- line: 46
	-- upvalues: u9 (ref)
	local t2 = {
		summary = {
			totalTests = p4.numTotalTests,
			passed = p4.numPassedTests,
			failed = p4.numFailedTests,
			pending = p4.numPendingTests
		}
	}
	local t3 = {}
	local n1 = 0

	for _, v36 in p4.testResults do
		for _, v38 in v36.testResults do
			local v39 = formatTestAssertion(v38)

			v39.suite = p5
			v39.fastFlagVariant = p6
			v39.testFile = v36.testFilePath

			if v39.flaky then
				n1 += 1
			end

			table.insert(t3, v39)
		end
	end

	t2.testResults = t3
	t2.summary.flakyTests = n1

	return u9:JSONEncode(t2)
end

function formatTestAssertion(p7) -- line: 75
	return {
		testName = p7.fullName,
		status = p7.status,
		durationMs = p7.duration,
		flaky = p7.invocations > 1,
		failureMessages = p7.failureMessages or {},
		retryReasons = p7.retryReasons or {}
	}
end
function t1.onRunComplete(p8, _, p10) -- line: 86
	-- upvalues: u5 (ref), u9 (ref), formatTestResults (copy)
	if u5 and u9 then
		local outputFile = p8._options.outputFile
		local v45 = outputFile:match("([^/\\]+)%.json$") or (outputFile:match("([^/\\]+)$") or "")
		local v46 = if v45:sub(-16) ~= "-fastFlags-allOn" then v45:sub(-17) ~= "-fastFlags-allOff" and "default" or "allOff" else "allOn"
		local v47 = v45:gsub("%-fastFlags%-allOn$", ""):gsub("%-fastFlags%-allOff$", "")

		u5:WriteFile(p8._options.outputFile, formatTestResults(p10, v47, v46))
		print(string.format("Test results written to: %s\n", (tostring(p8._options.outputFile))))
	end
end

return t1
