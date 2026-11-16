local parent = script.Parent.Parent
local ReactGlobals = require(parent.ReactGlobals)

local Shared = require(parent.Shared)
local console = Shared.console
local DebugTracing = {}

local log

require(script.Parent.ReactFiberLane)

local Shared2 = require(parent.Shared)
local enableDebugTracing = Shared2.ReactFeatureFlags.enableDebugTracing

local log2 = nil

local v = {}

local v2 = 0

function decimalToBinaryString(p: number)
	local v3 = ""

	repeat
		local v4
		p, v4 = math.modf(p / 2)

		v3 = math.ceil(v4) .. v3
	until p == 0

	local v4 = 31 - string.len(v3)
	return string.rep("0", v4) .. v3
end

local function formatLanes(p) -- 6 equivalent calls inferred from this helper
	return "0b" .. decimalToBinaryString(p)
end

local function group(...)
	for _, v3 in { ... } do
		table.insert(v, v3)
	end

	if log2 == nil then
		log2 = console.log
		console.log = log
	end
end

local function groupEnd()
	table.remove(v, 1)

	while v2 > #v do
		console.groupEnd()
		v2 -= 1
	end

	if #v == 0 then
		console.log = log2
		log2 = nil
	end
end

log = function(...)
	if v2 < #v then
		for i = v2 + 1, #v do
			local v3 = v[i]
			console.group(v3)
		end

		v2 = #v
	end

	if typeof(log2) == "function" then
		log2(...)
	else
		console.log(...)
	end
end

function DebugTracing.logCommitStarted(p)
	if ReactGlobals.__DEV__ and enableDebugTracing then
		group(string.format("* commit (%s)", formatLanes(p)), "", "", "") -- inferred equivalent call
	end
end

function DebugTracing.logCommitStopped()
	if ReactGlobals.__DEV__ and enableDebugTracing then
		groupEnd()
	end
end

function DebugTracing.logComponentSuspended(p: string, object)
	if ReactGlobals.__DEV__ and enableDebugTracing then
		log(string.format("* %s suspended", p))

		object:andThen(function()
			log(string.format("* %s resolved", p))
		end, function()
			log(string.format("* %s rejected", p))
		end)
	end
end

function DebugTracing.logLayoutEffectsStarted(p)
	if ReactGlobals.__DEV__ and enableDebugTracing then
		group(string.format("* layout effects (%s)", formatLanes(p))) -- inferred equivalent call
	end
end

function DebugTracing.logLayoutEffectsStopped()
	if ReactGlobals.__DEV__ and enableDebugTracing then
		groupEnd()
	end
end

function DebugTracing.logPassiveEffectsStarted(p)
	if ReactGlobals.__DEV__ and enableDebugTracing then
		group(string.format("* passive effects (%s)", formatLanes(p))) -- inferred equivalent call
	end
end

function DebugTracing.logPassiveEffectsStopped()
	if ReactGlobals.__DEV__ and enableDebugTracing then
		groupEnd()
	end
end

function DebugTracing.logRenderStarted(p)
	if ReactGlobals.__DEV__ and enableDebugTracing then
		group(string.format("* render (%s)", formatLanes(p))) -- inferred equivalent call
	end
end

function DebugTracing.logRenderStopped()
	if ReactGlobals.__DEV__ and enableDebugTracing then
		groupEnd()
	end
end

function DebugTracing.logForceUpdateScheduled(p: string, p2)
	if ReactGlobals.__DEV__ and enableDebugTracing then
		log(string.format("* %s forced update (%s)", p, formatLanes(p2))) -- inferred equivalent call
	end
end

function DebugTracing.logStateUpdateScheduled(p: string, p2, _)
	if ReactGlobals.__DEV__ and enableDebugTracing then
		log(string.format("* %s updated state (%s)", p, formatLanes(p2))) -- inferred equivalent call
	end
end
return DebugTracing
