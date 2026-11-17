local HttpService = game:GetService("HttpService")

local Foundation = script:FindFirstAncestor("Foundation")
local Flags = require(Foundation.Utility.Flags)
local StudioUri = require(Foundation.Utility.Plugin.StudioUri)
require(script.Parent.Parent.Types)

local function bindToClose(pluginGui, fn) -- 1 equivalent call inferred from this helper
	if pluginGui:IsA("PluginGui") then
		pluginGui:BindToClose(fn)
	end
end

local function isStrictDescendantOf(p, p2, p3): boolean
	local parentPopoverId = p3.parentPopoverId

	while parentPopoverId do
		if parentPopoverId == p2.id then
			return true
		end

		local v = p[parentPopoverId]

		if not v then
			break
		end

		parentPopoverId = v.parentPopoverId
	end

	return false
end

local PopoverManager = {}
PopoverManager.__index = PopoverManager

function PopoverManager.new(Plugin, uriScope: string?)
	local self = setmetatable({}, PopoverManager)
	self._uriScope = uriScope

	self._plugin = Plugin
	self._panels = Plugin:GetPluginComponent("Panels")
	self._pluginUri = StudioUri.wrap(Plugin:GetUri())

	self._active = {}
	self._pool = {}
	self._didPrewarm = false

	if Flags.FoundationPopoverPluginPoolReclaim then
		self._destroyed = false
	end

	return self
end

function PopoverManager:openAtAsync(data, callback, p: number?, p2: string?, flag: boolean?, vector2: Vector2?)
	local v = p == nil and 0 or p
	local v2

	if Flags.FoundationPopoverPluginFocusable then
		v2 = flag == true
	else
		v2 = false
	end

	local panelAsync = self:_acquirePanelAsync(callback, v, p2, v2)

	panelAsync.panel.Enabled = false

	self._panels:SetAttachmentAsync(panelAsync.uri, {
		TargetWidgetUri = data.targetWidgetUri,
		TargetAnchorPoint = data.targetAnchorPoint,
		SubjectAnchorPoint = data.subjectAnchorPoint,
		Offset = data.offset
	})

	local vector2_2 = nil

	if Flags.FoundationPopoverPluginPoolReclaim then
		local v3 = vector2 or Vector2.new(0, 0)

		vector2_2 = Vector2.new(math.ceil((math.min(3000, v3.X))), (math.ceil((math.min(3000, v3.Y)))))
		self._panels:SetSizeAsync(panelAsync.uri, vector2_2)
	else
		self._panels:SetSizeAsync(panelAsync.uri, Vector2.new(0, 0))
	end

	panelAsync.panel.Enabled = true
	panelAsync.open = true

	if Flags.FoundationPopoverPluginPoolReclaim then
		panelAsync.openingThread = nil
	end

	if not Flags.FoundationPopoverPluginPoolReclaim then
		local generation = panelAsync.generation
		return {
			container = panelAsync.panel,
			popoverId = panelAsync.id,
			setSizeAsync = function(vector2_3: Vector2)
				if panelAsync.generation ~= generation or not panelAsync.open then
					return
				end

				local v3 = math.ceil((math.min(3000, vector2_3.X)))
				local v4 = math.ceil((math.min(3000, vector2_3.Y)))
				self._panels:SetSizeAsync(panelAsync.uri, Vector2.new(v3, v4))
			end,
			updateAsync = function(data2)
				if panelAsync.generation ~= generation or not (panelAsync.open and panelAsync.uri) then
					return
				end

				self._panels:SetAttachmentAsync(panelAsync.uri, {
					TargetWidgetUri = data2.targetWidgetUri,
					TargetAnchorPoint = data2.targetAnchorPoint,
					SubjectAnchorPoint = data2.subjectAnchorPoint,
					Offset = data2.offset
				})
			end,
			close = function()
				self:_closePopover(panelAsync, true, generation)
			end
		}
	end

	local generation = panelAsync.generation
	local v3 = table.clone(data)
	local v4 = vector2_2
	local count = 0
	local count2 = 0
	return {
		container = panelAsync.panel,
		popoverId = panelAsync.id,
		setSizeAsync = function(vector2_3: Vector2)
			if panelAsync.generation ~= generation or not panelAsync.open then
				return
			end

			local vector2_4 = Vector2.new(
				math.ceil((math.min(3000, vector2_3.X))),
				(math.ceil((math.min(3000, vector2_3.Y))))
			)

			if v4 == vector2_4 then
				return
			end

			v4 = nil
			count2 += 1
			local v5 = count2
			self._panels:SetSizeAsync(panelAsync.uri, vector2_4)

			if count2 == v5 then
				v4 = vector2_4
			end
		end,
		updateAsync = function(data2)
			if panelAsync.generation ~= generation or not panelAsync.open then
				return
			end

			if
				v3
				and StudioUri.equals(v3.targetWidgetUri, data2.targetWidgetUri)
				and v3.targetAnchorPoint == data2.targetAnchorPoint
				and v3.subjectAnchorPoint == data2.subjectAnchorPoint
				and v3.offset == data2.offset
			then
				return
			end

			local clone = table.clone(data2)
			v3 = nil
			count += 1
			local v5 = count
			self._panels:SetAttachmentAsync(panelAsync.uri, {
				TargetWidgetUri = clone.targetWidgetUri,
				TargetAnchorPoint = clone.targetAnchorPoint,
				SubjectAnchorPoint = clone.subjectAnchorPoint,
				Offset = clone.offset
			})

			if count == v5 then
				v3 = clone
			end
		end,
		close = function()
			self:_closePopover(panelAsync, true, generation)
		end
	}
