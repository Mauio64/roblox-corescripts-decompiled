local ChatUIPrimitives = script:FindFirstAncestor("ChatUIPrimitives")
local parent = ChatUIPrimitives.Parent

local React = require(parent.React)
local Signals = require(parent.Signals)
local SignalsExperimental = require(parent.SignalsExperimental)

local useStableSignal = require(ChatUIPrimitives.Hooks.useStableSignal)

local function useMessagePool(data)
	local ref = React.useRef({})
	local ref2 = React.useRef({})
	local ref3 = React.useRef(0)

	local maxSlots = data.maxSlots or 50

	local ref4 = React.useRef(data.createSlotElement)
	ref4.current = data.createSlotElement

	local v, v2 = useStableSignal({})

	local function publishChildrenFromCache()
		local elementsByStableKey = {}

		for _, v3 in ref.current do
			elementsByStableKey[v3.stableKey] = v3.element
		end

		for _, v3 in ref2.current do
			elementsByStableKey[v3.stableKey] = v3.element
		end

		v2(elementsByStableKey)
	end

	local function rebuildElementsFromFactory()
		local current = ref4.current

		for _, v3 in ref.current do
			v3.element = current({
				getMessageId = v3.getMessageId,
				getLayoutOrder = v3.getLayoutOrder
			})
		end

		for _, v3 in ref2.current do
			v3.element = current({
				getMessageId = v3.getMessageId,
				getLayoutOrder = v3.getLayoutOrder
			})
		end

		publishChildrenFromCache()
	end

	local function reconcile(list) -- 2 equivalent calls inferred from this helper
		SignalsExperimental.batch(function()
			local current = ref.current
			local current2 = ref2.current

			local count = #list
			local v3 = math.max(1, count - maxSlots + 1)

			local set = {}
			local flag = false

			for i = v3, count do
				set[list[i]] = true
			end

			for k, v4 in current do
				if set[k] then
					continue
				end

				v4.setMessageId(nil)
				current2[#current2 + 1] = v4
				current[k] = nil
			end

			for i = v3, count do
				local item = list[i]

				if current[item] then
					continue
				end

				local v4

				if #current2 > 0 then
					v4 = current2[#current2]
					current2[#current2] = nil
					v4.setMessageId(item)
				else
					ref3.current += 1
					local stableKey = "slot-" .. ref3.current
					local signal, setMessageId = Signals.createSignal(item)
					local signal2, setLayoutOrder = Signals.createSignal(0)
					v4 = {
						stableKey = stableKey,
						getMessageId = signal,
						setMessageId = setMessageId,
						getLayoutOrder = signal2,
						setLayoutOrder = setLayoutOrder,
						element = ref4.current({ getMessageId = signal, getLayoutOrder = signal2 })
					}
					flag = true
				end

				current[item] = v4
			end

			local v4 = 0

			for i = v3, count do
				local v5 = current[list[i]]

				if v5 == nil then
					continue
				end

				local v6 = v5.getLayoutOrder(false)

				if v6 <= v4 then
					v6 = v4 + 1
					v5.setLayoutOrder(v6)
				end

				v4 = v6
			end

			if flag then
				publishChildrenFromCache()
			end
		end)
	end

	local ref5 = React.useRef(false)

	if not ref5.current then
		ref5.current = true
		reconcile(data.messageIdsSignal()) -- inferred equivalent call
	end

	React.useEffect(function()
		return (Signals.createEffect(function(p)
			reconcile(data.messageIdsSignal(p)) -- inferred equivalent call
		end))
	end, { data.messageIdsSignal, v2, maxSlots })

	local ref6 = React.useRef(false)

	React.useEffect(function()
		if ref6.current then
			rebuildElementsFromFactory()
		else
			ref6.current = true
		end
	end, { data.createSlotElement })

	return v
end

return useMessagePool
