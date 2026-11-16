local Signal = require(script.Parent.Parent.Parent.Signal)

local Constants = require(script.Parent.Parent.Parent.Constants)
local ChartHeaderNames = Constants.DebugVisualizationsFormatting.ChartHeaderNames

local DebugVisualizationsStaticContent = require(script.Parent.DebugVisualizationsStaticContent)
local defineFastFlag = game:DefineFastFlag("SlimDevConsole2", false)
local defineFastFlag2 = game:DefineFastFlag("SlimTintContextFilter", false)
local defineFastFlag3 = game:DefineFastFlag("SlimTintModeTelemetry", false)
local DebugVisualizationsTelemetry = require(script.Parent.DebugVisualizationsTelemetry)

local v = {
	[ChartHeaderNames[1]] = function(p, p2): boolean
		return p.name < p2.name
	end,
	[ChartHeaderNames[2]] = function(p, p2)
		if p.settingInfo.Value == p2.settingInfo.Value then
			return p.name < p2.name
		end

		return p.settingInfo.Value
	end,
	[ChartHeaderNames[3]] = function(p, p2): boolean
		if p.settingInfo.Type == p2.settingInfo.Type then
			return p.name < p2.name
		end

		return p.settingInfo.Type < p2.settingInfo.Type
	end,
	[ChartHeaderNames[4]] = function(p, p2): boolean
		return p.name < p2.name
	end
}

local DebugVisualizationsData = {}
DebugVisualizationsData.__index = DebugVisualizationsData

function DebugVisualizationsData.new()
	local v2 = {}
	setmetatable(v2, DebugVisualizationsData)

	v2._visualizationsUpdated = Signal.new()
	v2._visualizationsData = {}
	v2._visualizationCounter = 0
	v2._sortedVisualizationData = {}
	v2._sortType = ChartHeaderNames[3]
	v2._isRunning = false
	return v2
end

function DebugVisualizationsData:setSortType(sortType)
	if not v[sortType] then
		error(string.format("attempted to pass invalid sortType: %s", (tostring(sortType))), 2)

		return
	end

	self._sortType = sortType
	table.sort(self._sortedVisualizationData, v[self._sortType])
	self._visualizationsUpdated:Fire(self._sortedVisualizationData)
end

function DebugVisualizationsData:getSortType()
	return self._sortType
end

function DebugVisualizationsData:Signal()
	return self._visualizationsUpdated
end

function DebugVisualizationsData:getCurrentData()
	return self._sortedVisualizationData
end

function DebugVisualizationsData:updateDebugVisualizationDataEntry(name, p)
	if p == nil then
		self._visualizationsData[name] = nil

		for k, v2 in pairs(self._sortedVisualizationData) do
			if v2.name == name then
				table.remove(self._sortedVisualizationData, k)
				return
			end
		end
	else
		if self._visualizationsData[name] then
			self._visualizationsData[name] = p

			return
		end

		self._visualizationCounter += 1
		self._visualizationsData[name] = p
		local v2 = {
			name = name,
			settingInfo = self._visualizationsData[name],
			valueChangeCallback = function(p2, p3)
				self:_toggleValue(p2, p3)
			end,
			counter = self._visualizationCounter
		}

		table.insert(self._sortedVisualizationData, v2)
	end
end

function DebugVisualizationsData:isRunning()
	return self._isRunning
end

function DebugVisualizationsData:_toggleValue(p, p2)
	if defineFastFlag then
		local v2 = self._visualizationsData[p]

		if v2 and v2.Kind == "Dropdown" then
			local service = settings():GetService(v2.Service)
			service[v2.Setter](service, p2)
			v2.Value = p2

			if defineFastFlag3 and p == "SlimTintMode" then
				DebugVisualizationsTelemetry.logSlimTintModeSelected(p2)
			end

			table.sort(self._sortedVisualizationData, v[self._sortType])
			self._visualizationsUpdated:Fire(self._sortedVisualizationData)
			return
		end
	end

	local physics = settings().Physics

	if physics[p] ~= nil then
		if p2 and self._visualizationsData[p].Type == "Box" then
			for _, v2 in pairs(self._visualizationsData) do
				if not (v2.Type == "Box" and physics[v2.Name] ~= nil) then
					continue
				end

				physics[v2.Name] = false
				self._visualizationsData[v2.Name].Value = false
			end
		end

		physics[p] = p2
		self._visualizationsData[p].Value = p2

		table.sort(self._sortedVisualizationData, v[self._sortType])
		self._visualizationsUpdated:Fire(self._sortedVisualizationData)
	end
end

function _constructInfo(p, data)
	local v2 = nil
	local dropDownList = nil
	local enumItems = nil

	if defineFastFlag and data.kind == "Dropdown" then
		local success, result = pcall(function()
			return settings():GetService(data.service)
		end)

		if success and result then
			v2 = result[data.getter](result)

			if defineFastFlag2 then
				local availableTintModes = result:GetAvailableTintModes(Enum.SlimViewContext.Player, true)
				enumItems = {}
				dropDownList = {}

				for i, availableTintMode in ipairs(availableTintModes) do
					enumItems[i] = Enum.SlimTintMode[availableTintMode]
					dropDownList[i] = availableTintMode
				end
			else
				enumItems = v2.EnumType:GetEnumItems()
				dropDownList = {}

				for i, v3 in ipairs(enumItems) do
					dropDownList[i] = v3.Name
				end
			end
		end
	else
		local physics = settings().Physics

		if physics[p] == nil then
			v2 = false
		else
			v2 = physics[p]
		end
	end

	local tagstring = ""

	for i, tag in ipairs(data.tags) do
		tagstring = (tagstring .. tag) .. (i == #data.tags and "" or ", ")
	end

	local v3 = {
		Name = data.name,
		Value = v2,
		Type = data.type,
		Kind = 0,
		Tags = 0,
		Tagstring = 0,
		Description = 0,
		LearnMoreUrl = 0
	}
	local kind

	if defineFastFlag then
		kind = data.kind
	end

	v3.Kind = kind
	v3.Tags = data.tags
	v3.Tagstring = tagstring
	v3.Description = data.description
	local learnMoreUrl

	if defineFastFlag then
		learnMoreUrl = data.learnMoreUrl
	end

	v3.LearnMoreUrl = learnMoreUrl

	if not defineFastFlag or data.kind ~= "Dropdown" then
		return v3
	end

	v3.DropDownList = dropDownList
	v3.EnumItems = enumItems
	v3.Service = data.service
	v3.Setter = data.setter

	return v3
end

function DebugVisualizationsData:start()
	for k, v2 in pairs(DebugVisualizationsStaticContent) do
		self:updateDebugVisualizationDataEntry(k, _constructInfo(k, v2))
	end

	table.sort(self._sortedVisualizationData, v[self._sortType])
	self._isRunning = true
end

function DebugVisualizationsData:stop()
	self._isRunning = false
end

return DebugVisualizationsData
