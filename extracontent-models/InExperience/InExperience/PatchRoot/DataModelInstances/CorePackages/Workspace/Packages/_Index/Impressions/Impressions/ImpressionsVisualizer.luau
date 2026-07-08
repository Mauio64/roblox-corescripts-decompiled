local CollectionService = game:GetService("CollectionService")
local RunService = game:GetService("RunService")
local Parent = script:FindFirstAncestor("Impressions").Parent
local Cryo = require(Parent.Cryo)
local Constants = require(script.Parent.Constants)
local v6 = game:DefineFastFlag("DebugEnableImpressionsVisualizer", false)
local t1 = {
	Color3.new(0.941176, 0.941176, 0.015686),
	Color3.new(0.890196, 0.058823, 0.058823),
	Color3.new(0.031372, 0.870588, 0.031372),
	Color3.new(0.866666, 0.039215, 0.647058),
	Color3.new(0.035294, 0.631372, 0.866666),
	Color3.new(0.882352, 0.556862, 0.035294),
	Color3.new(0.729411, 0.043137, 0.835294)
}
local n1 = 1
local _ = {
	None = "None",
	Highlight = "Highlight",
	FadeOut = "FadeOut"
}
local t2 = {
	BackgroundTransparency = 0,
	BorderSizePixel = 15,
	ZIndex = 100,
	BackgroundColor3 = Color3.new(1, 1, 1),
	BorderColor3 = Color3.new(1, 1, 1),
	BorderMode = Enum.BorderMode.Outline
}
local t3 = {
	BackgroundTransparency = 0.65,
	BorderSizePixel = 8
}
local t4 = {}

t4.__index = t4

local function getTaggedInstances(p1) -- line: 82
	-- upvalues: CollectionService (copy), Constants (copy)
	local t5 = {}
	local p1_2 = CollectionService:GetTagged(p1)

	for _, v in ipairs(p1_2) do
		local ConstantsItemIndex = v:GetAttribute(Constants.ItemIndex)

		if ConstantsItemIndex and v:IsA("GuiObject") then
			t5[ConstantsItemIndex] = v
		end
	end

	return t5
end

function t4.new(p2, p3) -- line: 95
	-- upvalues: t1 (copy), n1 (ref), t4 (copy), v6 (copy), RunService (copy)
	local t6 = {
		impressionsTag = p2,
		highlightedInstances = {},
		originalInstances = {},
		highlightColor = t1[n1],
		customKeyMapper = p3 or function(p4) -- line: 101
			return p4
		end
	}

	setmetatable(t6, t4)

	if v6 then
		n1 += 1

		if n1 > #t1 then
			n1 %= #t1
		end

		if p2 then
			local connection = nil

			connection = RunService.RenderStepped:Connect(function(dt) -- line: 115
				-- upvalues: t6 (copy), connection (ref)
				if t6 then
					t6:_step(dt)

					return
				end

				if connection then
					connection:Disconnect()
				end
			end)
			t6.renderConnection = connection
		end
	end

	return t6
end
function t4.destroy(p5) -- line: 131
	if p5.renderConnection then
		p5.renderConnection:Disconnect()
	end
end
function t4._startHighlightState(p6, p7, p8, p9, p10, p11) -- line: 137
	local v31 = p6.highlightedInstances[p7]

	if v31 == nil then
		p6.highlightedInstances[p7] = {
			highlightState = p8,
			currentFields = {}
		}
		v31 = p6.highlightedInstances[p7]
	else
		v31.highlightState = p8
	end

	v31.totalDuration = p9
	v31.duration = p9
	v31.doLerp = p11

	if p11 then
		local t7 = {}
		local t8 = {}

		for k, v in pairs(p10) do
			t7[k] = v31.currentFields[k]
			t8[k] = v
		end

		v31.startFields = t7
		v31.targetFields = t8
	else
		v31.startFields = nil
		v31.targetFields = nil

		for k, v in pairs(p10) do
			v31.currentFields[k] = v
		end
	end

	p6.highlightedInstances[p7] = v31
