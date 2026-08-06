local HttpService = game:GetService("HttpService")
local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local Dash = require(FoundationParent.Dash)
local filter = Dash.filter
local values = Dash.values
local Flags = require(Foundation.Utility.Flags)
local StudioUri = require(Foundation.Utility.Plugin.StudioUri)
local Logger = require(Foundation.Utility.Logger)
local t1 = {}

t1.__index = t1

function t1.new(t2: {[any]: any}) -- line: 54
	-- upvalues: t1 (copy)
	local self = setmetatable({}, t1)

	self._widgetsApi = t2
	self._pendingRegisters = {}
	self._pendingDeregisters = {}
	self._registeredWidgets = {}
	self._signals = {}
	self._deferredAncestrySignals = {}
	self._running = false

	return self
end
function t1.nextId(_) -- line: 70
	-- upvalues: HttpService (copy)
	return HttpService:GenerateGUID(false)
end
function t1.flush(p2) -- line: 74
	-- upvalues: Flags (copy)
	if Flags.FoundationWidgetManagerSnapshotFlush then
		local _pendingDeregisters = p2._pendingDeregisters
		local _pendingRegisters = p2._pendingRegisters

		p2._pendingDeregisters = {}
		p2._pendingRegisters = {}
		p2:_flushWith(_pendingDeregisters, _pendingRegisters)

		return
	end

	p2:_flushWith(p2._pendingDeregisters, p2._pendingRegisters)
	p2._pendingDeregisters = {}
	p2._pendingRegisters = {}
end
function t1._flushWith(p3, t3: {[any]: any}, t4: {[any]: any}) -- line: 89
	-- upvalues: Flags (copy), filter (copy), values (copy), StudioUri (copy)
	local t5 = {}

	for v21, v22 in t3 do
		table.insert(t5, v22)
		p3._registeredWidgets[v21] = nil
	end

	if #t5 > 0 then
		pcall(function() -- line: 100
			-- upvalues: p3 (copy), t5 (copy)
			p3._widgetsApi:DeregisterAsync(t5)
		end)
	end

	local v23 = if not Flags.FoundationWidgetManagerSnapshotFlush then nil else {}
	local v24 = filter(values(t4), function(p4) -- line: 106
		-- upvalues: Flags (copy), v23 (copy)
		local v53 = p4.Widget:FindFirstAncestorWhichIsA("LayerCollector") ~= nil

		if Flags.FoundationWidgetManagerSnapshotFlush and not v53 then
			table.insert(v23, p4)
		end

		return v53
	end)

	if Flags.FoundationWidgetManagerSnapshotFlush then
		for _, v26 in v23 do
			local v27 = StudioUri.toString(v26.Uri)

			if not p3._deferredAncestrySignals[v27] then
				p3._deferredAncestrySignals[v27] = v26.Widget.AncestryChanged:Connect(function(_, parent) -- line: 118
					-- upvalues: p3 (copy), v27 (copy), v26 (copy)
					if parent == nil then
						local v56 = p3._deferredAncestrySignals[v27]

						if v56 then
							v56:Disconnect()
							p3._deferredAncestrySignals[v27] = nil
						end

						return
					end

					if v26.Widget:FindFirstAncestorWhichIsA("LayerCollector") then
						local v57 = p3._deferredAncestrySignals[v27]

						if v57 then
							v57:Disconnect()
							p3._deferredAncestrySignals[v27] = nil
						end

						p3:register(v26.Uri, v26.Widget)
					end
				end)
			end
		end
	end

	local t6 = {}

	for _, v30 in v24 do
		v30.Position = v30.Widget.AbsolutePosition
		v30.Size = v30.Widget.AbsoluteSize
		v30.Visible = v30.Widget:GetStyled("Visible")

		local v31 = StudioUri.toString(v30.Uri)
		local DEPRECATED_PluginGui = v30.DEPRECATED_PluginGui
		local v33 = p3._signals[v31]

		if v33 then
			if v33.Widget == v30.Widget then
				if Flags.FoundationPopoverPluginOverlayMeasurement and DEPRECATED_PluginGui ~= v33.Host then
					v33.Host = DEPRECATED_PluginGui
					table.insert(t6, v30.Uri)
				end

				continue
			end

			v33.PositionChanged:Disconnect()
			v33.SizeChanged:Disconnect()
			v33.VisibleChanged:Disconnect()
			v33.AncestryChanged:Disconnect()
		end

		p3._signals[v31] = {
			Widget = v30.Widget,
			Host = if not Flags.FoundationPopoverPluginOverlayMeasurement then nil else DEPRECATED_PluginGui,
			PositionChanged = v30.Widget:GetPropertyChangedSignal("AbsolutePosition"):Connect(function() -- line: 167
				-- upvalues: p3 (copy), v30 (copy)
				p3:register(v30.Uri, v30.Widget)
			end),
			SizeChanged = v30.Widget:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 170
				-- upvalues: p3 (copy), v30 (copy)
				p3:register(v30.Uri, v30.Widget)
			end),
			VisibleChanged = v30.Widget:GetStyledPropertyChangedSignal("Visible"):Connect(function() -- line: 173
				-- upvalues: p3 (copy), v30 (copy)
				p3:register(v30.Uri, v30.Widget)
			end),
			AncestryChanged = v30.Widget.AncestryChanged:Connect(function(_, parent) -- line: 176
				-- upvalues: p3 (copy), v30 (copy)
				if not parent then
					p3:deregister(v30.Uri)
				end
			end)
		}
	end

	if Flags.FoundationPopoverPluginOverlayMeasurement and #t6 > 0 then
		pcall(function() -- line: 185
			-- upvalues: p3 (copy), t6 (copy)
			p3._widgetsApi:DeregisterAsync(t6)
		end)
	end

	if #v24 > 0 then
		p3._widgetsApi:RegisterAsync(v24)
	end
