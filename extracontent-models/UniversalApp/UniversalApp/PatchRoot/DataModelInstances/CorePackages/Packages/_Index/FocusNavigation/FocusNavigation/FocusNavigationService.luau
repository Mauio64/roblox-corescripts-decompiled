local parent = script.Parent.Parent
local EventPropagation = require(parent.EventPropagation)
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local SafeFlags = require(parent.SafeFlags)

local getFFlag = SafeFlags.createGetFFlag("FocusNavigationRefocusSuppression")

local createSignal = FocusNavigationUtils.createSignal
local shallowEqual = FocusNavigationUtils.shallowEqual
local getAncestors = FocusNavigationUtils.getAncestors
local mockableWarn = FocusNavigationUtils.mockableWarn
local isValidFocusTarget = require(script.Parent.isValidFocusTarget)

require(script.Parent.types)

local FocusNavigationService = {}
FocusNavigationService.__index = FocusNavigationService

function FocusNavigationService.new(engineInterface, p)
	local signal, fireActiveEventMapSignal = createSignal({})
	local signal2, fireFocusedGuiObjectSignal = createSignal(engineInterface.getSelection())
	local signal3, fireEventDispatchedSignal = createSignal(nil)

	local v = {
		_eventPropagationService = EventPropagation.new(),
		_engineInterface = engineInterface,
		_eventMapByInstance = setmetatable({}, { __mode = "k" }),
		_focusBehaviorByInstance = setmetatable({}, { __mode = "k" }),
		_engineEventConnections = {},
		_silentFocusTarget = nil,
		_silentBlurTarget = nil,
		_shouldSuppressContainerRefocus = 0,
		_fireActiveEventMapSignal = 0,
		_fireFocusedGuiObjectSignal = 0,
		_fireEventDispatchedSignal = 0,
		activeEventMap = 0,
		focusedGuiObject = 0,
		eventDispatched = 0
	}
	local shouldSuppressContainerRefocus

	if p then
		shouldSuppressContainerRefocus = p.shouldSuppressContainerRefocus
	end

	v._shouldSuppressContainerRefocus = shouldSuppressContainerRefocus

	v._fireActiveEventMapSignal = fireActiveEventMapSignal
	v._fireFocusedGuiObjectSignal = fireFocusedGuiObjectSignal
	v._fireEventDispatchedSignal = fireEventDispatchedSignal

	v.activeEventMap = signal
	v.focusedGuiObject = signal2
	v.eventDispatched = signal3
	local object = setmetatable(v, FocusNavigationService)

	object:_connectToInputEvents()

	return object
end

function FocusNavigationService:_fireInputEvent(target, data, wasProcessed: boolean?)
	local eventName = self.activeEventMap:getValue()[data.KeyCode]

	if eventName then
		local eventData = {
			Delta = data.Delta,
			KeyCode = data.KeyCode,
			Position = data.Position,
			UserInputState = data.UserInputState,
			UserInputType = data.UserInputType,
			wasProcessed = wasProcessed
		}

		self._eventPropagationService:propagateEvent(target, eventName, eventData, {
			synthetic = false,
			silent = false
		})

		self._fireEventDispatchedSignal({
			eventName = eventName,
			target = target,
			eventData = eventData,
			synthetic = false
		})
	end
end

function FocusNavigationService:_connectToInputEvents()
	local function forwardInputEvent(p, p2)
		local selection = self._engineInterface.getSelection()

		if selection then
			self:_fireInputEvent(selection, p, p2)
		end
	end
	table.insert(self._engineEventConnections, self._engineInterface.InputBegan:Connect(forwardInputEvent))
	table.insert(self._engineEventConnections, self._engineInterface.InputChanged:Connect(forwardInputEvent))
	table.insert(self._engineEventConnections, self._engineInterface.InputEnded:Connect(forwardInputEvent))

	local function onFocusChanged()
		local value = self.focusedGuiObject:getValue()
		local selection = self._engineInterface.getSelection()

		if value then
			local silent = self._silentBlurTarget == value
			self._eventPropagationService:propagateEvent(value, "blur", nil, {
				synthetic = false,
				silent = silent
			})

			self._silentBlurTarget = nil
		end

		self._fireFocusedGuiObjectSignal(selection)

		if selection then
			local silent = selection == self._silentFocusTarget
			self._eventPropagationService:propagateEvent(selection, "focus", nil, {
				synthetic = false,
				silent = silent
			})

			self._silentFocusTarget = nil
		end

		self:_updateActiveEventMap(value)
	end
	table.insert(self._engineEventConnections, self._engineInterface.SelectionChanged:Connect(onFocusChanged))
