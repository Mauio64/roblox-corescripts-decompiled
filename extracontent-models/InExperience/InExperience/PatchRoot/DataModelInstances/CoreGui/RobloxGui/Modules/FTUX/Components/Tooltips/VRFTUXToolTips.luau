local CorePackages = game:GetService("CorePackages")
local VrCommon = require(CorePackages.Workspace.Packages.VrCommon)
local VRHub = VrCommon.VRHub
local AppCommonLib = require(CorePackages.Workspace.Packages.AppCommonLib)
local IsVRAppBuild = AppCommonLib.IsVRAppBuild
local React = require(CorePackages.Packages.React)

local RunService = game:GetService("RunService")
local ToolTip = require(script.Parent.ToolTip)

local LuauPolyfill = require(CorePackages.Packages.LuauPolyfill)

local v = {}

local function onRenderStepped(_)
	if IsVRAppBuild() then
		for _, v2 in pairs(v) do
			local controllerModel = VRHub:GetControllerModel(v2.Button.Controller)
			local position

			if controllerModel then
				position = controllerModel:getButtonPosition(v2.Button.ButtonKeycode)
			end

			if not v2.Part then
				continue
			end

			if controllerModel == nil or position == nil then
				v2.Part.Position = Vector3.new(-99999, -99999, -99999)
			else
				v2.Part.Position = position
			end
		end
	end
end

function spawnTooltipPart()
	local tooltipPart = Instance.new("Part")
	tooltipPart.Name = "TooltipPart"
	tooltipPart.Position = Vector3.new(0, -100, 0)
	tooltipPart.Anchored = true
	tooltipPart.CanCollide = false
	tooltipPart.Transparency = 1
	tooltipPart.Size = Vector3.new(0.1, 0.1, 0.1)
	tooltipPart.Parent = game.Workspace

	local billboardGui = Instance.new("BillboardGui")
	billboardGui.Parent = tooltipPart
	billboardGui.Adornee = tooltipPart
	billboardGui.AlwaysOnTop = true
	billboardGui.Active = false
	billboardGui.Size = UDim2.new(1, 0, 1, 0)

	return tooltipPart
end

function showTooltipText(p)
	for _, label in ipairs(p.Part:GetDescendants()) do
		if label:IsA("TextLabel") and label.Name == "Body" then
			label.ZIndex = 10
		end
	end
end

function Tooltips(p)
	for k, tooltipButton in pairs(p.tooltipButtons) do
		v[k] = { Button = tooltipButton, Part = spawnTooltipPart() }
	end

	React.useEffect(function()
		for _, v2 in pairs(v) do
			showTooltipText(v2)
		end
	end, {})

	RunService.RenderStepped:Connect(onRenderStepped)

	return React.createElement("Frame", {}, (LuauPolyfill.Array.map(v, function(p2, p3)
		return (React.createElement(ToolTip, {
			controllerPart = p2.Part,
			tooltipText = p.tooltipButtons[p3].Text
		}))
	end)))
end

return Tooltips
