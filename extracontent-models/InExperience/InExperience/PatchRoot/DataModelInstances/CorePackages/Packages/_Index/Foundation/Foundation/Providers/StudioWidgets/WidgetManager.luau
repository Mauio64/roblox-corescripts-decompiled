local HttpService = game:GetService("HttpService")
local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local Dash = require(FoundationParent.Dash)
local filter = Dash.filter
local values = Dash.values
local StudioUri = require(Foundation.Utility.Plugin.StudioUri)
local Logger = require(Foundation.Utility.Logger)
local t1 = {}

t1.__index = t1

function t1.new(t2: {[any]: any}) -- line: 52
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
function t1.nextId(_) -- line: 67
	-- upvalues: HttpService (copy)
	return HttpService:GenerateGUID(false)
end
function t1.flush(p2) -- line: 71
	-- upvalues: filter (copy), values (copy), StudioUri (copy)
	local t3 = {}

	for v15, v16 in p2._pendingDeregisters do
		table.insert(t3, v16)
		p2._registeredWidgets[v15] = nil
	end

	if #t3 > 0 then
		pcall(function() -- line: 78
			-- upvalues: p2 (copy), t3 (copy)
			p2._widgetsApi:DeregisterAsync(t3)
		end)
	end

	p2._pendingDeregisters = {}

	local v17 = filter(values(p2._pendingRegisters), function(p3) -- line: 84
		return p3.Widget:FindFirstAncestorWhichIsA("LayerCollector") ~= nil
	end)

	for _, v19 in v17 do
		v19.Position = v19.Widget.AbsolutePosition
		v19.Size = v19.Widget.AbsoluteSize
		v19.Visible = v19.Widget:GetStyled("Visible")

		local v20 = StudioUri.toString(v19.Uri)
		local v21 = p2._signals[v20]

		if v21 then
			if v21.Widget == v19.Widget then
				continue
			end

			v21.PositionChanged:Disconnect()
			v21.SizeChanged:Disconnect()
			v21.VisibleChanged:Disconnect()
			v21.AncestryChanged:Disconnect()
		end

		p2._signals[v20] = {
			Widget = v19.Widget,
			PositionChanged = v19.Widget:GetPropertyChangedSignal("AbsolutePosition"):Connect(function() -- line: 107
				-- upvalues: p2 (copy), v19 (copy)
				p2:register(v19.Uri, v19.Widget)
			end),
			SizeChanged = v19.Widget:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 110
				-- upvalues: p2 (copy), v19 (copy)
				p2:register(v19.Uri, v19.Widget)
			end),
			VisibleChanged = v19.Widget:GetStyledPropertyChangedSignal("Visible"):Connect(function() -- line: 113
				-- upvalues: p2 (copy), v19 (copy)
				p2:register(v19.Uri, v19.Widget)
			end),
			AncestryChanged = v19.Widget.AncestryChanged:Connect(function(_, parent) -- line: 116
				-- upvalues: p2 (copy), v19 (copy)
				if not parent then
					p2:deregister(v19.Uri)
				end
			end)
		}
	end

	if #v17 > 0 then
		p2._widgetsApi:RegisterAsync(v17)
	end

	p2._pendingRegisters = {}
end
function t1._run(p5) -- line: 130
	if p5._running then
		return
	end

	p5._running = true
	task.defer(function() -- line: 135
		-- upvalues: p5 (copy)
		p5._running = false
		p5:flush()
	end)
end
function t1.register(p6, p7, p8) -- line: 145
	-- upvalues: StudioUri (copy)
	local v26 = p8:FindFirstAncestorWhichIsA("PluginGui") or p8:FindFirstAncestorWhichIsA("ScreenGui")

	if v26 then
		local v27 = StudioUri.toString(p7)

		p6._registeredWidgets[v27] = p8
		p6._pendingRegisters[v27] = {
			Uri = p7,
			Widget = p8,
			DEPRECATED_PluginGui = v26
		}
		p6._pendingDeregisters[v27] = nil
		p6:_run()
	end
end
function t1.deregister(p9, p10, p11) -- line: 159
	-- upvalues: StudioUri (copy), Logger (copy)
	local v31 = StudioUri.toString(p10)

	p9._pendingDeregisters[v31] = p10

	local v32 = p9._signals[v31]

	if v32 then
		if p11 == nil or p11 == v32.Widget then
			v32.PositionChanged:Disconnect()
			v32.SizeChanged:Disconnect()
			v32.VisibleChanged:Disconnect()
			v32.AncestryChanged:Disconnect()
			p9._signals[v31] = nil
		else
			Logger:warning(`WidgetManager:deregister called with mismatched widget for uri { v31 }`)
		end
	end

	p9:_run()
end
function t1.destroy(p12) -- line: 177
	for _, v35 in p12._signals do
		v35.PositionChanged:Disconnect()
		v35.SizeChanged:Disconnect()
		v35.VisibleChanged:Disconnect()
		v35.AncestryChanged:Disconnect()
	end

	p12._signals = {}
	p12._pendingRegisters = {}
	p12._pendingDeregisters = {}
	p12._registeredWidgets = {}
end

return t1
