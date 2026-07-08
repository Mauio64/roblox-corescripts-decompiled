local CorePackages = game:GetService("CorePackages")

game:GetService("CoreGui")

local RunService = game:GetService("RunService")
local Roact = require(CorePackages.Packages.Roact)

require(CorePackages.Packages.RoactRodux)

local _ = require(CorePackages.Packages.UIBlox).App.ImageSet.Images
local v5 = Roact.PureComponent:extend("WatermarkComponent")
local PolicyService = game:GetService("PolicyService")

function v5.init(p1) -- line: 17
	-- upvalues: RunService (copy), PolicyService (copy)
	local function UpdateWatermarkVisibility() -- line: 18
		-- upvalues: p1 (copy), RunService (copy), PolicyService (copy)
		p1:setState({
			watermarkVisible = not RunService:IsStudio() and (PolicyService.IsLuobuServer == Enum.TriStateBoolean.True and PolicyService.LuobuWhitelisted == Enum.TriStateBoolean.False)
		})
	end

	PolicyService:GetPropertyChangedSignal("IsLuobuServer"):connect(function() -- line: 26
		-- upvalues: UpdateWatermarkVisibility (copy)
		UpdateWatermarkVisibility()
	end)
	PolicyService:GetPropertyChangedSignal("LuobuWhitelisted"):connect(function() -- line: 30
		-- upvalues: UpdateWatermarkVisibility (copy)
		UpdateWatermarkVisibility()
	end)
	p1:setState({
		watermarkVisible = false,
		absoluteSize = Vector2.new(0, 0)
	})

	function p1.onAbsoluteSizeChange(p2) -- line: 39
		-- upvalues: p1 (copy)
		p1:setState({
			absoluteSize = p2.AbsoluteSize
		})
	end

	UpdateWatermarkVisibility()
end
function v5.render(p3) -- line: 48
	-- upvalues: Roact (copy)
	local function CalculateRotatedFrameWidth() -- line: 49
		-- upvalues: p3 (copy)
		return p3.state.absoluteSize.X * 0.9681476403781077 + p3.state.absoluteSize.Y * 0.25038000405444144
	end
	local function CalculateRotatedFrameHeight() -- line: 54
		-- upvalues: p3 (copy)
		return p3.state.absoluteSize.Y * 0.9681476403781077 + p3.state.absoluteSize.X * 0.25038000405444144
	end
	local function CreateGridItems() -- line: 59
		-- upvalues: p3 (copy), Roact (copy)
		local v14 = math.ceil((p3.state.absoluteSize.X * 0.9681476403781077 + p3.state.absoluteSize.Y * 0.25038000405444144) / 450)
		local t1 = {}

		for i = 0, math.ceil((p3.state.absoluteSize.Y * 0.9681476403781077 + p3.state.absoluteSize.X * 0.25038000405444144) / 450) - 1 do
			for j = 0, v14 - 1 do
				table.insert(t1, Roact.createElement("TextLabel", {
					BackgroundTransparency = 1,
					TextTransparency = 0.75,
					Text = "仅用于测试，\n非正式发表。",
					TextSize = 30,
					TextColor3 = Color3.new(1, 1, 1),
					Size = UDim2.new(0, 225, 0, 225),
					Position = UDim2.new(0, j * 450, 0, i * 450)
				}))
				table.insert(t1, Roact.createElement("TextLabel", {
					BackgroundTransparency = 1,
					TextTransparency = 0.91,
					Text = "仅用于测试，\n非正式发表。",
					TextSize = 30,
					TextColor3 = Color3.new(0, 0, 0),
					Size = UDim2.new(0, 225, 0, 225),
					Position = UDim2.new(0, j * 450 + 1, 0, i * 450 + 1)
				}))
				table.insert(t1, Roact.createElement("TextLabel", {
					BackgroundTransparency = 1,
					TextTransparency = 0.75,
					Text = "仅用于测试，\n非正式发表。",
					TextSize = 30,
					TextColor3 = Color3.new(1, 1, 1),
					Size = UDim2.new(0, 225, 0, 225),
					Position = UDim2.new(0, j * 450 + 225, 0, i * 450 + 225)
				}))
				table.insert(t1, Roact.createElement("TextLabel", {
					BackgroundTransparency = 1,
					TextTransparency = 0.91,
					Text = "仅用于测试，\n非正式发表。",
					TextSize = 30,
					TextColor3 = Color3.new(0, 0, 0),
					Size = UDim2.new(0, 225, 0, 225),
					Position = UDim2.new(0, j * 450 + 226, 0, i * 450 + 226)
				}))
			end
		end

		return t1
	end

	return p3.state.watermarkVisible and Roact.createElement("ScreenGui", {
		IgnoreGuiInset = true,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		AutoLocalize = false,
		DisplayOrder = 10,
		[Roact.Change.AbsoluteSize] = p3.onAbsoluteSizeChange
	}, {
		FullScreenFrame = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Rotation = 14.5,
			Size = UDim2.new(0, p3.state.absoluteSize.X * 0.9681476403781077 + p3.state.absoluteSize.Y * 0.25038000405444144, 0, p3.state.absoluteSize.Y * 0.9681476403781077 + p3.state.absoluteSize.X * 0.25038000405444144),
			Position = UDim2.new(0, (p3.state.absoluteSize.X - (p3.state.absoluteSize.X * 0.9681476403781077 + p3.state.absoluteSize.Y * 0.25038000405444144)) * 0.5, 0, (p3.state.absoluteSize.Y - (p3.state.absoluteSize.Y * 0.9681476403781077 + p3.state.absoluteSize.X * 0.25038000405444144)) * 0.5)
		}, (CreateGridItems()))
	}) or nil
end

return v5
