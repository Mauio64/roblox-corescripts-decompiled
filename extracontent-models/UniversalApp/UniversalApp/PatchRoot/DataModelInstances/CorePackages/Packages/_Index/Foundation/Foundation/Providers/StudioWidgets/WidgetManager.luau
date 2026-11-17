local HttpService = game:GetService("HttpService")

local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local Dash = require(parent.Dash)
local filter = Dash.filter
local values = Dash.values

local Flags = require(Foundation.Utility.Flags)
local StudioUri = require(Foundation.Utility.Plugin.StudioUri)

local Logger = require(Foundation.Utility.Logger)

local WidgetManager = {}
WidgetManager.__index = WidgetManager

function WidgetManager.new(widgetsApi)
	local self = setmetatable({}, WidgetManager)

	self._widgetsApi = widgetsApi
	self._pendingRegisters = {}
	self._pendingDeregisters = {}
	self._registeredWidgets = {}
	self._signals = {}
	self._deferredAncestrySignals = {}
	self._running = false

	return self
end

local function getWidgetHost(instance)
	local pluginGui = instance:FindFirstAncestorWhichIsA("PluginGui")

	if pluginGui then
		return pluginGui
	end

	return instance:FindFirstAncestorWhichIsA("ScreenGui")
end

local function makeRegistration(uri, registeredWidget, pluginGui) -- 1 equivalent call inferred from this helper
	return {
		Uri = uri,
		Widget = registeredWidget,
		DEPRECATED_PluginGui = pluginGui,
		Position = registeredWidget.AbsolutePosition,
		Size = registeredWidget.AbsoluteSize,
		Visible = registeredWidget:GetStyled("Visible")
	}
end

function WidgetManager.nextId(_)
	return HttpService:GenerateGUID(false)
end

function WidgetManager:flush()
	if Flags.FoundationWidgetManagerSnapshotFlush then
		local pendingDeregisters = self._pendingDeregisters
		local pendingRegisters = self._pendingRegisters
		self._pendingDeregisters = {}
		self._pendingRegisters = {}

		self:_flushWith(pendingDeregisters, pendingRegisters)
	else
		self:_flushWith(self._pendingDeregisters, self._pendingRegisters)
		self._pendingDeregisters = {}
		self._pendingRegisters = {}
	end
end

function WidgetManager:_flushWith(items, p)
	local v = {}

	for k, item in items do
		table.insert(v, item)
		self._registeredWidgets[k] = nil
	end

	if #v > 0 then
		pcall(function()
			self._widgetsApi:DeregisterAsync(v)
		end)
	end

	local v2 = Flags.FoundationWidgetManagerSnapshotFlush and {} or nil
	local filtered = filter(values(p), function(p2)
		local v3 = p2.Widget:FindFirstAncestorWhichIsA("LayerCollector") ~= nil

		if Flags.FoundationWidgetManagerSnapshotFlush and not v3 then
			table.insert(v2, p2)
		end

		return v3
	end)

	if Flags.FoundationWidgetManagerSnapshotFlush then
		for _, v3 in v2 do
			local str = StudioUri.toString(v3.Uri)

			if not self._deferredAncestrySignals[str] then
				self._deferredAncestrySignals[str] = v3.Widget.AncestryChanged:Connect(function(_, parent2)
					if parent2 == nil then
						local deferredAncestrySignal = self._deferredAncestrySignals[str]

						if deferredAncestrySignal then
							deferredAncestrySignal:Disconnect()
							self._deferredAncestrySignals[str] = nil
						end
					elseif v3.Widget:FindFirstAncestorWhichIsA("LayerCollector") then
						local deferredAncestrySignal = self._deferredAncestrySignals[str]

						if deferredAncestrySignal then
							deferredAncestrySignal:Disconnect()
							self._deferredAncestrySignals[str] = nil
						end

						self:register(v3.Uri, v3.Widget)
					end
				end)
			end
		end
	end

	local uris = {}

	for _, v3 in filtered do
		v3.Position = v3.Widget.AbsolutePosition
		v3.Size = v3.Widget.AbsoluteSize
		v3.Visible = v3.Widget:GetStyled("Visible")
		local str = StudioUri.toString(v3.Uri)
		local DEPRECATED_PluginGui = v3.DEPRECATED_PluginGui

		local signal = self._signals[str]

		if signal then
			if signal.Widget == v3.Widget then
				if signal.Host ~= DEPRECATED_PluginGui then
					signal.Host = DEPRECATED_PluginGui
					table.insert(uris, v3.Uri)
				end

				continue
			end

			signal.PositionChanged:Disconnect()
			signal.SizeChanged:Disconnect()
			signal.VisibleChanged:Disconnect()
			signal.AncestryChanged:Disconnect()
		end

		self._signals[str] = {
			Widget = v3.Widget,
			Host = DEPRECATED_PluginGui,
			PositionChanged = v3.Widget:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
				self:register(v3.Uri, v3.Widget)
			end),
			SizeChanged = v3.Widget:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
				self:register(v3.Uri, v3.Widget)
			end),
			VisibleChanged = v3.Widget:GetStyledPropertyChangedSignal("Visible"):Connect(function()
				self:register(v3.Uri, v3.Widget)
			end),
			AncestryChanged = v3.Widget.AncestryChanged:Connect(function(_, parent2)
				if not parent2 then
					self:deregister(v3.Uri)
				end
			end)
		}
	end

	if #uris > 0 then
		pcall(function()
			self._widgetsApi:DeregisterAsync(uris)
		end)
	end

	if #filtered > 0 then
		self._widgetsApi:RegisterAsync(filtered)
	end
