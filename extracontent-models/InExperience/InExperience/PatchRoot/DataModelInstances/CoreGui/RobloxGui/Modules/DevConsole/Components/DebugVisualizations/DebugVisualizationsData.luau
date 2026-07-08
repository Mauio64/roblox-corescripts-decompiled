local Signal = require(script.Parent.Parent.Parent.Signal)
local ChartHeaderNames = require(script.Parent.Parent.Parent.Constants).DebugVisualizationsFormatting.ChartHeaderNames
local DebugVisualizationsStaticContent = require(script.Parent.DebugVisualizationsStaticContent)
local v4 = game:DefineFastFlag("SlimDevConsole2", false)
local t1 = {
	[ChartHeaderNames[1]] = function(p1, p2) -- line: 11
		return p1.name < p2.name
	end,
	[ChartHeaderNames[2]] = function(p3, p4) -- line: 14
		if p3.settingInfo.Value ~= p4.settingInfo.Value then
			return p3.settingInfo.Value
		end

		return p3.name < p4.name
	end,
	[ChartHeaderNames[3]] = function(p5, p6) -- line: 18
		if p5.settingInfo.Type ~= p6.settingInfo.Type then
			return p5.settingInfo.Type < p6.settingInfo.Type
		end

		return p5.name < p6.name
	end,
	[ChartHeaderNames[4]] = function(p7, p8) -- line: 22
		return p7.name < p8.name
	end
}
local t2 = {}

t2.__index = t2

function t2.new() -- line: 30
	-- upvalues: t2 (copy), Signal (copy), ChartHeaderNames (copy)
	local t3 = {}

	setmetatable(t3, t2)
	t3._visualizationsUpdated = Signal.new()
	t3._visualizationsData = {}
	t3._visualizationCounter = 0
	t3._sortedVisualizationData = {}
	t3._sortType = ChartHeaderNames[3]
	t3._isRunning = false

	return t3
end
function t2.setSortType(p9, p10) -- line: 43
	-- upvalues: t1 (copy)
	if t1[p10] then
		p9._sortType = p10
		table.sort(p9._sortedVisualizationData, t1[p9._sortType])
		p9._visualizationsUpdated:Fire(p9._sortedVisualizationData)

		return
	end

	error(string.format("attempted to pass invalid sortType: %s", (tostring(p10))), 2)
end
function t2.getSortType(p11) -- line: 53
	return p11._sortType
end
function t2.Signal(p12) -- line: 57
	return p12._visualizationsUpdated
end
function t2.getCurrentData(p13) -- line: 61
	return p13._sortedVisualizationData
end
function t2.updateDebugVisualizationDataEntry(p14, p15, p16) -- line: 67
	if p16 == nil then
		p14._visualizationsData[p15] = nil

		for k, v in pairs(p14._sortedVisualizationData) do
			if p15 == v.name then
				table.remove(p14._sortedVisualizationData, k)

				return
			end
		end

		return
	end

	if not p14._visualizationsData[p15] then
		p14._visualizationCounter = p14._visualizationCounter + 1
		p14._visualizationsData[p15] = p16

		local t4 = {
			name = p15,
			settingInfo = p14._visualizationsData[p15],
			valueChangeCallback = function(p17, p18) -- line: 84
				-- upvalues: p14 (copy)
				p14:_toggleValue(p17, p18)
			end,
			counter = p14._visualizationCounter
		}

		table.insert(p14._sortedVisualizationData, t4)

		return
	end

	p14._visualizationsData[p15] = p16
end
function t2.isRunning(p19) -- line: 95
	return p19._isRunning
end
function t2._toggleValue(p20, p21, p22) -- line: 99
	-- upvalues: v4 (copy), t1 (copy)
	if v4 then
		local v31 = p20._visualizationsData[p21]

		if v31 and v31.Kind == "Dropdown" then
			local Service = settings():GetService(v31.Service)

			Service[v31.Setter](Service, p22)
			v31.Value = p22
			table.sort(p20._sortedVisualizationData, t1[p20._sortType])
			p20._visualizationsUpdated:Fire(p20._sortedVisualizationData)

			return
		end
	end

	local Physics = settings().Physics

	if Physics[p21] ~= nil then
		if p22 and p20._visualizationsData[p21].Type == "Box" then
			for _, v in pairs(p20._visualizationsData) do
				if v.Type == "Box" and Physics[v.Name] ~= nil then
					Physics[v.Name] = false
					p20._visualizationsData[v.Name].Value = false
				end
			end
		end

		Physics[p21] = p22
		p20._visualizationsData[p21].Value = p22
		table.sort(p20._sortedVisualizationData, t1[p20._sortType])
		p20._visualizationsUpdated:Fire(p20._sortedVisualizationData)
	end
end
function _constructInfo(p23, p24) -- line: 132
	-- upvalues: v4 (copy)
	local v38 = nil
	local t5 = nil
	local EnumItems = nil

	if v4 and p24.kind == "Dropdown" then
		local ok, result = pcall(function() -- line: 138
			-- upvalues: p24 (copy)
			return settings():GetService(p24.service)
		end)

		if ok and result then
			v38 = result[p24.getter](result)
			EnumItems = v38.EnumType:GetEnumItems()
			t5 = {}

			for i, v in ipairs(EnumItems) do
				t5[i] = v.Name
			end
		end
	else
		local Physics = settings().Physics

		v38 = Physics[p23] ~= nil and Physics[p23]
	end

	local s1 = ""

	for i, v in ipairs(p24.tags) do
		s1 = (s1 .. v) .. (i == #p24.tags and "" or ", ")
	end

	local t6 = {
		Name = p24.name,
		Value = v38,
		Type = p24.type,
		Kind = if not v4 then nil else p24.kind,
		Tags = p24.tags,
		Tagstring = s1,
		Description = p24.description,
		LearnMoreUrl = if not v4 then nil else p24.learnMoreUrl
	}

	if v4 and p24.kind == "Dropdown" then
		t6.DropDownList = t5
		t6.EnumItems = EnumItems
		t6.Service = p24.service
		t6.Setter = p24.setter
	end

	return t6
end
function t2.start(p25) -- line: 184
	-- upvalues: DebugVisualizationsStaticContent (copy), t1 (copy)
	for k, v in pairs(DebugVisualizationsStaticContent) do
		p25:updateDebugVisualizationDataEntry(k, _constructInfo(k, v))
	end

	table.sort(p25._sortedVisualizationData, t1[p25._sortType])
	p25._isRunning = true
end
function t2.stop(p26) -- line: 192
	p26._isRunning = false
end

return t2