end

function FocusNavigationService:_cancelHandler(p, p2)
	if p2 ~= "blur" and p2 ~= "focus" then
		self._eventPropagationService:propagateEvent(
			p,
			p2,
			{
				KeyCode = Enum.KeyCode.None,
				UserInputType = Enum.UserInputType.None,
				UserInputState = Enum.UserInputState.Cancel
			},
			{ synthetic = false, silent = false }
		)
	end
end

function FocusNavigationService:_updateActiveEventMap(p)
	local v = {}
	local selection = self._engineInterface.getSelection()

	if selection then
		local ancestors = getAncestors(selection)

		local v2 = {}

		for i = #ancestors, 1, -1 do
			local ancestor = ancestors[i]
			local event = self._eventMapByInstance[ancestor]

			if event then
				for k, v3 in event do
					v2[k] = v3

					v[k] = nil
				end
			end

			local registeredEventHandlers = self._eventPropagationService:getRegisteredEventHandlers(ancestor)

			if not registeredEventHandlers then
				continue
			end

			for k, v3 in v2 do
				if registeredEventHandlers[v3] then
					v[k] = v3
				end
			end
		end
	end

	local value = self.activeEventMap:getValue()

	if not shallowEqual(value, v) then
		if p then
			for k, v2 in value do
				if not v[k] then
					self:_cancelHandler(p, v2)
				end
			end
		end

		self._fireActiveEventMapSignal(v)
	end
end

function FocusNavigationService:registerEventMap(p, items)
	local v = self._eventMapByInstance[p] or {}

	for k, item in items do
		if v[k] and v[k] ~= item and _G.__DEV__ then
			mockableWarn(string.format(
				"New event will replace existing registered event mapped to %s:\n\t     new event: %s\n\texisting event: %s",
				tostring(k),
				item,
				v[k]
			))
		end

		v[k] = item
	end

	self._eventMapByInstance[p] = v
	self:_updateActiveEventMap()
end

function FocusNavigationService:deregisterEventMap(p, items)
	local v = self._eventMapByInstance[p] or {}

	for k, item in items do
		if v[k] == item then
			v[k] = nil
		elseif _G.__DEV__ then
			mockableWarn(string.format(
				"Cannot deregister non-matching event input %s:\n\t  provided event: %s\n\tregistered event: %s",
				tostring(k),
				item,
				v[k]
			))
		end
	end

	self._eventMapByInstance[p] = v
	self:_updateActiveEventMap(self.focusedGuiObject:getValue())
end

function FocusNavigationService:registerEventHandler(p, p2: string, callback, p3)
	self._eventPropagationService:registerEventHandler(p, p2, callback, p3)
	self:_updateActiveEventMap()
end

function FocusNavigationService:deregisterEventHandler(p, p2: string, callback, p3)
	self:_cancelHandler(p, p2)
	self._eventPropagationService:deregisterEventHandler(p, p2, callback, p3)
	self:_updateActiveEventMap(self.focusedGuiObject:getValue())
end

function FocusNavigationService:registerEventHandlers(p, p2)
	self._eventPropagationService:registerEventHandlers(p, p2)
	self:_updateActiveEventMap()
end

function FocusNavigationService:deregisterEventHandlers(p, items)
	for k, _ in items do
		self:_cancelHandler(p, k)
	end

	self._eventPropagationService:deregisterEventHandlers(p, items)
	self:_updateActiveEventMap(self.focusedGuiObject:getValue())
end

