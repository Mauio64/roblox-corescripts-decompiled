local CoreGui = game:GetService("CoreGui")
local ContextActionService = game:GetService("ContextActionService")
local TweenService = game:GetService("TweenService")
local CorePackages = game:GetService("CorePackages")

CoreGui:WaitForChild("RobloxGui")
local AppCommonLib = require(CorePackages.Workspace.Packages.AppCommonLib)
local Create = AppCommonLib.Create

local color = Color3.new(0.1, 0, 0)
local color2 = Color3.new(0, 0, 0)

TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)

local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, 0, true, 0)
local tweenInfo2 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)

local parent = nil
local v = {}
local v2 = {}
local v3 = {}
local dataByEmptyRow = {}
local v4 = {}
local v5 = {}
local v6 = {}
local v7 = {}

local flag = true

local _ = { BoundInputType = 3, TableHeader = 2, BoundAction = 1 }

local function sortInputTypeRows(p, p2): boolean
	local v8 = v2[p]
	local v9 = v2[p2]
	return tostring(v8) < tostring(v9)
end

local function sortActionRows(p, p2): boolean
	local v8 = dataByEmptyRow[p]
	local v9 = dataByEmptyRow[p2]

	if not (v8 and v9) then
		return true
	end

	local v10 = v4[p]
	local v11 = v4[p2]

	if v10 ~= v11 then
		return tostring(v10) < tostring(v11)
	end

	if v8.isCore and not v9.isCore then
		return true
	end

	if not v8.isCore and v9.isCore then
		return false
	end

	local stackOrder = v8.stackOrder
	local stackOrder2 = v9.stackOrder

	return not (stackOrder and stackOrder2) or stackOrder2 < stackOrder
end

local function createEmptyRow(name, value)
	local emptyRow = Create("Frame")({
		Name = name,
		BackgroundTransparency = 1,
		ZIndex = 6,
		Size = UDim2.new(1, 0, 0, value or 0)
	})

	Create("UIListLayout")({
		FillDirection = Enum.FillDirection.Horizontal,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 5),
		Parent = emptyRow
	})

	return emptyRow
end

local function createButtonRow(name, value)
	local buttonRow = Create("TextButton")({
		Name = name,
		BackgroundTransparency = 1,
		ZIndex = 6,
		Text = "",
		Size = UDim2.new(1, 0, 0, value or 0)
	})

	Create("UIListLayout")({
		FillDirection = Enum.FillDirection.Horizontal,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 5),
		Parent = buttonRow
	})

	return buttonRow
end

local function createEmptyColumn(parent2, name)
	return (Create("Frame")({
		Name = name,
		BackgroundColor3 = Color3.new(0, 0, 0),
		BackgroundTransparency = 0.75,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 1, 0),
		ZIndex = 6,
		ClipsDescendants = true,
		Parent = parent2
	}))
end

