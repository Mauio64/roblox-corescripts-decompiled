local CoreGui = game:GetService("CoreGui")
local ContextActionService = game:GetService("ContextActionService")
local TweenService = game:GetService("TweenService")
local CorePackages = game:GetService("CorePackages")

CoreGui:WaitForChild("RobloxGui")

local Create = require(CorePackages.Workspace.Packages.AppCommonLib).Create
local color3 = Color3.new(0.1, 0, 0)
local color3_2 = Color3.new(0, 0, 0)

TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)

local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, 0, true, 0)
local tweenInfo2 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
local u10 = nil
local t1 = {}
local t2 = {}
local t3 = {}
local t4 = {}
local t5 = {}
local t6 = {}
local t7 = {}
local t8 = {}
local u19 = true
local _ = {
	BoundInputType = 3,
	TableHeader = 2,
	BoundAction = 1
}

local function sortInputTypeRows(p1, p2) -- line: 43
	-- upvalues: t2 (copy)
	local v34 = t2[p1]
	local v35 = t2[p2]

	return tostring(v34) < tostring(v35)
end
local function sortActionRows(p3, p4) -- line: 49
	-- upvalues: t4 (copy), t5 (copy)
	local v38 = t4[p3]
	local v39 = t4[p4]

	if v38 and v39 then
		local v40 = t5[p3]
		local v41 = t5[p4]

		if v40 ~= v41 then
			return tostring(v40) < tostring(v41)
		end

		if v38.isCore and not v39.isCore then
			return true
		end

		if not v38.isCore and v39.isCore then
			return false
		end

		local stackOrder = v38.stackOrder
		local stackOrder2 = v39.stackOrder

		if stackOrder and stackOrder2 then
			return stackOrder2 < stackOrder
		end

		return true
	end

	return true
end
local function createEmptyRow(p5, p6) -- line: 75
	-- upvalues: Create (copy)
	local v46 = Create("Frame")({
		BackgroundTransparency = 1,
		ZIndex = 6,
		Name = p5,
		Size = UDim2.new(1, 0, 0, p6 or 0)
	})

	Create("UIListLayout")({
		FillDirection = Enum.FillDirection.Horizontal,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 5),
		Parent = v46
	})

	return v46
end
local function createButtonRow(p7, p8) -- line: 91
	-- upvalues: Create (copy)
	local v49 = Create("TextButton")({
		BackgroundTransparency = 1,
		ZIndex = 6,
		Text = "",
		Name = p7,
		Size = UDim2.new(1, 0, 0, p8 or 0)
	})

	Create("UIListLayout")({
		FillDirection = Enum.FillDirection.Horizontal,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 5),
		Parent = v49
	})

	return v49
end
local function createEmptyColumn(p9, p10) -- line: 108
	-- upvalues: Create (copy)
	return (Create("Frame")({
		BackgroundTransparency = 0.75,
		BorderSizePixel = 0,
		ZIndex = 6,
		ClipsDescendants = true,
		Name = p10,
		BackgroundColor3 = Color3.new(0, 0, 0),
		Size = UDim2.new(1, 0, 1, 0),
		Parent = p9
	}))
