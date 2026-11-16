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

	return self
end

function PopoverManager:openAtAsync(data, callback, p: number?, p2: string?, flag: boolean?)
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

	self._panels:SetSizeAsync(panelAsync.uri, Vector2.new(0, 0))

	panelAsync.panel.Enabled = true
	panelAsync.open = true

	if not Flags.FoundationPopoverPluginOverlayMeasurement then
		return {
			container = panelAsync.panel,
			popoverId = panelAsync.id,
			setSizeAsync = function(vector2: Vector2)
				local v3 = math.ceil((math.min(3000, vector2.X)))
				local v4 = math.ceil((math.min(3000, vector2.Y)))
				self._panels:SetSizeAsync(panelAsync.uri, Vector2.new(v3, v4))
			end,
			updateAsync = function(data2)
				if not panelAsync.uri then
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
				self:_closePopover(panelAsync, true)
			end
		}
	end

	local generation = panelAsync.generation
	return {
		container = panelAsync.panel,
		popoverId = panelAsync.id,
		setSizeAsync = function(vector2: Vector2)
			if panelAsync.generation ~= generation or not panelAsync.open then
				return
			end

			local v3 = math.ceil((math.min(3000, vector2.X)))
			local v4 = math.ceil((math.min(3000, vector2.Y)))
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

function PopoverManager:_createPanelAsync(title: string, p: number, focusable: boolean)
	local Plugin = self._plugin

	if not Flags.FoundationPopoverPluginFocusable then
		focusable = nil
	end

	local qWidgetPluginGui = Plugin:CreateQWidgetPluginGui(title, {
		Id = title,
		InitialEnabled = true,
		Tooltip = true,
		Focusable = focusable,
		Transparent = true,
		Resizable = true,
		Title = title,
		ZIndex = p + 200
	})

	qWidgetPluginGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

	return qWidgetPluginGui, StudioUri.join(self._pluginUri, { Category = "Panels", ItemId = title })
end

function PopoverManager:_makePopoverId()
	return `Popovers{not self._uriScope and "" or `/{self._uriScope}`}/{HttpService:GenerateGUID(false)}`
end

function PopoverManager:_createPopoverAsync(id: string, depth: number, isFocusable: boolean)
	local pluginGui, uri = self:_createPanelAsync(id, depth, isFocusable)
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
		if Flags.FoundationPopoverPluginOverlayMeasurement then
			self:_closePopover(popoverAsync, false, popoverAsync.generation)
		else
			self:_closePopover(popoverAsync)
		end
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

function PopoverManager:_activatePopover(state, onClose, parentPopoverId: string?)
	if Flags.FoundationPopoverPluginOverlayMeasurement then
		state.generation += 1
	end

	state.onClose = onClose
	state.parentPopoverId = parentPopoverId
	state.open = false
	self._active[state.id] = state
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
	local v = self:_tryAcquireFromPool(callback, p, p2, flag)

	if v then
		return v
	end

	local popoverAsync = self:_createPopoverAsync(self:_makePopoverId(), p, flag)
	self:_activatePopover(popoverAsync, callback, p2)
	return popoverAsync
end

function PopoverManager:prewarmPoolAsync(p: number)
	if self._didPrewarm then
		return
	end

	for i = 0, math.max(0, p) do
		if self._pool[i] == nil then
			self._pool[i] = {}
		end

		local popoverAsyncs = self._pool[i]

		if #popoverAsyncs ~= 0 then
			continue
		end

		local popoverAsync = self:_createPopoverAsync(self:_makePopoverId(), i, false)
		popoverAsync.panel.Enabled = false
		table.insert(popoverAsyncs, popoverAsync)
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
	if Flags.FoundationPopoverPluginOverlayMeasurement and p ~= nil and state.generation ~= p or not state.open then
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