end

function PopoverManager:_createPanelAsync(title: string, p: number, focusable: boolean)
	local Plugin = self._plugin
	local v = {
		Id = title,
		InitialEnabled = not Flags.FoundationPopoverPluginPoolReclaim,
		Tooltip = true,
		Focusable = 0,
		Transparent = true,
		Resizable = true,
		Title = 0,
		ZIndex = 0
	}

	if not Flags.FoundationPopoverPluginFocusable then
		focusable = nil
	end

	v.Focusable = focusable

	v.Title = title
	v.ZIndex = p + 200
	local qWidgetPluginGui = Plugin:CreateQWidgetPluginGui(title, v)

	qWidgetPluginGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

	return qWidgetPluginGui, StudioUri.join(self._pluginUri, { Category = "Panels", ItemId = title })
end

function PopoverManager:_makePopoverId()
	return `Popovers{not self._uriScope and "" or `/{self._uriScope}`}/{HttpService:GenerateGUID(false)}`
end

function PopoverManager:_createPopoverAsync(id: string, depth: number, isFocusable: boolean)
	local pluginGui, uri = self:_createPanelAsync(id, depth, isFocusable)

	if Flags.FoundationPopoverPluginPoolReclaim and self._destroyed then
		pluginGui:Destroy()
		error("PopoverManager is destroyed")
	end

	local popoverAsync = {
		id = id,
		uri = uri,
		panel = pluginGui,
		open = false,
		depth = depth,
		isFocusable = isFocusable,
		generation = 0,
		parentPopoverId = nil,
		onClose = nil
	}

	local function fn()
		self:_closePopover(popoverAsync, false, popoverAsync.generation)
	end

	bindToClose(pluginGui, fn) -- inferred equivalent call

	if pluginGui:IsA("PluginGui") then
		pluginGui.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 and popoverAsync.open then
				self:_closeChildPopovers(popoverAsync)
			end
		end)
	end

	return popoverAsync
end

function PopoverManager:_createTrackedPopoverAsync(p: string, p2: number, flag: boolean)
	local thread = coroutine.running()
	local v = false
	local v2 = false
	local success = false
	local result = nil

	task.spawn(function()
		success, result = pcall(self._createPopoverAsync, self, p, p2, flag)
		v = true

		if success then
			local v3 = result
			v3.openingThread = thread
			self._active[p] = v3

			if coroutine.status(thread) == "dead" then
				self:_closePopover(v3, true, v3.generation)
			end
		end

		if v2 and coroutine.status(thread) == "suspended" then
			task.spawn(thread)
		end
	end)

	if not v then
		v2 = true
		coroutine.yield()
	end

	if not success then
		error(result)
	end

	self._active[p] = nil
	result.openingThread = nil
	return result
end

function PopoverManager:_activatePopover(state, onClose, parentPopoverId: string?)
	state.generation += 1
	state.onClose = onClose
	state.parentPopoverId = parentPopoverId
	state.open = false

	if Flags.FoundationPopoverPluginPoolReclaim then
		state.openingThread = coroutine.running()
	end

	self._active[state.id] = state
end

function PopoverManager:_reclaimAbandonedPopovers()
	local v = {}

	for _, v2 in self._active do
		local openingThread = v2.openingThread

		if openingThread and coroutine.status(openingThread) == "dead" then
			table.insert(v, v2)
		end
	end

	for _, v2 in v do
		self:_closePopover(v2, true, v2.generation)
	end