end
local function createImageColumn(p11, p12, p13, p14, p15) -- line: 123
	-- upvalues: createEmptyColumn (copy), Create (copy)
	local v57 = createEmptyColumn(p11, p12)

	Create("UIAspectRatioConstraint")({
		AspectRatio = p14 or 1,
		Parent = v57
	})
	Create("ImageLabel")({
		Name = "ColumnImage",
		BackgroundTransparency = 1,
		ZIndex = 6,
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = UDim2.new(p15 or 1, 0, p15 or 1, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Image = p13,
		Parent = v57
	})

	return v57
end
local function createTextColumn(p16, p17, p18) -- line: 145
	-- upvalues: createEmptyColumn (copy), Create (copy)
	local v61 = createEmptyColumn(p16, p17)

	Create("TextLabel")({
		Name = "ColumnText",
		BackgroundTransparency = 1,
		ZIndex = 6,
		TextSize = 18,
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = UDim2.new(1, -10, 1, -10),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Text = p18,
		TextColor3 = Color3.new(1, 1, 1),
		TextXAlignment = Enum.TextXAlignment.Left,
		Font = Enum.Font.SourceSans,
		Parent = v61
	})

	return v61
end
local function createActionColumns(p19, p20) -- line: 166
	-- upvalues: createEmptyColumn (copy), createTextColumn (copy)
	local v64 = createEmptyColumn(p19, "Inset")

	v64.LayoutOrder = 0
	v64.BackgroundTransparency = 1
	v64.Size = UDim2.new(0, 30, 1, 0)

	local v65 = 0 + 30 + 5
	local v66 = createTextColumn(p19, "Priority", "Priority")

	v66.LayoutOrder = 1
	v66.BackgroundColor3 = p20
	v66.Size = UDim2.new(0, 80, 1, 0)

	local v67 = v65 + 80 + 5
	local v68 = createTextColumn(p19, "Security", "Security")

	v68.LayoutOrder = 2
	v68.BackgroundColor3 = p20
	v68.Size = UDim2.new(0, 80, 1, 0)

	local v69 = v67 + 80 + 5
	local v70 = createTextColumn(p19, "ActionName", "Action Name")

	v70.LayoutOrder = 3
	v70.BackgroundColor3 = p20
	v70.Size = UDim2.new(0.25, 0, 1, 0)

	local v71 = createTextColumn(p19, "InputTypes", "Input Types")

	v71.LayoutOrder = 4
	v71.BackgroundColor3 = p20
	v71.Size = UDim2.new(0.75, -v69 - 5, 1, 0)

	return v64, v66, v68, v70, v71
end
local function updateContainerCanvas() -- line: 203
	-- upvalues: u19 (ref), t1 (copy), sortInputTypeRows (copy), t2 (copy), t7 (copy), t3 (copy), sortActionRows (copy)
	debug.profilebegin("updateContainerCanvas")

	if u19 then
		u19 = false

		local n1 = 1
		local t9 = {}

		for _, v in pairs(t1) do
			table.insert(t9, v)
		end

		table.sort(t9, sortInputTypeRows)

		for _, v in pairs(t9) do
			local v78 = t2[v]

			v.LayoutOrder = n1
			n1 += 1

			local v79 = t7[v78]

			if v79 then
				v79.LayoutOrder = n1
				n1 += 1
			end

			local v80 = t3[v78]

			if v80 then
				local t10 = {}

				for _, v2 in pairs(v80) do
					table.insert(t10, v2)
				end

				table.sort(t10, sortActionRows)

				for _, v3 in pairs(t10) do
					v3.LayoutOrder = n1
					n1 += 1
				end
			end
		end
	end

	debug.profileend()
end
local function scrollContainerToRow(p21) -- line: 245
	-- upvalues: u10 (ref), TweenService (copy), tweenInfo2 (copy)
	local v87 = p21.AbsolutePosition.Y - u10.AbsolutePosition.Y
	local v88 = u10.CanvasPosition + Vector2.new(0, v87)

	TweenService:Create(u10, tweenInfo2, {
		CanvasPosition = v88
	}):Play()
end

local t11 = {}

function t11.initializeGui(p22) -- line: 253
	-- upvalues: Create (copy), u10 (ref), t11 (copy), ContextActionService (copy), u19 (ref), updateContainerCanvas (copy)
	local v90 = Create("ScrollingFrame")({
		BorderSizePixel = 0,
		ScrollBarThickness = 4,
		BackgroundTransparency = 1,
		ZIndex = 6,
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = UDim2.new(1, -10, 1, -10),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Parent = p22
	})

	u10 = v90

	local v91 = Create("UIListLayout")({
		Padding = UDim.new(0, 5),
		Parent = v90
	})

	v91.SortOrder = Enum.SortOrder.LayoutOrder
	v91:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- line: 271
		-- upvalues: u10 (ref), v91 (copy)
		u10.CanvasSize = UDim2.new(0, 0, 0, v91.AbsoluteContentSize.Y)
	end)
	t11.updateGuis()
	ContextActionService.BoundActionAdded:connect(function(p23, _, p25, p26) -- line: 275
		-- upvalues: t11 (copy), u19 (ref), updateContainerCanvas (copy)
		p25.isCore = p26
		t11.updateActionRows(p23, p25)
		u19 = true
		updateContainerCanvas()
	end)
	ContextActionService.BoundActionRemoved:connect(function(p27, p28, p29) -- line: 282
		-- upvalues: t11 (copy), u19 (ref), updateContainerCanvas (copy)
		p28.isCore = p29
		t11.removeActionRows(p27, p28)
		u19 = true
		updateContainerCanvas()
	end)
