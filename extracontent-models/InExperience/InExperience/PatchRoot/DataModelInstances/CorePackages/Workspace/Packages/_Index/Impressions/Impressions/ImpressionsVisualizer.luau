local CollectionService = game:GetService("CollectionService")
local RunService = game:GetService("RunService")
local parent = script:FindFirstAncestor("Impressions").Parent

local Cryo = require(parent.Cryo)
local Constants = require(script.Parent.Constants)

local defineFastFlag = game:DefineFastFlag("DebugEnableImpressionsVisualizer", false)

local v = {
	Color3.new(0.941176, 0.941176, 0.015686),
	Color3.new(0.890196, 0.058823, 0.058823),
	Color3.new(0.031372, 0.870588, 0.031372),
	Color3.new(0.866666, 0.039215, 0.647058),
	Color3.new(0.035294, 0.631372, 0.866666),
	Color3.new(0.882352, 0.556862, 0.035294),
	Color3.new(0.729411, 0.043137, 0.835294)
}

local v2 = 1

local _ = { None = "None", Highlight = "Highlight", FadeOut = "FadeOut" }

local v3 = {
	BackgroundColor3 = Color3.new(1, 1, 1),
	BorderColor3 = Color3.new(1, 1, 1),
	BackgroundTransparency = 0,
	BorderMode = Enum.BorderMode.Outline,
	BorderSizePixel = 15,
	ZIndex = 100
}

local v4 = { BackgroundTransparency = 0.65, BorderSizePixel = 8 }

local ImpressionsVisualizer = {}
ImpressionsVisualizer.__index = ImpressionsVisualizer

local function getTaggedInstances(impressionsTag)
	local tagged = CollectionService:GetTagged(impressionsTag)
	local guiObjectsByAttribute = {}

	for _, guiObject in ipairs(tagged) do
		local attribute = guiObject:GetAttribute(Constants.ItemIndex)

		if attribute and guiObject:IsA("GuiObject") then
			guiObjectsByAttribute[attribute] = guiObject
		end
	end

	return guiObjectsByAttribute
end

function ImpressionsVisualizer.new(impressionsTag, p)
	local v5 = {
		impressionsTag = impressionsTag,
		highlightedInstances = {},
		originalInstances = {},
		highlightColor = v[v2],
		customKeyMapper = p or function(p2)
			return p2
		end
	}

	setmetatable(v5, ImpressionsVisualizer)

	if not defineFastFlag then
		return v5
	end

	v2 += 1

	if v2 > #v then
		v2 %= #v
	end

	if impressionsTag then
		local renderSteppedConnection = nil
		renderSteppedConnection = RunService.RenderStepped:Connect(function(dt)
			if v5 then
				v5:_step(dt)
			elseif renderSteppedConnection then
				renderSteppedConnection:Disconnect()
			end
		end)
		v5.renderConnection = renderSteppedConnection
	end

	return v5
end

function ImpressionsVisualizer.destroy(p)
	if p.renderConnection then
		p.renderConnection:Disconnect()
	end
end

function ImpressionsVisualizer:_startHighlightState(p, highlightState, p2, items, doLerp)
	local v5 = self.highlightedInstances[p]

	if v5 == nil then
		self.highlightedInstances[p] = { highlightState = highlightState, currentFields = {} }

		v5 = self.highlightedInstances[p]
	else
		v5.highlightState = highlightState
	end

	v5.totalDuration = p2
	v5.duration = p2
	v5.doLerp = doLerp

	if doLerp then
		local startFields = {}
		local targetFields = {}

		for k, item in pairs(items) do
			startFields[k] = v5.currentFields[k]
			targetFields[k] = item
		end

		v5.startFields = startFields
		v5.targetFields = targetFields
	else
		v5.startFields = nil
		v5.targetFields = nil

		for k, item in pairs(items) do
			v5.currentFields[k] = item
		end
	end

	self.highlightedInstances[p] = v5
end

