local CorePackages = game:GetService("CorePackages")
local VRHub = require(CorePackages.Workspace.Packages.VrCommon).VRHub
local IsVRAppBuild = require(CorePackages.Workspace.Packages.AppCommonLib).IsVRAppBuild
local React = require(CorePackages.Packages.React)
local RunService = game:GetService("RunService")
local ToolTip = require(script.Parent.ToolTip)
local LuauPolyfill = require(CorePackages.Packages.LuauPolyfill)
local t1 = {}

local function onRenderStepped(_) -- line: 28
	-- upvalues: IsVRAppBuild (copy), t1 (copy), VRHub (copy)
	if IsVRAppBuild() then
		for _, v in pairs(t1) do
			local ControllerModel = VRHub:GetControllerModel(v.Button.Controller)
			local v14 = nil

			if ControllerModel then
				v14 = ControllerModel:getButtonPosition(v.Button.ButtonKeycode)
			end

			if v.Part then
				if ControllerModel == nil or v14 == nil then
					v.Part.Position = Vector3.new(-99999, -99999, -99999)
				else
					v.Part.Position = v14
				end
			end
		end
	end
end

function spawnTooltipPart() -- line: 49
	local Part = Instance.new("Part")

	Part.Name = "TooltipPart"
	Part.Position = Vector3.new(0, -100, 0)
	Part.Anchored = true
	Part.CanCollide = false
	Part.Transparency = 1
	Part.Size = Vector3.new(0.10000000149011612, 0.10000000149011612, 0.10000000149011612)
	Part.Parent = game.Workspace

	local BillboardGui = Instance.new("BillboardGui")

	BillboardGui.Parent = Part
	BillboardGui.Adornee = Part
	BillboardGui.AlwaysOnTop = true
	BillboardGui.Active = false
	BillboardGui.Size = UDim2.new(1, 0, 1, 0)

	return Part
end
function showTooltipText(t2: {[any]: any}) -- line: 69
	for _, descendant in ipairs(t2.Part:GetDescendants()) do
		if descendant:IsA("TextLabel") and descendant.Name == "Body" then
			descendant.ZIndex = 10
		end
	end
end
function Tooltips(t3: {[any]: any}) -- line: 77
	-- upvalues: t1 (copy), React (copy), RunService (copy), onRenderStepped (copy), LuauPolyfill (copy), ToolTip (copy)
	for k, v in pairs(t3.tooltipButtons) do
		t1[k] = {
			Button = v,
			Part = spawnTooltipPart()
		}
	end

	React.useEffect(function() -- line: 85
		-- upvalues: t1 (copy)
		for _, v in pairs(t1) do
			showTooltipText(v)
		end
	end, {})
	RunService.RenderStepped:Connect(onRenderStepped)

	return React.createElement("Frame", {}, (LuauPolyfill.Array.map(t1, function(p2, p3) -- line: 96
		-- upvalues: React (copy), ToolTip (copy), t3 (copy)
		return (React.createElement(ToolTip, {
			controllerPart = p2.Part,
			tooltipText = t3.tooltipButtons[p3].Text
		}))
	end)))
end

return Tooltips