local function createImageColumn(buttonRow, name, image, value, value2)
	local emptyColumn = createEmptyColumn(buttonRow, name)

	Create("UIAspectRatioConstraint")({
		AspectRatio = value or 1,
		Parent = emptyColumn
	})

	Create("ImageLabel")({
		Name = "ColumnImage",
		BackgroundTransparency = 1,
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = UDim2.new(value2 or 1, 0, value2 or 1, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		ZIndex = 6,
		Image = image,
		Parent = emptyColumn
	})

	return emptyColumn
end

local function createTextColumn(parent2, name, text)
	local emptyColumn = createEmptyColumn(parent2, name)

	Create("TextLabel")({
		Name = "ColumnText",
		BackgroundTransparency = 1,
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = UDim2.new(1, -10, 1, -10),
		AnchorPoint = Vector2.new(0.5, 0.5),
		ZIndex = 6,
		Text = text,
		TextSize = 18,
		TextColor3 = Color3.new(1, 1, 1),
		TextXAlignment = Enum.TextXAlignment.Left,
		Font = Enum.Font.SourceSans,
		Parent = emptyColumn
	})

	return emptyColumn
end

local function createActionColumns(emptyRow, backgroundColor)
	local emptyColumn = createEmptyColumn(emptyRow, "Inset")
	emptyColumn.LayoutOrder = 0
	emptyColumn.BackgroundTransparency = 1
	emptyColumn.Size = UDim2.new(0, 30, 1, 0)

	local textColumn = createTextColumn(emptyRow, "Priority", "Priority")
	textColumn.LayoutOrder = 1
	textColumn.BackgroundColor3 = backgroundColor
	textColumn.Size = UDim2.new(0, 80, 1, 0)

	local textColumn2 = createTextColumn(emptyRow, "Security", "Security")
	textColumn2.LayoutOrder = 2
	textColumn2.BackgroundColor3 = backgroundColor
	textColumn2.Size = UDim2.new(0, 80, 1, 0)

	local textColumn3 = createTextColumn(emptyRow, "ActionName", "Action Name")
	textColumn3.LayoutOrder = 3
	textColumn3.BackgroundColor3 = backgroundColor
	textColumn3.Size = UDim2.new(0.25, 0, 1, 0)

	local textColumn4 = createTextColumn(emptyRow, "InputTypes", "Input Types")
	textColumn4.LayoutOrder = 4
	textColumn4.BackgroundColor3 = backgroundColor
	textColumn4.Size = UDim2.new(0.75, -(0 + 30 + 5 + 80 + 5 + 80 + 5) - 5, 1, 0)

	return emptyColumn, textColumn, textColumn2, textColumn3, textColumn4
end

local function updateContainerCanvas()
	debug.profilebegin("updateContainerCanvas")

	if flag then
		flag = false

		local v8 = {}
		local layoutOrder = 1

		for _, v9 in pairs(v) do
			table.insert(v8, v9)
		end

		table.sort(v8, sortInputTypeRows)

		for _, v9 in pairs(v8) do
			local v10 = v2[v9]
			v9.LayoutOrder = layoutOrder
			layoutOrder += 1
			local v11 = v6[v10]

			if v11 then
				v11.LayoutOrder = layoutOrder
				layoutOrder += 1
			end

			local v12 = v3[v10]

			if not v12 then
				continue
			end

			local v13 = {}

			for _, v14 in pairs(v12) do
				table.insert(v13, v14)
			end

			table.sort(v13, sortActionRows)

			for _, v14 in pairs(v13) do
				v14.LayoutOrder = layoutOrder
				layoutOrder += 1
			end
		end
	end

	debug.profileend()
end

local function scrollContainerToRow(buttonRow)
	local v8 = buttonRow.AbsolutePosition.Y - parent.AbsolutePosition.Y
	local canvasPosition = parent.CanvasPosition + Vector2.new(0, v8)
	TweenService:Create(parent, tweenInfo2, { CanvasPosition = canvasPosition }):Play()
end

local ActionBindingsTab = {}

function ActionBindingsTab.initializeGui(parent2)
	local parent3 = Create("ScrollingFrame")({
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = UDim2.new(1, -10, 1, -10),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BorderSizePixel = 0,
		ScrollBarThickness = 4,
		BackgroundTransparency = 1,
		ZIndex = 6,
		Parent = parent2
	})

	parent = parent3

	local v8 = Create("UIListLayout")({ Padding = UDim.new(0, 5), Parent = parent3 })

	v8.SortOrder = Enum.SortOrder.LayoutOrder
	v8:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		parent.CanvasSize = UDim2.new(0, 0, 0, v8.AbsoluteContentSize.Y)
	end)

	ActionBindingsTab.updateGuis()

	ContextActionService.BoundActionAdded:connect(function(p, _, p2, isCore)
		p2.isCore = isCore
		ActionBindingsTab.updateActionRows(p, p2)

		flag = true
		updateContainerCanvas()
	end)
	ContextActionService.BoundActionRemoved:connect(function(p, p2, isCore)
		p2.isCore = isCore
		ActionBindingsTab.removeActionRows(p, p2)

		flag = true
		updateContainerCanvas()
	end)
end

function ActionBindingsTab.updateBoundInputTypeRow(p)
	if not v[p] then
		local buttonRow = createButtonRow("BoundInputType", 30)

		local imageColumn = createImageColumn(
			buttonRow,
			"ExpandImage",
			"rbxasset://textures/ui/ExpandArrowSheet.png",
			1,
			0.35
		)
		imageColumn.ColumnImage.ImageRectSize = Vector2.new(21, 21)
		imageColumn.ColumnImage.ImageRectOffset = Vector2.new(0, 0)

		local textColumn = createTextColumn(buttonRow, "InputType", tostring(p))
		textColumn.Size = UDim2.new(1, -35, 1, 0)
		textColumn.ColumnText.Font = Enum.Font.SourceSansBold

		local emptyRow = createEmptyRow("TableHeader", 20)
		emptyRow.Visible = false
		local _, parent2, parent3, parent4, parent5 = createActionColumns(emptyRow, color2)
		parent2.ColumnText.Font = Enum.Font.SourceSansBold
		parent3.ColumnText.Font = Enum.Font.SourceSansBold
		parent4.ColumnText.Font = Enum.Font.SourceSansBold
		parent5.ColumnText.Font = Enum.Font.SourceSansBold

		v[p] = buttonRow
		v2[buttonRow] = p
		v5[emptyRow] = p
		v6[p] = emptyRow

		emptyRow.Parent = parent
		buttonRow.Parent = parent

		TweenService:Create(textColumn, tweenInfo, { BackgroundColor3 = Color3.new(0.5, 0.5, 0.5) }):Play()

		v7[p] = false
		buttonRow.MouseButton1Click:connect(function()
			v7[p] = not v7[p]

			local v8 = v3[p]

			if v7[p] then
				imageColumn.ColumnImage.ImageRectOffset = Vector2.new(21, 0)
				emptyRow.Visible = true

				if v8 then
					for _, v9 in pairs(v8) do
						v9.Visible = true
					end
				end
			else
				imageColumn.ColumnImage.ImageRectOffset = Vector2.new(0, 0)
				emptyRow.Visible = false

				if v8 then
					for _, v9 in pairs(v8) do
						v9.Visible = false
					end
				end
			end

			updateContainerCanvas()

			if v7[p] then
				TweenService:Create(textColumn, tweenInfo, {
					BackgroundColor3 = Color3.new(0.5, 0.5, 0.5)
				}):Play()
				scrollContainerToRow(buttonRow)
			end
		end)
	end
