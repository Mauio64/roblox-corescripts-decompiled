local CollectionService = game:GetService("CollectionService")
local RunService = game:GetService("RunService")
local OBSERVED_IMAGE_TAG = require(script.Parent.Constants).OBSERVED_IMAGE_TAG
local v4 = game:DefineFastFlag("DebugEnableImageLoadObserver", false)
local color3 = Color3.fromRGB(40, 140, 240)
local color3_2 = Color3.fromRGB(40, 230, 90)
local t1 = {}

t1.__index = t1

function t1.isEnabled() -- line: 38
	-- upvalues: v4 (copy)
	return v4
end
function t1.new() -- line: 42
	-- upvalues: t1 (copy), v4 (copy), RunService (copy)
	local v8 = setmetatable({
		connection = nil,
		strokes = {}
	}, t1)

	if v4 then
		v8.connection = RunService.Heartbeat:Connect(function() -- line: 49
			-- upvalues: v8 (copy)
			v8:_outlineTagged()
		end)
	end

	return v8
end
function t1._ensureStroke(p1, p2) -- line: 57
	-- upvalues: color3 (copy)
	local v11 = p1.strokes[p2]

	if v11 and p2 == v11.Parent then
		return v11
	end

	local UIStroke = Instance.new("UIStroke")

	UIStroke.Name = "ImageLoadObserverDebugStroke"
	UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	UIStroke.Color = color3
	UIStroke.Thickness = 3
	UIStroke.Transparency = 0
	UIStroke.Parent = p2
	p1.strokes[p2] = UIStroke

	return UIStroke
end
function t1._removeStroke(p3, p4) -- line: 75
	local v15 = p3.strokes[p4]

	p3.strokes[p4] = nil

	if v15 then
		v15:Destroy()
	end
end
function t1._outlineTagged(p5) -- line: 83
	-- upvalues: CollectionService (copy), OBSERVED_IMAGE_TAG (copy)
	local t2 = {}

	for _, v19 in CollectionService:GetTagged(OBSERVED_IMAGE_TAG) do
		if v19:IsA("GuiObject") then
			t2[v19] = true
			p5:_ensureStroke(v19)
		end
	end

	for v20 in p5.strokes do
		if not t2[v20] then
			p5:_removeStroke(v20)
		end
	end
end
function t1.flash(p6, p7) -- line: 102
	-- upvalues: v4 (copy), color3_2 (copy), color3 (copy)
	if not v4 then
		return
	end

	if p7 == nil or not p7:IsA("GuiObject") then
		return
	end

	local v23 = p6:_ensureStroke(p7)

	v23.Color = color3_2
	v23.Thickness = 6
	task.delay(2.5, function() -- line: 114
		-- upvalues: v23 (copy), color3 (copy)
		if v23.Parent ~= nil then
			v23.Color = color3
			v23.Thickness = 3
		end
	end)
end
function t1.flashAndDestroy(p8, p9) -- line: 124
	-- upvalues: v4 (copy)
	if not v4 then
		return
	end

	p8:flash(p9)
	task.delay(2.5, function() -- line: 131
		-- upvalues: p8 (copy)
		p8:destroy()
	end)
end
function t1.destroy(p10) -- line: 136
	if p10.connection then
		p10.connection:Disconnect()
		p10.connection = nil
	end

	for v27 in p10.strokes do
		p10:_removeStroke(v27)
	end
end

return t1
