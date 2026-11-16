local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local React = require(parent.React)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)
local CreatorAgentChat = require(parent.DataHydration.CreatorAgentChat)
require(BuildExperience.Stores.GetBuildModelSelectionStore.createBuildModelSelectionStore)
require(BuildExperience.Components.ModelPicker.ModelPickerTypes)
local experimentOverride = CreatorAgentChat.experimentOverride

local object = setmetatable({}, { __mode = "k" })

local function useBuildInternalTesting(entry, session, routeSessionId: string?)
	local ref = React.useRef(nil)

	local v = React.useMemo(function()
		local v = session or entry
		local current = ref.current
		local pending

		if v ~= nil then
			pending = object[v]
		end

		if
			pending == nil
			and current ~= nil
			and current.entry == entry
			and current.routeSessionId == routeSessionId
			and (current.session == nil or current.session.getCasSessionId() == nil)
		then
			pending = current.pending
		end

		if pending == nil then
			local pendingKey = experimentOverride.createPendingKey()
			local v2 = 0
			local pending2 = {
				key = pendingKey,
				retain = function()
					v2 += 1
					return function()
						v2 -= 1

						if v2 == 0 then
							experimentOverride.clear(pendingKey)
						end
					end
				end
			}

			if v ~= nil then
				object[v] = pending2
			end

			ref.current = {
				entry = entry,
				session = session,
				routeSessionId = routeSessionId,
				pending = pending2
			}
			return pending2
		end

		if v ~= nil then
			object[v] = pending
		end

		ref.current = {
			entry = entry,
			session = session,
			routeSessionId = routeSessionId,
			pending = pending
		}
		return pending
	end, { entry, session, routeSessionId })
	local ref2 = React.useRef(nil)
	local current = React.useMemo(function()
		return {}
	end, { entry, session })
	React.useLayoutEffect(function()
		ref2.current = current
		return function()
			ref2.current = nil
		end
	end, { current })
	React.useEffect(function()
		return v.retain()
	end, { v })

	local v2 = React.useCallback(function()
		local getKey = experimentOverride.getKey
		local v2

		if session ~= nil then
			v2 = session.getCasSessionId()
		end

		return getKey(v2) or v.key
	end, { session, v })
	local v3 = React.useMemo(function()
		return Signals.createComputed(function(p)
			if session ~= nil then
				session.getModels(p)
			end

			return experimentOverride.getInternalSelection(v2(), p)
		end, function(p, p2): boolean
			return p.isSelected == p2.isSelected and p.previewHash == p2.previewHash
		end)
	end, { session, v2 })
	local v4 = SignalsReact.useSignalState(v3)
	local function canEdit(): boolean -- 3 equivalent calls inferred from this helper
		local v5

		if entry ~= nil then
			v5 = entry.getSelection(false)
		end

		return ref2.current == current and v5 ~= nil and not v5.isBusy
	end

	local function adoptPending() -- 3 equivalent calls inferred from this helper
		if session ~= nil then
			session.setPendingExperimentKey(v.key)
		end
	end
	React.useLayoutEffect(function()
		if session ~= nil and experimentOverride.has(v.key) then
			session.setPendingExperimentKey(v.key)
		end
	end, { session, v })

	return entry ~= nil and {
		isSelected = v4.isSelected,
		previewHash = v4.previewHash,
		onSelect = function()
			if canEdit() then -- inferred equivalent call
				experimentOverride.selectInternal(v2(), true)
				adoptPending() -- inferred equivalent call
			end
		end,
		onSaveSpec = function(p: string?)
			if canEdit() and experimentOverride.getInternalSelection(v2(), false).isSelected then -- inferred equivalent call
				experimentOverride.set(v2(), p)
				experimentOverride.selectInternal(v2(), true)
				adoptPending() -- inferred equivalent call
			end
		end,
		onExit = function()
			if canEdit() and experimentOverride.getInternalSelection(v2(), false).isSelected then -- inferred equivalent call
				experimentOverride.selectInternal(v2(), false)
				adoptPending() -- inferred equivalent call
			end
		end
	} or nil, v.key
end

return useBuildInternalTesting
