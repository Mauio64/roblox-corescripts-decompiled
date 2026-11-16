local defineFastFlag = game:DefineFastFlag("DebugMyStatsExperienceAgentSpec", false)

local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Signals")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/Types/acpSession")
local fFlagBuildExperienceModelPickerData = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/SharedFlags").FFlagBuildExperienceModelPickerData
local v5 = Signals.createSignal

if fFlagBuildExperienceModelPickerData and defineFastFlag then
	v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/SignalsUtils").createSessionScopedSignal
end

local v6, v7 = v5({})
local v8, v9 = v5({})
local v10 = {}
local v11, v12

if fFlagBuildExperienceModelPickerData and defineFastFlag then
	v11, v12 = v5({})
else
	v11 = function(p2)
		return v10
	end

	v12 = function(p2) end
end

local function getState(p2, p3)
	local v13 = if p2 ~= nil then v6(p3 or false)[p2] else nil
	local state = {
		isSet = v13 ~= nil,
		specVersion = 0
	}

	local v14 = if v13 ~= nil and v13.specVersion ~= "" then v13.specVersion else nil
	state.specVersion = v14
	return state
end

local function writeDisplay(p2, p3, p4)
	local clone = table.clone(v6(false))
	local clone2 = table.clone(p4 or clone[p2] or {
		clientToolConfig = { mode = "exclude", tools = {} }
	})
	clone2.specVersion = (p3 == nil or p3 == "" or p3 == "latest") and "" or p3
	clone[p2] = clone2
	v7(clone)
end

local function setPendingFlag(p2, p3)
	local v13 = not (p2 == nil) and v8(false)[p2] == true

	if v13 == p3 then
		return
	end

	local clone = table.clone(v8(false))

	if p3 then
		clone[p2] = true
	else
		clone[p2] = nil
	end

	v9(clone)
end

local count = 0

local function buildPromptPayload(p2)
	local clone = table.clone(v6(false)[p2])

	if v11(false)[p2] == false then
		clone.specVersion = ""
	end

	return clone
end

return {
	isEnabled = function()
		return defineFastFlag
	end,
	getKey = function(p2)
		if p2 == nil or p2 == "" then
			return nil
		end

		return `session:{p2}`
	end,
	selectInternal = function(p2, p3)
		if not getState(p2).isSet then
			writeDisplay(p2, nil)
		end

		local clone = table.clone(v11(false))
		clone[p2] = p3
		v12(clone)
		local v13 = not (p2 == nil) and v8(false)[p2] == true

		if v13 == true then
			return
		end

		local clone2 = table.clone(v8(false))

		clone2[p2] = true

		v9(clone2)
	end,
	getInternalSelection = function(p2, p3)
		local v13 = v11(p3)[p2]
		local state = getState(p2, p3)

		if v13 == nil then
			v13 = state.specVersion ~= nil
		end

		return { isSelected = v13, previewHash = state.specVersion }
	end,
	hasInternalEdit = function(p2): boolean
		return p2 ~= nil and v11(false)[p2] ~= nil
	end,
	normalize = function(p2)
		if p2 == nil or p2 == "" or p2 == "latest" then
			return ""
		end

		return p2
	end,
	createPendingKey = function()
		count += 1
		return `pending:{count}`
	end,
	getState = getState,
	getStateSignal = function(p2)
		return Signals.createComputed(function(p3)
			return getState(p2, p3)
		end)
	end,
	get = function(p2)
		return getState(p2, nil).specVersion
	end,
	has = function(p2)
		return getState(p2, nil).isSet
	end,
	isPending = function(p2): boolean
		return p2 ~= nil and v8(false)[p2] == true
	end,
	set = function(p2, p3)
		if p2 == nil then
			return
		end

		writeDisplay(p2, p3)
		local v13 = not (p2 == nil) and v8(false)[p2] == true

		if v13 == true then
			return
		end

		local clone = table.clone(v8(false))

		clone[p2] = true

		v9(clone)
	end,
	hydrate = function(p2, p3, p4)
		if p2 ~= nil then
			local v13 = not (p2 == nil) and v8(false)[p2] == true

			if not v13 and v11(false)[p2] == nil then
				writeDisplay(p2, p3, p4)
			end
		end
	end,
	clear = function(p2)
		if p2 == nil then
			return
		end

		local clone = table.clone(v6(false))
		clone[p2] = nil
		v7(clone)
		local v13 = not (p2 == nil) and v8(false)[p2] == true

		if v13 ~= false then
			local clone2 = table.clone(v8(false))

			clone2[p2] = nil

			v9(clone2)
		end

		local clone2 = table.clone(v11(false))
		clone2[p2] = nil
		v12(clone2)
	end,
	consumePending = function(p2)
		if p2 ~= nil then
			local v13 = not (p2 == nil) and v8(false)[p2] == true

			if v13 then
				local v14 = not (p2 == nil) and v8(false)[p2] == true

				if v14 == false then
					return
				end

				local clone = table.clone(v8(false))

				clone[p2] = nil

				v9(clone)
			end
		end
	end,
	move = function(p2, p3)
		local v13 = v6(false)

		if p2 == nil or p3 == nil or v13[p2] == nil or p2 == p3 then
			return
		end

		local clone = table.clone(v13)
		clone[p3] = clone[p2]
		clone[p2] = nil
		v7(clone)
		local clone2 = table.clone(v11(false))
		clone2[p3] = clone2[p2]
		clone2[p2] = nil
		v12(clone2)
		local v14 = not (p2 == nil) and v8(false)[p2] == true
		local v15 = not (p2 == nil) and v8(false)[p2] == true

		if v15 ~= false then
			local clone3 = table.clone(v8(false))

			clone3[p2] = nil

			v9(clone3)
		end

		local v16 = not (p3 == nil) and v8(false)[p3] == true

		if v16 == v14 then
			return
		end

		local clone3 = table.clone(v8(false))

		if v14 then
			clone3[p3] = true
		else
			clone3[p3] = nil
		end

		v9(clone3)
	end,
	getExperiment = function(p2)
		local state = getState(p2, nil)

		if not defineFastFlag or state.specVersion == nil then
			return nil
		end

		local clone = table.clone(v6(false)[p2])

		if v11(false)[p2] == false then
			clone.specVersion = ""
		end

		return clone
	end,
	getPromptExperiment = function(p2)
		local state = getState(p2, nil)

		if not defineFastFlag then
			return nil
		end

		local v13 = not (p2 == nil) and v8(false)[p2] == true

		if v13 and state.isSet then
			local clone = table.clone(v6(false)[p2])

			if v11(false)[p2] == false then
				clone.specVersion = ""
			end

			return clone
		end

		return nil
	end
}