function FocusNavigationService:registerFocusBehavior(ancestor, behavior)
	if _G.__DEV__ then
		local v = self._focusBehaviorByInstance[ancestor]

		if v ~= nil then
			mockableWarn(string.format(
				"New focus behavior will replace existing registered focus behavior:\n\t     new behavior: %s\n\texisting behavior: %s",
				tostring(behavior),
				(tostring(v.behavior))
			))
		end
	end

	local v = {
		behavior = behavior,
		connection = ancestor.SelectionChanged:Connect(function(p, instance, instance2)
			if instance2 and (p or instance2:IsDescendantOf(ancestor)) then
				if instance and instance:IsDescendantOf(ancestor) then
					if behavior.onDescendantFocusChanged then
						behavior.onDescendantFocusChanged(instance2)
					end
				else
					local v = false
					local v2

					if getFFlag() then
						v2 = self._shouldSuppressContainerRefocus and self._shouldSuppressContainerRefocus()
					else
						v2 = false
					end

					if not v2 then
						for _, v3 in behavior.getTargets() do
							if isValidFocusTarget(v3) then
								self:focusGuiObject(v3, false)
								v = true
								break
							end
						end
					end

					if not v and behavior.onDescendantFocusChanged then
						behavior.onDescendantFocusChanged(instance2)
					end
				end
			end
		end)
	}

	self._focusBehaviorByInstance[ancestor] = v
end

function FocusNavigationService:deregisterFocusBehavior(p, p2)
	local v = self._focusBehaviorByInstance[p]

	if _G.__DEV__ then
		if not v then
			mockableWarn(string.format(
				"Cannot deregister an unregistered focus behavior:\n\t  provided behavior: %s",
				(tostring(p2))
			))
		end

		if v and v.behavior ~= p2 then
			mockableWarn(string.format(
				"Cannot deregister non-matching focus behavior:\n\t  provided behavior: %s\n\tregistered behavior: %s",
				tostring(p2),
				(tostring(v.behavior))
			))
		end
	end

	if v then
		v.connection:Disconnect()
		self._focusBehaviorByInstance[p] = nil
	end
end

function FocusNavigationService:focusGuiObject(silentFocusTarget, flag: boolean)
	if flag then
		self._silentBlurTarget = self._engineInterface.getSelection()
		self._silentFocusTarget = silentFocusTarget
	else
		self._silentBlurTarget = nil
		self._silentFocusTarget = nil
	end

	self._engineInterface.setSelection(silentFocusTarget)
end

function FocusNavigationService:teardown()
	for _, engineEventConnection in self._engineEventConnections do
		engineEventConnection:Disconnect()
	end

	for _, v in self._focusBehaviorByInstance do
		v.connection:Disconnect()
	end
end

function FocusNavigationService:canDispatchEvent(p: string, p2): boolean
	if not p2 then
		return false
	end

	local ancestors = getAncestors(p2)

	for _, ancestor in ancestors do
		local event = self._eventMapByInstance[ancestor]

		if not event then
			continue
		end

		for _, v in event do
			if v ~= p then
				continue
			end

			local registeredEventHandlers = self._eventPropagationService:getRegisteredEventHandlers(ancestor)

			if registeredEventHandlers and registeredEventHandlers[p] then
				return true
			end
		end
	end

	return false
end

function FocusNavigationService:dispatchSyntheticEvent(eventName: string, target, eventData): boolean
	if target then
		if self:canDispatchEvent(eventName, target) then
			self._eventPropagationService:propagateEvent(target, eventName, eventData, {
				synthetic = true,
				silent = false
			})

			self._fireEventDispatchedSignal({
				eventName = eventName,
				target = target,
				eventData = eventData,
				synthetic = true
			})

			return true
		end

		if _G.__DEV__ then
			mockableWarn("dispatchSyntheticEvent: Cannot dispatch event \"" .. eventName .. "\" on target")
		end

		return false
	end

	if _G.__DEV__ then
		mockableWarn("dispatchSyntheticEvent: No target object")
	end

	return false
end

return FocusNavigationService
