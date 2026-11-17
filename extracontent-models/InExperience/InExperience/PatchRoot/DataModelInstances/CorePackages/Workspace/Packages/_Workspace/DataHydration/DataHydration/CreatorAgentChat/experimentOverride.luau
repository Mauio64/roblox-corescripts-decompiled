local defineFastFlag = game:DefineFastFlag("DebugMyStatsExperienceAgentSpec", false)

local parent = script:FindFirstAncestor("DataHydration").Parent

local Signals = require(parent.Signals)
require(script.Parent.Types.acpSession)
local SharedFlags = require(parent.SharedFlags)
local FFlagBuildExperienceModelPickerData = SharedFlags.FFlagBuildExperienceModelPickerData
local FFlagBuildExperienceAdvancedPreviewSpecs = SharedFlags.FFlagBuildExperienceAdvancedPreviewSpecs
local v = Signals.createSignal

if FFlagBuildExperienceModelPickerData and defineFastFlag then
	local SignalsUtils = require(parent.SignalsUtils)
	v = SignalsUtils.createSessionScopedSignal
end

local v2, v3 = v({})
local v4, v5 = v({})
local v6 = {}
local v7, v8

if FFlagBuildExperienceModelPickerData and defineFastFlag then
	v7, v8 = v({})
else
	v7 = function(_)
		return v6
	end

	v8 = function(_) end
end

local function normalize(p: string?) -- 1 equivalent call inferred from this helper
	return if p == nil or p == "" or p == "latest" then "" else p
end

local function getState(p: string?, p2)
	local v9

	if p ~= nil then
		v9 = v2(p2 or false)[p]
	end

	local state = {
		isSet = v9 ~= nil,
		specVersion = 0,
		specName = 0
	}
	local specVersion

	if not (v9 == nil or v9.specVersion == "") then
		specVersion = v9.specVersion
	end

	state.specVersion = specVersion
	local specName

	if FFlagBuildExperienceAdvancedPreviewSpecs and v9 ~= nil then
		specName = v9.specName
	end

	state.specName = specName
	return state
end

local function isPending(p: string?): boolean -- 5 equivalent calls inferred from this helper
	return p ~= nil and v4(false)[p] == true
end

local function writeDisplay(p: string, p2: string?, p3, specName)
	local clone = table.clone(v2(false))
	local clone2 = table.clone(p3 or clone[p] or {
		clientToolConfig = { mode = "exclude", tools = {} }
	})

	clone2.specVersion = normalize(p2) -- inferred equivalent call

	if FFlagBuildExperienceAdvancedPreviewSpecs and p3 == nil then
		clone2.specName = specName
	end

	clone[p] = clone2
	v3(clone)
end

local function setPendingFlag(p: string, pending: boolean) -- 6 equivalent calls inferred from this helper
	if isPending(p) == pending then -- inferred equivalent call
		return
	end

	local clone = table.clone(v4(false))

	if pending then
		clone[p] = true
	else
		clone[p] = nil
	end

	v5(clone)
end

local count = 0

local function buildPromptPayload(p: string)
	local clone = table.clone(v2(false)[p])

	if v7(false)[p] == false then
		clone.specVersion = ""

		if FFlagBuildExperienceAdvancedPreviewSpecs then
			clone.specName = nil
		end
	end

	if
		FFlagBuildExperienceAdvancedPreviewSpecs
		and clone.specName == "build-on-mobile-advanced"
		and clone.specVersion == ""
	then
		clone.specVersion = "latest"
	end

	return clone
end

local ExperimentOverride = {}

function ExperimentOverride.isEnabled()
	return defineFastFlag
end

function ExperimentOverride.getKey(p: string?)
	if p == nil or p == "" then
		return nil
	end

	return `session:{p}`
end

function ExperimentOverride.selectInternal(p: string, flag: boolean)
	if not getState(p).isSet then
		writeDisplay(p, nil)
	end

	local clone = table.clone(v7(false))
	clone[p] = flag
	v8(clone)
	setPendingFlag(p, true) -- inferred equivalent call
end

function ExperimentOverride.getInternalSelection(p: string, p2)
	local isSelected = v7(p2)[p]
	local state = getState(p, p2)

	if isSelected == nil then
		isSelected = state.specVersion ~= nil or state.specName == "build-on-mobile-advanced"
	end

	return {
		isSelected = isSelected,
		previewHash = state.specVersion,
		previewSpecName = state.specName
	}
end

function ExperimentOverride.hasInternalEdit(p: string?): boolean
	return p ~= nil and v7(false)[p] ~= nil
end

ExperimentOverride.normalize = normalize

function ExperimentOverride.createPendingKey()
	count += 1
	return `pending:{count}`
end

ExperimentOverride.getState = getState

function ExperimentOverride.getStateSignal(p: string?)
	return Signals.createComputed(function(p2)
		return getState(p, p2)
	end)
end

function ExperimentOverride.get(p: string?)
	return getState(p, nil).specVersion
end

function ExperimentOverride.has(p: string?)
	return getState(p, nil).isSet
end

ExperimentOverride.isPending = isPending

function ExperimentOverride.set(p: string?, p2: string?, specName)
	if p == nil then
		return
	end

	writeDisplay(p, p2, nil, specName)
	setPendingFlag(p, true) -- inferred equivalent call
end

function ExperimentOverride.hydrate(p: string?, p2: string?, p3)
	if p ~= nil and not isPending(p) and v7(false)[p] == nil then -- inferred equivalent call
		writeDisplay(p, p2, p3)
	end
end

function ExperimentOverride.clear(p: string?)
	if p == nil then
		return
	end

	local clone = table.clone(v2(false))
	clone[p] = nil
	v3(clone)
	setPendingFlag(p, false) -- inferred equivalent call
	local clone2 = table.clone(v7(false))
	clone2[p] = nil
	v8(clone2)
end

function ExperimentOverride.consumePending(p: string?)
	if p ~= nil and isPending(p) then -- inferred equivalent call
		setPendingFlag(p, false) -- inferred equivalent call
	end
end

function ExperimentOverride.move(p: string?, p2: string?)
	local v9 = v2(false)

	if p == nil or p2 == nil or v9[p] == nil or p == p2 then
		return
	end

	local clone = table.clone(v9)
	clone[p2] = clone[p]
	clone[p] = nil
	v3(clone)
	local clone2 = table.clone(v7(false))
	clone2[p2] = clone2[p]
	clone2[p] = nil
	v8(clone2)
	local pending = isPending(p) -- inferred equivalent call
	setPendingFlag(p, false) -- inferred equivalent call
	setPendingFlag(p2, pending) -- inferred equivalent call
end

function ExperimentOverride.getExperiment(p: string?)
	local state = getState(p, nil)
	local v9 = FFlagBuildExperienceAdvancedPreviewSpecs

	if v9 then
		if state.specName == "build-on-mobile-advanced" then
			v9 = v7(false)[p] ~= false
		else
			v9 = false
		end
	end

	if defineFastFlag and (state.specVersion ~= nil or v9) then
		return buildPromptPayload(p)
	end

	return nil
end

function ExperimentOverride.getPromptExperiment(p: string?)
	local state = getState(p, nil)

	if defineFastFlag and isPending(p) and state.isSet then -- inferred equivalent call
		return buildPromptPayload(p)
	end

	return nil
end

return ExperimentOverride