end

function PopoverManager:_tryAcquireFromPool(callback, p: number, p2: string?, flag: boolean)
	local v = self._pool[p]
	local v2 = nil

	if Flags.FoundationPopoverPluginFocusable then
		if v then
			for i = #v, 1, -1 do
				if v[i].isFocusable == flag then
					v2 = table.remove(v, i)
					break
				end
			end
		end
	elseif v then
		v2 = table.remove(v)
	end

	if not v2 then
		return nil
	end

	self:_activatePopover(v2, callback, p2)
	return v2
end

function PopoverManager:_acquirePanelAsync(callback, p: number, p2: string?, flag: boolean)
	if Flags.FoundationPopoverPluginPoolReclaim then
		if self._destroyed then
			error("PopoverManager is destroyed")
		end

		self:_reclaimAbandonedPopovers()
	end

	local v = self:_tryAcquireFromPool(callback, p, p2, flag)

	if v then
		return v
	end

	local popoverId = self:_makePopoverId()
	local selected

	if Flags.FoundationPopoverPluginPoolReclaim then
		selected = self:_createTrackedPopoverAsync(popoverId, p, flag)
	else
		selected = self:_createPopoverAsync(popoverId, p, flag)
	end

	self:_activatePopover(selected, callback, p2)
	return selected
end

function PopoverManager:prewarmPoolAsync(p: number)
	if Flags.FoundationPopoverPluginPoolReclaim and self._destroyed or self._didPrewarm then
		return
	end

	for i = 0, math.max(0, p) do
		if self._pool[i] == nil then
			self._pool[i] = {}
		end

		local v = self._pool[i]

		if #v ~= 0 then
			continue
		end

		local v2

		if Flags.FoundationPopoverPluginPoolReclaim then
			v2 = self:_createTrackedPopoverAsync(self:_makePopoverId(), i, false)
		else
			v2 = self:_createPopoverAsync(self:_makePopoverId(), i, false)
		end

		v2.panel.Enabled = false
		table.insert(v, v2)
	end

	self._didPrewarm = true
end

function PopoverManager:_closeChildPopovers(p)
	local v = {}

	for _, v2 in self._active do
		if not (v2.open and v2.id ~= p.id) then
			continue
		end

		local active = self._active
		local parentPopoverId = v2.parentPopoverId
		local flag

		while true do
			if not parentPopoverId then
				flag = false
				break
			end

			if parentPopoverId == p.id then
				flag = true
				break
			end

			local v3 = active[parentPopoverId]

			if v3 then
				parentPopoverId = v3.parentPopoverId
			else
				flag = false
				break
			end
		end

		if flag then
			table.insert(v, v2)
		end
	end

	for _, v2 in v do
		self:_closePopover(v2)
	end
end

function PopoverManager:_closePopover(state, flag: boolean?, p: number?)
	if p ~= nil and state.generation ~= p then
		return
	end

	if Flags.FoundationPopoverPluginPoolReclaim then
		if self._active[state.id] ~= state then
			return
		end

		local openingThread = state.openingThread

		if openingThread then
			if coroutine.status(openingThread) == "suspended" then
				task.cancel(openingThread)
			end

			state.openingThread = nil
		end

		state.open = false
		state.panel.Enabled = false
		self._active[state.id] = nil
		local onClose = state.onClose
		state.onClose = nil
		local depth = state.depth

		if not self._pool[depth] then
			self._pool[depth] = {}
		end

		table.insert(self._pool[depth], state)

		if not flag and onClose then
			onClose()
		end
	else
		if not state.open then
			return
		end

		state.open = false
		state.panel.Enabled = false

		if not flag and state.onClose then
			state.onClose()
		end

		self._active[state.id] = nil

		local depth = state.depth

		if not self._pool[depth] then
			self._pool[depth] = {}
		end

		table.insert(self._pool[depth], state)
	end
end

function PopoverManager:closeAll()
	local v = {}

	for _, v2 in self._active do
		table.insert(v, v2)
	end

	for _, v2 in v do
		self:_closePopover(v2)
	end
end

function PopoverManager:destroy()
	if Flags.FoundationPopoverPluginPoolReclaim then
		self._destroyed = true
		self:_reclaimAbandonedPopovers()
	end

	self:closeAll()

	for _, v in self._pool do
		for _, v2 in v do
			if v2.panel then
				v2.panel:Destroy()
			end
		end
	end

	self._pool = {}
end

return PopoverManager
