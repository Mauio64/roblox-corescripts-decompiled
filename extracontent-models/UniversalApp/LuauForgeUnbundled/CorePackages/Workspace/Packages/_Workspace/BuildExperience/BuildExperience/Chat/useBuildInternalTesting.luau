local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SignalsReact")
local CreatorAgentChat = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/CreatorAgentChat")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/GetBuildModelSelectionStore/createBuildModelSelectionStore")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/ModelPicker/ModelPickerTypes")
local experimentOverride = CreatorAgentChat.experimentOverride

local object = setmetatable({}, { __mode = "k" })

local function useBuildInternalTesting(p2, data, p3)
	local ref = React.useRef(nil)

	local v5 = React.useMemo(function()
		local v6 = data or p2
		local current = ref.current
		local v7 = if v6 ~= nil then object[v6] else nil

		if
			v7 == nil
			and current ~= nil
			and current.entry == p2
			and current.routeSessionId == p3
			and (current.session == nil or current.session.getCasSessionId() == nil)
		then
			v7 = current.pending
		end

		if v7 == nil then
			local pendingKey = experimentOverride.createPendingKey()
			local v8 = 0
			local v9 = {
				key = pendingKey,
				retain = function()
					v8 += 1
					return function()
						v8 -= 1

						if v8 == 0 then
							experimentOverride.clear(pendingKey)
						end
					end
				end
			}

			if v6 ~= nil then
				object[v6] = v9
			end

			ref.current = {
				entry = p2,
				session = data,
				routeSessionId = p3,
				pending = v9
			}
			return v9
		end

		if v6 ~= nil then
			object[v6] = v7
		end

		ref.current = { entry = p2, session = data, routeSessionId = p3, pending = v7 }
		return v7
	end, { p2, data, p3 })
	local ref2 = React.useRef(nil)
	local v6 = React.useMemo(function()
		return {}
	end, { p2, data })
	React.useLayoutEffect(function()
		ref2.current = v6
		return function()
			ref2.current = nil
		end
	end, { v6 })
	React.useEffect(function()
		return v5.retain()
	end, { v5 })

	local v7 = React.useCallback(function()
		local getKey = experimentOverride.getKey
		local v8 = if data ~= nil then data.getCasSessionId() else nil
		return getKey(v8) or v5.key
	end, { data, v5 })
	local v8 = React.useMemo(function()
		return Signals.createComputed(function(p4)
			if data ~= nil then
				data.getModels(p4)
			end

			return experimentOverride.getInternalSelection(v7(), p4)
		end, function(data2, data3): boolean
			return data2.isSelected == data3.isSelected
				and data2.previewHash == data3.previewHash
				and data2.previewSpecName == data3.previewSpecName
		end)
	end, { data, v7 })
	local v9 = SignalsReact.useSignalState(v8)
	local function canEdit(): boolean
		local v10 = if p2 ~= nil then p2.getSelection(false) else nil
		return ref2.current == v6 and v10 ~= nil and not v10.isBusy
	end

	local function adoptPending()
		if data ~= nil then
			data.setPendingExperimentKey(v5.key)
		end
	end
	React.useLayoutEffect(function()
		if data ~= nil and experimentOverride.has(v5.key) then
			data.setPendingExperimentKey(v5.key)
		end
	end, { data, v5 })

	return p2 ~= nil and {
		isSelected = v9.isSelected,
		previewHash = v9.previewHash,
		previewSpecName = v9.previewSpecName,
		onSelect = function()
			local v10 = if p2 ~= nil then p2.getSelection(false) else nil
			local v11 = ref2.current == v6 and v10 ~= nil and not v10.isBusy

			if v11 then
				experimentOverride.selectInternal(v7(), true)

				if data ~= nil then
					data.setPendingExperimentKey(v5.key)
				end
			end
		end,
		onSaveSpec = function(p4, p5)
			local v10 = if p2 ~= nil then p2.getSelection(false) else nil
			local v11 = ref2.current == v6 and v10 ~= nil and not v10.isBusy

			if v11 and experimentOverride.getInternalSelection(v7(), false).isSelected then
				experimentOverride.set(v7(), p4, p5)
				experimentOverride.selectInternal(v7(), true)

				if data ~= nil then
					data.setPendingExperimentKey(v5.key)
				end
			end
		end,
		onExit = function()
			local v10 = if p2 ~= nil then p2.getSelection(false) else nil
			local v11 = ref2.current == v6 and v10 ~= nil and not v10.isBusy

			if v11 and experimentOverride.getInternalSelection(v7(), false).isSelected then
				experimentOverride.selectInternal(v7(), false)

				if data ~= nil then
					data.setPendingExperimentKey(v5.key)
				end
			end
		end
	} or nil, v5.key
end

return useBuildInternalTesting
