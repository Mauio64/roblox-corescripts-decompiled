local CorePackages = game:GetService("CorePackages")
game:GetService("CoreGui")
local RunService = game:GetService("RunService")

local Roact = require(CorePackages.Packages.Roact)
require(CorePackages.Packages.RoactRodux)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Images = UIBlox.App.ImageSet.Images

local extended = Roact.PureComponent:extend("WatermarkComponent")
local PolicyService = game:GetService("PolicyService")

function extended:init()
	local function UpdateWatermarkVisibility()
		local watermarkVisible = not RunService:IsStudio()

		if watermarkVisible then
			if PolicyService.IsLuobuServer == Enum.TriStateBoolean.True then
				watermarkVisible = PolicyService.LuobuWhitelisted == Enum.TriStateBoolean.False
			else
				watermarkVisible = false
			end
		end

		self:setState({ watermarkVisible = watermarkVisible })
	end

	PolicyService:GetPropertyChangedSignal("IsLuobuServer"):connect(function()
		UpdateWatermarkVisibility()
	end)

	PolicyService:GetPropertyChangedSignal("LuobuWhitelisted"):connect(function()
		UpdateWatermarkVisibility()
	end)

	self:setState({ absoluteSize = Vector2.new(0, 0), watermarkVisible = false })

	function self.onAbsoluteSizeChange(p)
		self:setState({ absoluteSize = p.AbsoluteSize })
	end

	UpdateWatermarkVisibility()
end

function extended.render(p)
	local function CalculateRotatedFrameWidth() -- 3 equivalent calls inferred from this helper
		return p.state.absoluteSize.X * 0.9681476403781077 + p.state.absoluteSize.Y * 0.25038000405444144
	end

	local function CalculateRotatedFrameHeight() -- 3 equivalent calls inferred from this helper
		return p.state.absoluteSize.Y * 0.9681476403781077 + p.state.absoluteSize.X * 0.25038000405444144
	end

	local function CreateGridItems()
		local v = math.ceil(CalculateRotatedFrameWidth() / 450) -- inferred equivalent call

		local children = {}

		for i = 0, math.ceil(CalculateRotatedFrameHeight() / 450) - 1 do -- inferred equivalent call
			for j = 0, v - 1 do
				table.insert(children, Roact.createElement("TextLabel", {
					BackgroundTransparency = 1,
					TextTransparency = 0.75,
					Text = "仅用于测试，\n非正式发表。",
					TextSize = 30,
					TextColor3 = Color3.new(1, 1, 1),
					Size = UDim2.new(0, 225, 0, 225),
					Position = UDim2.new(0, j * 450, 0, i * 450)
				}))

				table.insert(children, Roact.createElement("TextLabel", {
					BackgroundTransparency = 1,
					TextTransparency = 0.91,
					Text = "仅用于测试，\n非正式发表。",
					TextSize = 30,
					TextColor3 = Color3.new(0, 0, 0),
					Size = UDim2.new(0, 225, 0, 225),
					Position = UDim2.new(0, j * 450 + 1, 0, i * 450 + 1)
				}))

				table.insert(children, Roact.createElement("TextLabel", {
					BackgroundTransparency = 1,
					TextTransparency = 0.75,
					Text = "仅用于测试，\n非正式发表。",
					TextSize = 30,
					TextColor3 = Color3.new(1, 1, 1),
					Size = UDim2.new(0, 225, 0, 225),
					Position = UDim2.new(0, j * 450 + 225, 0, i * 450 + 225)
				}))

				table.insert(children, Roact.createElement("TextLabel", {
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

		return children
	end

	local v

	if p.state.watermarkVisible then
		local createElement = Roact.createElement
		local onAbsoluteSizeChangesByAbsoluteSize = {
			IgnoreGuiInset = true,
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
			AutoLocalize = false,
			DisplayOrder = 10,
			[Roact.Change.AbsoluteSize] = p.onAbsoluteSizeChange
		}
		return createElement("ScreenGui", onAbsoluteSizeChangesByAbsoluteSize, {
			FullScreenFrame = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(0, CalculateRotatedFrameWidth(), 0, CalculateRotatedFrameHeight()), -- inferred equivalent call
				Position = UDim2.new(
					0,
					(p.state.absoluteSize.X - CalculateRotatedFrameWidth()) * 0.5, -- inferred equivalent call
					0,
					(p.state.absoluteSize.Y - CalculateRotatedFrameHeight()) * 0.5 -- inferred equivalent call
				),
				Rotation = 14.5
			}, CreateGridItems())
		}) or nil
	end

	return v
end

return extended