end

function WidgetManager:_run()
	if self._running then
		return
	end

	self._running = true
	task.defer(function()
		self._running = false
		self:flush()
	end)
end

function WidgetManager:register(uri, instance)
	local pluginGui = instance:FindFirstAncestorWhichIsA("PluginGui") or instance:FindFirstAncestorWhichIsA("ScreenGui")

	if pluginGui then
		local str = StudioUri.toString(uri)
		local connection = Flags.FoundationWidgetManagerSnapshotFlush and self._deferredAncestrySignals[str]

		if connection then
			connection:Disconnect()
			self._deferredAncestrySignals[str] = nil
		end

		self._registeredWidgets[str] = instance
		self._pendingRegisters[str] = {
			Uri = uri,
			Widget = instance,
			DEPRECATED_PluginGui = pluginGui
		}
		self._pendingDeregisters[str] = nil
		self:_run()
	end
end

function WidgetManager:refreshAsync(uri): boolean
	local str = StudioUri.toString(uri)
	local registeredWidget = self._registeredWidgets[str]

	if not registeredWidget then
		return false
	end

	local pluginGui = registeredWidget:FindFirstAncestorWhichIsA("PluginGui")
		or registeredWidget:FindFirstAncestorWhichIsA("ScreenGui")

	if not pluginGui then
		return false
	end

	self._widgetsApi:RegisterAsync({ makeRegistration(uri, registeredWidget, pluginGui) }) -- inferred equivalent call
	return true
end

function WidgetManager:deregister(p, p2)
	local str = StudioUri.toString(p)
	self._pendingDeregisters[str] = p

	if Flags.FoundationWidgetManagerSnapshotFlush then
		self._pendingRegisters[str] = nil
		local deferredAncestrySignal = self._deferredAncestrySignals[str]

		if deferredAncestrySignal then
			deferredAncestrySignal:Disconnect()
			self._deferredAncestrySignals[str] = nil
		end
	end

	local signal = self._signals[str]

	if signal then
		if p2 == nil or signal.Widget == p2 then
			signal.PositionChanged:Disconnect()
			signal.SizeChanged:Disconnect()
			signal.VisibleChanged:Disconnect()
			signal.AncestryChanged:Disconnect()
			self._signals[str] = nil
		else
			Logger:warning(`WidgetManager:deregister called with mismatched widget for uri {str}`)
		end
	end

	self:_run()
end

function WidgetManager:destroy()
	for _, signal in self._signals do
		signal.PositionChanged:Disconnect()
		signal.SizeChanged:Disconnect()
		signal.VisibleChanged:Disconnect()
		signal.AncestryChanged:Disconnect()
	end

	if Flags.FoundationWidgetManagerSnapshotFlush then
		for _, deferredAncestrySignal in self._deferredAncestrySignals do
			deferredAncestrySignal:Disconnect()
		end

		self._deferredAncestrySignals = {}
	end

	self._signals = {}
	self._pendingRegisters = {}
	self._pendingDeregisters = {}
	self._registeredWidgets = {}
end

return WidgetManager