function ImpressionsVisualizer:_step(p)
	assert(self.impressionsTag, "impressionsTag is nil")

	for k, highlightedInstance in pairs(self.highlightedInstances) do
		if
			highlightedInstance.doLerp
			and highlightedInstance.duration ~= nil
			and highlightedInstance.totalDuration ~= nil
		then
			assert(highlightedInstance.startFields, "startFields is nil")
			assert(highlightedInstance.targetFields, "targetFields is nil")

			if highlightedInstance.duration <= 0 then
				highlightedInstance.doLerp = nil
				highlightedInstance.duration = nil

				for k2, targetField in pairs(highlightedInstance.targetFields) do
					highlightedInstance.currentFields[k2] = targetField
				end
			else
				local v5 = math.clamp(
					(highlightedInstance.totalDuration - highlightedInstance.duration) / highlightedInstance.totalDuration,
					0,
					1
				)

				for k2, targetField in pairs(highlightedInstance.targetFields) do
					local startField = highlightedInstance.startFields[k2]
					local v6 = startField + (targetField - startField) * v5

					highlightedInstance.currentFields[k2] = v6
				end
			end
		end

		if highlightedInstance.highlightState == "Highlight" then
			assert(highlightedInstance.duration ~= nil, "duration is nil")

			if highlightedInstance.duration <= 0 then
				self:_startHighlightState(k, "FadeOut", 2.5, v4, true)
			end
		end

		if highlightedInstance.duration then
			highlightedInstance.duration -= p
		end
	end

	local taggedInstances = getTaggedInstances(self.impressionsTag)

	for k, taggedInstance in pairs(taggedInstances) do
		if taggedInstance == nil then
			continue
		end

		if self.originalInstances[taggedInstance] == nil then
			self.originalInstances[taggedInstance] = {}

			for k2, _ in pairs(v3) do
				self.originalInstances[taggedInstance][k2] = taggedInstance[k2]
			end
		end

		local customKeyMapper = self.customKeyMapper(k)
		local v5 = self.highlightedInstances[customKeyMapper]

		if v5 == nil then
			assert(self.originalInstances[taggedInstance], "self.originalInstances[instance] is nil")
			v5 = { highlightState = "None", currentFields = {} }

			for k2, v6 in pairs(self.originalInstances[taggedInstance]) do
				v5.currentFields[k2] = v6
			end

			self.highlightedInstances[customKeyMapper] = v5
		end

		assert(v5 ~= nil, "stateData is nil")

		if not v5.currentFields then
			continue
		end

		for k2, currentField in pairs(v5.currentFields) do
			taggedInstance[k2] = currentField
		end
	end
end

function ImpressionsVisualizer:_highlightImpression(p)
	if self.highlightedInstances[p] ~= nil and self.highlightedInstances[p].highlightState ~= "None" then
		return
	end

	self:_startHighlightState(
		p,
		"Highlight",
		1,
		Cryo.Dictionary.join(v3, {
			BackgroundColor3 = self.highlightColor,
			BorderColor3 = self.highlightColor
		}),
		false
	)
end

function ImpressionsVisualizer:_clearImpression(p)
	self.highlightedInstances[p] = nil
end

function ImpressionsVisualizer:onSendImpressions(list)
	if not defineFastFlag or (not self.impressionsTag or list == nil or #list <= 0) then
		return
	end

	for _, item in ipairs(list) do
		self:_highlightImpression((self.customKeyMapper(item)))
	end
end

function ImpressionsVisualizer:onClearImpressions(list)
	if not defineFastFlag or (not self.impressionsTag or list == nil or #list <= 0) then
		return
	end

	for _, item in ipairs(list) do
		self:_clearImpression((self.customKeyMapper(item)))
	end
end

function ImpressionsVisualizer:onClearAllImpressions()
	if not (defineFastFlag and self.impressionsTag) then
		return
	end

	for k, originalInstance in pairs(self.originalInstances) do
		for k2, v5 in pairs(originalInstance) do
			k[k2] = v5
		end
	end

	self.highlightedInstances = {}
	self.originalInstances = {}
end

function ImpressionsVisualizer:setCustomKeyMapper(p)
	self.customKeyMapper = p or function(p2)
		return p2
	end
end

function ImpressionsVisualizer:setImpressionsTag(impressionsTag)
	self.impressionsTag = impressionsTag
end

return ImpressionsVisualizer