end
function t11.updateBoundInputTypeRow(p30) -- line: 291
	-- upvalues: t1 (copy), createButtonRow (copy), createImageColumn (copy), createTextColumn (copy), createEmptyRow (copy), createActionColumns (copy), color3_2 (copy), t2 (copy), t6 (copy), t7 (copy), u10 (ref), TweenService (copy), tweenInfo (copy), t8 (copy), t3 (copy), updateContainerCanvas (copy), scrollContainerToRow (copy)
	if not t1[p30] then
		local v93 = createButtonRow("BoundInputType", 30)
		local v94 = createImageColumn(v93, "ExpandImage", "rbxasset://textures/ui/ExpandArrowSheet.png", 1, 0.35)

		v94.ColumnImage.ImageRectSize = Vector2.new(21, 21)
		v94.ColumnImage.ImageRectOffset = Vector2.new(0, 0)

		local v95 = createTextColumn(v93, "InputType", (tostring(p30)))

		v95.Size = UDim2.new(1, -35, 1, 0)
		v95.ColumnText.Font = Enum.Font.SourceSansBold

		local v96 = createEmptyRow("TableHeader", 20)

		v96.Visible = false

		local _, v98, v99, v100, v101 = createActionColumns(v96, color3_2)

		v98.ColumnText.Font = Enum.Font.SourceSansBold
		v99.ColumnText.Font = Enum.Font.SourceSansBold
		v100.ColumnText.Font = Enum.Font.SourceSansBold
		v101.ColumnText.Font = Enum.Font.SourceSansBold
		t1[p30] = v93
		t2[v93] = p30
		t6[v96] = p30
		t7[p30] = v96
		v96.Parent = u10
		v93.Parent = u10
		TweenService:Create(v95, tweenInfo, {
			BackgroundColor3 = Color3.new(0.5, 0.5, 0.5)
		}):Play()
		t8[p30] = false
		v93.MouseButton1Click:connect(function() -- line: 323
			-- upvalues: t8 (copy), p30 (copy), t3 (copy), v94 (copy), v96 (copy), updateContainerCanvas (copy), TweenService (copy), v95 (copy), tweenInfo (copy), scrollContainerToRow (copy), v93 (copy)
			t8[p30] = not t8[p30]

			local v143 = t3[p30]

			if not t8[p30] then
				v94.ColumnImage.ImageRectOffset = Vector2.new(0, 0)
				v96.Visible = false

				if v143 then
					for _, v in pairs(v143) do
						v.Visible = false
					end
				end
			else
				v94.ColumnImage.ImageRectOffset = Vector2.new(21, 0)
				v96.Visible = true

				if v143 then
					for _, v in pairs(v143) do
						v.Visible = true
					end
				end
			end

			updateContainerCanvas()

			if t8[p30] then
				TweenService:Create(v95, tweenInfo, {
					BackgroundColor3 = Color3.new(0.5, 0.5, 0.5)
				}):Play()
				scrollContainerToRow(v93)
			end
		end)
	end