end
function t1._run(p7) -- line: 195
	if p7._running then
		return
	end

	p7._running = true
	task.defer(function() -- line: 200
		-- upvalues: p7 (copy)
		p7._running = false
		p7:flush()
	end)
end
function t1.register(p8, p9, p10) -- line: 210
	-- upvalues: StudioUri (copy), Flags (copy)
	local v38 = p10:FindFirstAncestorWhichIsA("PluginGui") or p10:FindFirstAncestorWhichIsA("ScreenGui")

	if v38 then
		local v39 = StudioUri.toString(p9)

		if Flags.FoundationWidgetManagerSnapshotFlush then
			local v40 = p8._deferredAncestrySignals[v39]

			if v40 then
				v40:Disconnect()
				p8._deferredAncestrySignals[v39] = nil
			end
		end

		p8._registeredWidgets[v39] = p10
		p8._pendingRegisters[v39] = {
			Uri = p9,
			Widget = p10,
			DEPRECATED_PluginGui = v38
		}
		p8._pendingDeregisters[v39] = nil
		p8:_run()
	end
end
function t1.deregister(p11, p12, p13) -- line: 231
	-- upvalues: StudioUri (copy), Flags (copy), Logger (copy)
	local v44 = StudioUri.toString(p12)

	p11._pendingDeregisters[v44] = p12

	if Flags.FoundationWidgetManagerSnapshotFlush then
		p11._pendingRegisters[v44] = nil

		local v45 = p11._deferredAncestrySignals[v44]

		if v45 then
			v45:Disconnect()
			p11._deferredAncestrySignals[v44] = nil
		end
	end

	local v46 = p11._signals[v44]

	if v46 then
		if p13 == nil or p13 == v46.Widget then
			v46.PositionChanged:Disconnect()
			v46.SizeChanged:Disconnect()
			v46.VisibleChanged:Disconnect()
			v46.AncestryChanged:Disconnect()
			p11._signals[v44] = nil
		else
			Logger:warning(`WidgetManager:deregister called with mismatched widget for uri { v44 }`)
		end
	end

	p11:_run()
end
function t1.destroy(p14) -- line: 257
	-- upvalues: Flags (copy)
	for _, v49 in p14._signals do
		v49.PositionChanged:Disconnect()
		v49.SizeChanged:Disconnect()
		v49.VisibleChanged:Disconnect()
		v49.AncestryChanged:Disconnect()
	end

	if Flags.FoundationWidgetManagerSnapshotFlush then
		for _, v51 in p14._deferredAncestrySignals do
			v51:Disconnect()
		end

		p14._deferredAncestrySignals = {}
	end

	p14._signals = {}
	p14._pendingRegisters = {}
	p14._pendingDeregisters = {}
	p14._registeredWidgets = {}
end

return t1
