local RunService = game:GetService("RunService")
local ParentParent = script.Parent.Parent
local Promise = require(ParentParent.Dev.Promise)
local v4 = game:DefineFastFlag("DummyFFlagPromiseRejectionFlagState", false)

local function isStackFrame(s1: string) -- line: 35
	return s1:match("^[%w%._%-]+:[%d]+.+") ~= nil
end
local function isRedactedPath(s2: string) -- line: 39
	return (s2:find("CorePackages.Packages.+%.TestEZ%.") or (s2:find("CorePackages.Packages.+%.Promise%.") or (s2:find("CorePackages.Packages.+%.roblox_rodux%.") or (s2:find("CorePackages.Packages.+%.React%.") or (s2:find("CorePackages.Packages.+%.ReactReconciler%.") or (s2:find("CorePackages.Packages.+%.Scheduler%.") or s2:find("CorePackages.Packages.+%.Shared%."))))))) ~= nil
end
local function reduceStacks(s3: string) -- line: 53
	-- upvalues: isRedactedPath (copy)
	local t1 = {}
	local v12 = false
	local g15 = nil
	local g16 = nil

	for _, v in ipairs(s3:split("\n")) do
		repeat
			if g15 or v:match("^[%w%._%-]+:[%d]+.+") == nil then
				if not g15 then
					v12 = false
				end

				g15 = false

				if isRedactedPath(v) then
					if t1[#t1] ~= "..." then
						table.insert(t1, "...")
					end
				else
					table.insert(t1, v)
				end

				g16 = true

				break
			end

			if v12 then
				g15 = true
			end
		until not g15

		if g16 then
			g16 = false

			continue
		end

		v12 = true
		table.insert(t1, v)
	end

	return table.concat(t1, "\n")
end

return function(b1: boolean?) -- line: 79
	-- upvalues: reduceStacks (copy), RunService (copy), v4 (copy), Promise (copy)
	local t2 = {}

	local function onUnhandledRejection(p1, ...) -- line: 82
		-- upvalues: b1 (copy), reduceStacks (copy), t2 (copy)
		local parts = p1._source:split("\n")
		local v22 = nil

		for i = #parts, 1, -1 do
			if parts[i]:find("%.([%a%d]+%.spec):(%d+)") then
				v22 = parts[i]

				break
			end
		end

		local str = nil
		local v25 = nil

		if select("#", ...) >= 1 then
			str = tostring(select(1, ...))
			v25 = if not b1 then reduceStacks(str) else str
		end

		local v26 = nil

		if str == nil or str:find("Promise created at:") == nil then
			v26 = if not b1 then reduceStacks(p1._source) else p1._source
		end

		local v27 = not v22 and "\n~~~ UNHANDLED PROMISE REJECTION ~~~\nNo test file was found in promise creation stack. " or `\n~~~ UNHANDLED PROMISE REJECTION ~~~\nPromise was created in test at:\n{ v22 }\n\n`

		if v25 ~= nil then
			v27 ..= ("Error output:\n%*"):format(v25)
		end

		if v26 ~= nil then
			v27 ..= ("\n\nPromise created at:\n%*"):format(v26)
		end

		table.insert(t2, v27)
	end

	return {
		reportRejections = function(n1: number?, n2: number?, n3: number?) -- line: 131
			-- upvalues: RunService (copy), v4 (copy), t2 (copy)
			RunService.Heartbeat:Wait()
			RunService.Heartbeat:Wait()

			local v31 = n3 or 1
			local v32 = if not v4 then n1 else n2
			local n4, s4

			if v32 == nil then
				n4 = 0
				s4 = "0 (default)"
			else
				n4 = math.floor(v32 * v31)
				s4 = tostring(n4)
			end

			if #t2 > 0 then
				local t3 = {}
				local v36 = n4 < #t2

				table.insert(t3, "Caught unhandled promise rejections caught during test run. These may indicate\nerrors in tested code, or tests that were not cleaned up properly.\n\nIf you would like to see full stack traces without library internals redacted,\npass `true` as the first argument to `createPromiseRejectionHandler`.\n\nMore information about unhandled promise rejections in tests (and how to clean\nthem up) can be found at https://roblox.atlassian.net/wiki/spaces/HOW/pages/1556186613/Handling+Lua+Promises+in+Tests.\n")

				for _, v in ipairs(t2) do
					table.insert(t3, v)
				end

				table.insert(t3, string.format("\nPromise rejection report:\n    unhandled rejections: %d", #t2))

				if v36 then
					table.insert(t3, string.format("    allowed rejections threshold: %s\n\nThis test suite run has FAILED due to exceeding the threshold of unhandled\npromise rejections. For any functionality changed, try running the suite with\nrelevant tests focused (new or existing) to find which tests are producing\nunhandled promise rejections", s4))
				end

				if n4 < #t2 then
					error(table.concat(t3, "\n"), 0)

					return
				end

				warn(table.concat(t3, "\n"))
			end
		end,
		inject = function() -- line: 174
			-- upvalues: Promise (copy), onUnhandledRejection (copy)
			Promise.TEST = true

			return Promise.onUnhandledRejection(onUnhandledRejection)
		end
	}
end