end
function t11.updateActionRowForInputType(p31, p32, p33) -- line: 354
	-- upvalues: t3 (copy), createEmptyRow (copy), t8 (copy), createActionColumns (copy), color3 (copy), color3_2 (copy), t5 (copy), t4 (copy), u10 (ref), TweenService (copy), tweenInfo (copy), t1 (copy)
	local v105 = t3[p33]

	if not v105 then
		v105 = {}
		t3[p33] = v105
	end

	if not v105[p31] then
		local v106 = createEmptyRow("BoundAction", 20)

		v106.Visible = t8[p33]

		local t12 = {}

		for k, v in pairs(p32.inputTypes) do
			t12[k] = tostring(v)
		end

		local _, v111, v112, v113, v114 = createActionColumns(v106, p32.isCore and color3 or color3_2)

		v111.ColumnText.Text = p32.priorityLevel or "Default"
		v112.ColumnText.Text = not p32.isCore and "Developer" or "Core"
		v113.ColumnText.Text = p31
		v114.ColumnText.Text = table.concat(t12, ", ")

		if p32.isCore then
			v111.ColumnText.Font = Enum.Font.SourceSansItalic
			v112.ColumnText.Font = Enum.Font.SourceSansItalic
			v113.ColumnText.Font = Enum.Font.SourceSansItalic
			v114.ColumnText.Font = Enum.Font.SourceSansItalic
		end

		v105[p31] = v106
		t5[v106] = p33
		t4[v106] = p32
		v106.Parent = u10

		if v106.Visible then
			TweenService:Create(v113, tweenInfo, {
				BackgroundColor3 = Color3.new(0.5, 0.5, 0.5)
			}):Play()
		else
			local v115 = t1[p33]

			if v115 then
				TweenService:Create(v115.InputType, tweenInfo, {
					BackgroundColor3 = Color3.new(0.5, 0.5, 0.5)
				}):Play()
			end
		end
	end
end
function t11.updateActionRows(p34, p35) -- line: 402
	-- upvalues: t11 (copy)
	for _, v in pairs(p35.inputTypes) do
		t11.updateBoundInputTypeRow(v)
		t11.updateActionRowForInputType(p34, p35, v)
	end
end
function t11.removeActionRows(p36, p37) -- line: 409
	-- upvalues: t3 (copy), t1 (copy), t7 (copy), updateContainerCanvas (copy), u10 (ref)
	for _, v in pairs(p37.inputTypes) do
		local v124 = t3[v]

		if v124 then
			v124[p36]:Destroy()
			v124[p36] = nil

			local v125 = true

			for _, _ in pairs(v124) do
				v125 = false

				break
			end

			if v125 then
				local v128 = t1[v]

				if v128 then
					v128:Destroy()
					t1[v] = nil
				end

				local v129 = t7[v]

				if v129 then
					t7[v129] = nil
					v129:Destroy()
					t7[v] = nil
				end
			end
		end
	end

	updateContainerCanvas()
	u10.UIListLayout:ApplyLayout()
end
function t11.updateGuis() -- line: 446
	-- upvalues: ContextActionService (copy), t11 (copy), u19 (ref), updateContainerCanvas (copy)
	local AllBoundCoreActionInfo = ContextActionService:GetAllBoundCoreActionInfo()

	for k, v in pairs(AllBoundCoreActionInfo) do
		v.isCore = true
		t11.updateActionRows(k, v)
	end

	local AllBoundActionInfo = ContextActionService:GetAllBoundActionInfo()

	for k, v in pairs(AllBoundActionInfo) do
		v.isCore = false
		t11.updateActionRows(k, v)
	end

	u19 = true
	updateContainerCanvas()
end

return t11
