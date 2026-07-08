local ParentParent = script.Parent.Parent
local ReactGlobals = require(ParentParent.ReactGlobals)
local console = require(ParentParent.Shared).console
local t1 = {}
local log = nil

require(script.Parent.ReactFiberLane)

local enableDebugTracing = require(ParentParent.Shared).ReactFeatureFlags.enableDebugTracing
local log2 = nil
local t2 = {}
local n1 = 0

function decimalToBinaryString(n2: number) -- line: 40
	local s1 = ""

	repeat
		local fraction

		n2, fraction = math.modf(n2 / 2)
		s1 = math.ceil(fraction) .. s1
	until n2 == 0

	local v16 = 31 - string.len(s1)

	return string.rep("0", v16) .. s1
end

local function formatLanes(p1) -- line: 53
	return "0b" .. decimalToBinaryString(p1)
end
local function group(...) -- line: 59
	-- upvalues: t2 (copy), log2 (ref), console (copy), log (ref)
	for _, v19 in { ... } do
		table.insert(t2, v19)
	end

	if log2 == nil then
		log2 = console.log
		console.log = log
	end
end
local function groupEnd() -- line: 69
	-- upvalues: t2 (copy), n1 (ref), console (copy), log2 (ref)
	table.remove(t2, 1)

	while n1 > #t2 do
		console.groupEnd()
		n1 -= 1
	end

	if #t2 == 0 then
		console.log = log2
		log2 = nil
	end
end

function log(...) -- line: 81
	-- upvalues: n1 (ref), t2 (copy), console (copy), log2 (ref)
	if n1 < #t2 then
		for i = n1 + 1, #t2 do
			local v21 = t2[i]

			console.group(v21)
		end

		n1 = #t2
	end

	if typeof(log2) == "function" then
		log2(...)

		return
	end

	console.log(...)
end
function t1.logCommitStarted(p2) -- line: 99
	-- upvalues: ReactGlobals (copy), enableDebugTracing (copy), group (copy)
	if ReactGlobals.__DEV__ and enableDebugTracing then
		group(string.format("* commit (%s)", "0b" .. decimalToBinaryString(p2)), "", "", "")
	end
end
function t1.logCommitStopped() -- line: 114
	-- upvalues: ReactGlobals (copy), enableDebugTracing (copy), groupEnd (copy)
	if ReactGlobals.__DEV__ and enableDebugTracing then
		groupEnd()
	end
end
function t1.logComponentSuspended(s2: string, p3) -- line: 142
	-- upvalues: ReactGlobals (copy), enableDebugTracing (copy), log (ref)
	if ReactGlobals.__DEV__ and enableDebugTracing then
		log(string.format("* %s suspended", s2))
		p3:andThen(function() -- line: 156
			-- upvalues: log (ref), s2 (copy)
			log(string.format("* %s resolved", s2))
		end, function() -- line: 165
			-- upvalues: log (ref), s2 (copy)
			log(string.format("* %s rejected", s2))
		end)
	end
end
function t1.logLayoutEffectsStarted(p4) -- line: 180
	-- upvalues: ReactGlobals (copy), enableDebugTracing (copy), group (copy)
	if ReactGlobals.__DEV__ and enableDebugTracing then
		group(string.format("* layout effects (%s)", "0b" .. decimalToBinaryString(p4)))
	end
end
function t1.logLayoutEffectsStopped() -- line: 195
	-- upvalues: ReactGlobals (copy), enableDebugTracing (copy), groupEnd (copy)
	if ReactGlobals.__DEV__ and enableDebugTracing then
		groupEnd()
	end
end
function t1.logPassiveEffectsStarted(p5) -- line: 204
	-- upvalues: ReactGlobals (copy), enableDebugTracing (copy), group (copy)
	if ReactGlobals.__DEV__ and enableDebugTracing then
		group(string.format("* passive effects (%s)", "0b" .. decimalToBinaryString(p5)))
	end
end
function t1.logPassiveEffectsStopped() -- line: 219
	-- upvalues: ReactGlobals (copy), enableDebugTracing (copy), groupEnd (copy)
	if ReactGlobals.__DEV__ and enableDebugTracing then
		groupEnd()
	end
end
function t1.logRenderStarted(p6) -- line: 228
	-- upvalues: ReactGlobals (copy), enableDebugTracing (copy), group (copy)
	if ReactGlobals.__DEV__ and enableDebugTracing then
		group(string.format("* render (%s)", "0b" .. decimalToBinaryString(p6)))
	end
end
function t1.logRenderStopped() -- line: 243
	-- upvalues: ReactGlobals (copy), enableDebugTracing (copy), groupEnd (copy)
	if ReactGlobals.__DEV__ and enableDebugTracing then
		groupEnd()
	end
end
function t1.logForceUpdateScheduled(s3: string, p7) -- line: 252
	-- upvalues: ReactGlobals (copy), enableDebugTracing (copy), log (ref)
	if ReactGlobals.__DEV__ and enableDebugTracing then
		log(string.format("* %s forced update (%s)", s3, "0b" .. decimalToBinaryString(p7)))
	end
end
function t1.logStateUpdateScheduled(s4: string, p8, _) -- line: 267
	-- upvalues: ReactGlobals (copy), enableDebugTracing (copy), log (ref)
	if ReactGlobals.__DEV__ and enableDebugTracing then
		log(string.format("* %s updated state (%s)", s4, "0b" .. decimalToBinaryString(p8)))
	end
end

return t1
