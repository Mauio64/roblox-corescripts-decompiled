local CollectionService = game:GetService("CollectionService")
local RunService = game:GetService("RunService")

local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/Impressions/Cryo")
local Constants = require("@game/CorePackages/Workspace/Packages/_Index/Impressions/Impressions/Constants")

local defineFastFlag = game:DefineFastFlag("DebugEnableImpressionsVisualizer", false)

local v5 = {
	Color3.new(0.941176, 0.941176, 0.015686),
	Color3.new(0.890196, 0.058823, 0.058823),
	Color3.new(0.031372, 0.870588, 0.031372),
	Color3.new(0.866666, 0.039215, 0.647058),
	Color3.new(0.035294, 0.631372, 0.866666),
	Color3.new(0.882352, 0.556862, 0.035294),
	Color3.new(0.729411, 0.043137, 0.835294)
}

local v6 = 1

local v7 = { None = "None", Highlight = "Highlight", FadeOut = "FadeOut" }

local v8 = {
	BackgroundColor3 = Color3.new(1, 1, 1),
	BorderColor3 = Color3.new(1, 1, 1),
	BackgroundTransparency = 0,
	BorderMode = Enum.BorderMode.Outline,
	BorderSizePixel = 15,
	ZIndex = 100
}

local v9 = { BackgroundTransparency = 0.65, BorderSizePixel = 8 }

local class = {}
class.__index = class

local function getTaggedInstances(impressionsTag)
	local tagged = CollectionService:GetTagged(impressionsTag)
	local guiObjectsByAttribute = {}

	for i, guiObject in ipairs(tagged) do
		local attribute = guiObject:GetAttribute(Constants.ItemIndex)

		if attribute and guiObject:IsA("GuiObject") then
			guiObjectsByAttribute[attribute] = guiObject
		end
	end

	return guiObjectsByAttribute
end

function class.new(p2, p3)
	local v10 = {
		impressionsTag = p2,
		highlightedInstances = {},
		originalInstances = {},
		highlightColor = v5[v6],
		customKeyMapper = p3 or function(p4)
			return p4
		end
	}

	setmetatable(v10, class)

	if not defineFastFlag then
		return v10
	end

	v6 += 1

	if v6 > #v5 then
		v6 %= #v5
	end

	if p2 then
		local renderSteppedConnection = nil
		renderSteppedConnection = RunService.RenderStepped:Connect(function(dt)
			if v10 then
				v10:_step(dt)
			elseif renderSteppedConnection then
				renderSteppedConnection:Disconnect()
			end
		end)
		v10.renderConnection = renderSteppedConnection
	end

	return v10
end

function class.destroy(p2)
	if p2.renderConnection then
		p2.renderConnection:Disconnect()
	end
end

function class:_startHighlightState(p3, highlightState, p4, items, doLerp)
	local v10 = self.highlightedInstances[p3]

	if v10 == nil then
		self.highlightedInstances[p3] = {
			highlightState = highlightState,
			currentFields = {}
		}

		v10 = self.highlightedInstances[p3]
	else
		v10.highlightState = highlightState
	end

	v10.totalDuration = p4
	v10.duration = p4
	v10.doLerp = doLerp

	if doLerp then
		local v11 = {}
		local v12 = {}

		for k, item in pairs(items) do
			v11[k] = v10.currentFields[k]
			v12[k] = item
		end

		v10.startFields = v11
		v10.targetFields = v12
	else
		v10.startFields = nil
		v10.targetFields = nil

		for k, item in pairs(items) do
			v10.currentFields[k] = item
		end
	end

	self.highlightedInstances[p3] = v10
end

function class:_step(p2)
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
				local v10 = math.clamp(
					(highlightedInstance.totalDuration - highlightedInstance.duration) / highlightedInstance.totalDuration,
					0,
					1
				)

				for k2, targetField in pairs(highlightedInstance.targetFields) do
					local startField = highlightedInstance.startFields[k2]
					local v11 = startField + (targetField - startField) * v10

					highlightedInstance.currentFields[k2] = v11
				end
			end
		end

		if highlightedInstance.highlightState == "Highlight" then
			assert(highlightedInstance.duration ~= nil, "duration is nil")

			if highlightedInstance.duration <= 0 then
				self:_startHighlightState(k, "FadeOut", 2.5, v9, true)
			end
		end

		if highlightedInstance.duration then
			highlightedInstance.duration -= p2
		end
	end

	local taggedInstances = getTaggedInstances(self.impressionsTag)

	for k, taggedInstance in pairs(taggedInstances) do
		if taggedInstance == nil then
			continue
		end

		if self.originalInstances[taggedInstance] == nil then
			self.originalInstances[taggedInstance] = {}

			for k2, v10 in pairs(v8) do
				self.originalInstances[taggedInstance][k2] = taggedInstance[k2]
			end
		end

		local customKeyMapper = self.customKeyMapper(k)
		local v10 = self.highlightedInstances[customKeyMapper]

		if v10 == nil then
			assert(self.originalInstances[taggedInstance], "self.originalInstances[instance] is nil")
			v10 = { highlightState = "None", currentFields = {} }

			for k2, v11 in pairs(self.originalInstances[taggedInstance]) do
				v10.currentFields[k2] = v11
			end

			self.highlightedInstances[customKeyMapper] = v10
		end

		assert(v10 ~= nil, "stateData is nil")

		if not v10.currentFields then
			continue
		end

		for k2, currentField in pairs(v10.currentFields) do
			taggedInstance[k2] = currentField
		end
	end
end

function class:_highlightImpression(p2)
	if self.highlightedInstances[p2] ~= nil and self.highlightedInstances[p2].highlightState ~= "None" then
		return
	end

	self:_startHighlightState(
		p2,
		"Highlight",
		1,
		Cryo.Dictionary.join(v8, {
			BackgroundColor3 = self.highlightColor,
			BorderColor3 = self.highlightColor
		}),
		false
	)
end

function class:_clearImpression(p3)
	self.highlightedInstances[p3] = nil
end

function class:onSendImpressions(list)
	if not defineFastFlag or (not self.impressionsTag or list == nil or #list <= 0) then
		return
	end

	for i, item in ipairs(list) do
		self:_highlightImpression((self.customKeyMapper(item)))
	end
end

function class:onClearImpressions(list)
	if not defineFastFlag or (not self.impressionsTag or list == nil or #list <= 0) then
		return
	end

	for i, item in ipairs(list) do
		self:_clearImpression((self.customKeyMapper(item)))
	end
end

function class:onClearAllImpressions()
	if not (defineFastFlag and self.impressionsTag) then
		return
	end

	for k, originalInstance in pairs(self.originalInstances) do
		for k2, v10 in pairs(originalInstance) do
			k[k2] = v10
		end
	end

	self.highlightedInstances = {}
	self.originalInstances = {}
end

function class:setCustomKeyMapper(p3)
	self.customKeyMapper = p3 or function(p4)
		return p4
	end
end

function class:setImpressionsTag(impressionsTag)
	self.impressionsTag = impressionsTag
end

return class