end
function t4._step(p12, p13) -- line: 172
	-- upvalues: t3 (copy), getTaggedInstances (copy), t2 (copy)
	assert(p12.impressionsTag, "impressionsTag is nil")

	for k, v in pairs(p12.highlightedInstances) do
		if v.doLerp and v.duration ~= nil and v.totalDuration ~= nil then
			assert(v.startFields, "startFields is nil")
			assert(v.targetFields, "targetFields is nil")

			if v.duration <= 0 then
				v.doLerp = nil
				v.duration = nil

				for k2, v2 in pairs(v.targetFields) do
					v.currentFields[k2] = v2
				end
			else
				local v44 = math.clamp((v.totalDuration - v.duration) / v.totalDuration, 0, 1)

				for k3, v3 in pairs(v.targetFields) do
					local v47 = v.startFields[k3]
					local v48 = v47 + (v3 - v47) * v44

					v.currentFields[k3] = v48
				end
			end
		end

		if v.highlightState == "Highlight" then
			assert(v.duration ~= nil, "duration is nil")

			if v.duration <= 0 then
				p12:_startHighlightState(k, "FadeOut", 2.5, t3, true)
			end
		end

		if v.duration then
			v.duration = v.duration - p13
		end
	end

	local v49 = getTaggedInstances(p12.impressionsTag)

	for k, v in pairs(v49) do
		if v ~= nil then
			if p12.originalInstances[v] == nil then
				p12.originalInstances[v] = {}

				for k4, _ in pairs(t2) do
					p12.originalInstances[v][k4] = v[k4]
				end
			end

			local v54 = p12.customKeyMapper(k)
			local v55 = p12.highlightedInstances[v54]

			if v55 == nil then
				v55 = {
					highlightState = "None",
					currentFields = {}
				}
				assert(p12.originalInstances[v], "self.originalInstances[instance] is nil")

				for k5, v4 in pairs(p12.originalInstances[v]) do
					v55.currentFields[k5] = v4
				end

				p12.highlightedInstances[v54] = v55
			end

			assert(v55 ~= nil, "stateData is nil")

			if v55.currentFields then
				for k6, v5 in pairs(v55.currentFields) do
					v[k6] = v5
				end
			end
		end
	end
end
function t4._highlightImpression(p14, p15) -- line: 260
	-- upvalues: Cryo (copy), t2 (copy)
	if p14.highlightedInstances[p15] ~= nil and p14.highlightedInstances[p15].highlightState ~= "None" then
		return
	end

	p14:_startHighlightState(p15, "Highlight", 1, Cryo.Dictionary.join(t2, {
		BackgroundColor3 = p14.highlightColor,
		BorderColor3 = p14.highlightColor
	}), false)
end
function t4._clearImpression(p16, p17) -- line: 275
	p16.highlightedInstances[p17] = nil
end
function t4.onSendImpressions(p18, p19) -- line: 279
	-- upvalues: v6 (copy)
	if not v6 then
		return
	end

	if not p18.impressionsTag or p19 == nil or #p19 <= 0 then
		return
	end

	for _, v in ipairs(p19) do
		p18:_highlightImpression((p18.customKeyMapper(v)))
	end
end
function t4.onClearImpressions(p20, p21) -- line: 294
	-- upvalues: v6 (copy)
	if not v6 then
		return
	end

	if not p20.impressionsTag or p21 == nil or #p21 <= 0 then
		return
	end

	for _, v in ipairs(p21) do
		p20:_clearImpression((p20.customKeyMapper(v)))
	end
end
function t4.onClearAllImpressions(p22) -- line: 309
	-- upvalues: v6 (copy)
	if not v6 then
		return
	end

	if not p22.impressionsTag then
		return
	end

	for k, v in pairs(p22.originalInstances) do
		for k7, v7 in pairs(v) do
			k[k7] = v7
		end
	end

	p22.highlightedInstances = {}
	p22.originalInstances = {}
end
function t4.setCustomKeyMapper(p23, p24) -- line: 329
	p23.customKeyMapper = p24 or function(p25) -- line: 330
		return p25
	end
end
function t4.setImpressionsTag(p26, p27) -- line: 335
	p26.impressionsTag = p27
end

return t4