end

function ActionBindingsTab.updateActionRowForInputType(text, data, p)
	local emptyRowsByText = v3[p]

	if not emptyRowsByText then
		emptyRowsByText = {}
		v3[p] = emptyRowsByText
	end

	if not emptyRowsByText[text] then
		local emptyRow = createEmptyRow("BoundAction", 20)
		emptyRow.Visible = v7[p]

		local v8 = {}

		for k, inputType in pairs(data.inputTypes) do
			v8[k] = tostring(inputType)
		end

		local _, parent2, parent3, parent4, parent5 = createActionColumns(emptyRow, data.isCore and color or color2)
		parent2.ColumnText.Text = data.priorityLevel or "Default"
		parent3.ColumnText.Text = data.isCore and "Core" or "Developer"
		parent4.ColumnText.Text = text
		parent5.ColumnText.Text = table.concat(v8, ", ")

		if data.isCore then
			parent2.ColumnText.Font = Enum.Font.SourceSansItalic
			parent3.ColumnText.Font = Enum.Font.SourceSansItalic
			parent4.ColumnText.Font = Enum.Font.SourceSansItalic
			parent5.ColumnText.Font = Enum.Font.SourceSansItalic
		end

		emptyRowsByText[text] = emptyRow
		v4[emptyRow] = p
		dataByEmptyRow[emptyRow] = data
		emptyRow.Parent = parent

		if emptyRow.Visible then
			TweenService:Create(parent4, tweenInfo, { BackgroundColor3 = Color3.new(0.5, 0.5, 0.5) }):Play()
		else
			local v9 = v[p]

			if v9 then
				TweenService:Create(v9.InputType, tweenInfo, {
					BackgroundColor3 = Color3.new(0.5, 0.5, 0.5)
				}):Play()
			end
		end
	end
end

function ActionBindingsTab.updateActionRows(p, p2)
	for _, inputType in pairs(p2.inputTypes) do
		ActionBindingsTab.updateBoundInputTypeRow(inputType)
		ActionBindingsTab.updateActionRowForInputType(p, p2, inputType)
	end
end

function ActionBindingsTab.removeActionRows(p, p2)
	for _, inputType in pairs(p2.inputTypes) do
		local v8 = v3[inputType]

		if not v8 then
			continue
		end

		v8[p]:Destroy()
		v8[p] = nil

		local flag2 = true

		for _, _ in pairs(v8) do
			flag2 = false
			break
		end

		if not flag2 then
			continue
		end

		local v9 = v[inputType]

		if v9 then
			v9:Destroy()
			v[inputType] = nil
		end

		local v10 = v6[inputType]

		if not v10 then
			continue
		end

		v6[v10] = nil
		v10:Destroy()
		v6[inputType] = nil
	end

	updateContainerCanvas()
	parent.UIListLayout:ApplyLayout()
end

function ActionBindingsTab.updateGuis()
	local allBoundCoreActionInfo = ContextActionService:GetAllBoundCoreActionInfo()

	for k, v8 in pairs(allBoundCoreActionInfo) do
		v8.isCore = true
		ActionBindingsTab.updateActionRows(k, v8)
	end

	local allBoundActionInfo = ContextActionService:GetAllBoundActionInfo()

	for k, v8 in pairs(allBoundActionInfo) do
		v8.isCore = false
		ActionBindingsTab.updateActionRows(k, v8)
	end

	flag = true
	updateContainerCanvas()
end

return ActionBindingsTab
