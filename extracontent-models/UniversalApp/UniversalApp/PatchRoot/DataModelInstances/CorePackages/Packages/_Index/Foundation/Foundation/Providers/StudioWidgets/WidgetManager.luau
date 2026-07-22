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
	self._running = false

	return self
end
function t1.nextId(_) -- line: 69
	-- upvalues: HttpService (copy)
	return HttpService:GenerateGUID(false)
end
function t1.flush(p2) -- line: 73
	-- upvalues: filter (copy), values (copy), StudioUri (copy), Flags (copy)
	local t3 = {}

	for v16, v17 in p2._pendingDeregisters do
		table.insert(t3, v17)
		p2._registeredWidgets[v16] = nil
	end

	if #t3 > 0 then
		pcall(function() -- line: 80
			-- upvalues: p2 (copy), t3 (copy)
			p2._widgetsApi:DeregisterAsync(t3)
		end)
	end

	p2._pendingDeregisters = {}

	local v18 = filter(values(p2._pendingRegisters), function(p3) -- line: 86
		return p3.Widget:FindFirstAncestorWhichIsA("LayerCollector") ~= nil
	end)
	local t4 = {}

	for _, v21 in v18 do
		v21.Position = v21.Widget.AbsolutePosition
		v21.Size = v21.Widget.AbsoluteSize
		v21.Visible = v21.Widget:GetStyled("Visible")

		local v22 = StudioUri.toString(v21.Uri)
		local DEPRECATED_PluginGui = v21.DEPRECATED_PluginGui
		local v24 = p2._signals[v22]

		if v24 then
			if v24.Widget == v21.Widget then
				if Flags.FoundationPopoverPluginOverlayMeasurement and DEPRECATED_PluginGui ~= v24.Host then
					v24.Host = DEPRECATED_PluginGui
					table.insert(t4, v21.Uri)
				end

				continue
			end

			v24.PositionChanged:Disconnect()
			v24.SizeChanged:Disconnect()
			v24.VisibleChanged:Disconnect()
			v24.AncestryChanged:Disconnect()
		end

		p2._signals[v22] = {
			Widget = v21.Widget,
			Host = if not Flags.FoundationPopoverPluginOverlayMeasurement then nil else DEPRECATED_PluginGui,
			PositionChanged = v21.Widget:GetPropertyChangedSignal("AbsolutePosition"):Connect(function() -- line: 116
				-- upvalues: p2 (copy), v21 (copy)
				p2:register(v21.Uri, v21.Widget)
			end),
			SizeChanged = v21.Widget:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 119
				-- upvalues: p2 (copy), v21 (copy)
				p2:register(v21.Uri, v21.Widget)
			end),
			VisibleChanged = v21.Widget:GetStyledPropertyChangedSignal("Visible"):Connect(function() -- line: 122
				-- upvalues: p2 (copy), v21 (copy)
				p2:register(v21.Uri, v21.Widget)
			end),
			AncestryChanged = v21.Widget.AncestryChanged:Connect(function(_, parent) -- line: 125
				-- upvalues: p2 (copy), v21 (copy)
				if not parent then
					p2:deregister(v21.Uri)
				end
			end)
		}
	end

	if Flags.FoundationPopoverPluginOverlayMeasurement and #t4 > 0 then
		pcall(function() -- line: 134
			-- upvalues: p2 (copy), t4 (copy)
			p2._widgetsApi:DeregisterAsync(t4)
		end)
	end

	if #v18 > 0 then
		p2._widgetsApi:RegisterAsync(v18)
	end

	p2._pendingRegisters = {}
end
function t1._run(p5) -- line: 145
	if p5._running then
		return
	end

	p5._running = true
	task.defer(function() -- line: 150
		-- upvalues: p5 (copy)
		p5._running = false
		p5:flush()
	end)
end
function t1.register(p6, p7, p8) -- line: 160
	-- upvalues: StudioUri (copy)
	local v29 = p8:FindFirstAncestorWhichIsA("PluginGui") or p8:FindFirstAncestorWhichIsA("ScreenGui")

	if v29 then
		local v30 = StudioUri.toString(p7)

		p6._registeredWidgets[v30] = p8
		p6._pendingRegisters[v30] = {
			Uri = p7,
			Widget = p8,
			DEPRECATED_PluginGui = v29
		}
		p6._pendingDeregisters[v30] = nil
		p6:_run()
	end
end
function t1.deregister(p9, p10, p11) -- line: 174
	-- upvalues: StudioUri (copy), Logger (copy)
	local v34 = StudioUri.toString(p10)

	p9._pendingDeregisters[v34] = p10

	local v35 = p9._signals[v34]

	if v35 then
		if p11 == nil or p11 == v35.Widget then
			v35.PositionChanged:Disconnect()
			v35.SizeChanged:Disconnect()
			v35.VisibleChanged:Disconnect()
			v35.AncestryChanged:Disconnect()
			p9._signals[v34] = nil
		else
			Logger:warning(`WidgetManager:deregister called with mismatched widget for uri { v34 }`)
		end
	end

	p9:_run()
end
function t1.destroy(p12) -- line: 192
	for _, v38 in p12._signals do
		v38.PositionChanged:Disconnect()
		v38.SizeChanged:Disconnect()
		v38.VisibleChanged:Disconnect()
		v38.AncestryChanged:Disconnect()
	end

	p12._signals = {}
	p12._pendingRegisters = {}
	p12._pendingDeregisters = {}
	p12._registeredWidgets = {}
end

return t1
