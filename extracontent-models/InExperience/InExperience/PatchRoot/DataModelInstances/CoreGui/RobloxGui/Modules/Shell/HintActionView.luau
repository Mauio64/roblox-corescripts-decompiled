local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local shell = CoreGui:FindFirstChild("RobloxGui"):FindFirstChild("Modules"):FindFirstChild("Shell")

local ContextActionService = game:GetService("ContextActionService")
local TextService = game:GetService("TextService")

local GlobalSettings = require(shell:FindFirstChild("GlobalSettings"))
local Utility = require(shell:FindFirstChild("Utility"))
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local AppCommonLib = require(CorePackages.Workspace.Packages.AppCommonLib)
local Create = AppCommonLib.Create

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local getFFlagDebugLuaAppAlwaysUseGamepad = SharedFlags.getFFlagDebugLuaAppAlwaysUseGamepad

local function createHintActionView(parent2, list, p)
	if p == nil then
		p = UDim2.new(1, -1, 1, -1)
	end

	local v = (list == nil or #list == 0) and "DefaultHintAction" or list

	local parent3 = Create("Frame")({
		Name = "HintActionContainer",
		Size = UDim2.new(0, 0, 0, 0),
		BackgroundTransparency = 1,
		Parent = parent2
	})

	local v2 = Create("TextLabel")({
		Name = "HintActionText",
		BackgroundTransparency = 1,
		Font = GlobalSettings.RegularFont,
		FontSize = GlobalSettings.TitleSize,
		TextColor3 = GlobalSettings.WhiteTextColor,
		TextXAlignment = Enum.TextXAlignment.Right,
		Text = "",
		ZIndex = 10,
		Parent = parent3
	})

	local v3 = Create("ImageLabel")({
		Name = "HintActionImage",
		Size = UDim2.new(0, 83, 0, 83),
		BackgroundTransparency = 1,
		Image = "",
		ZIndex = 10,
		Parent = parent3
	})

	local function updateLayout()
		local textSize = TextService:GetTextSize(
			v2.Text,
			Utility.ConvertFontSizeEnumToInt(v2.FontSize),
			v2.Font,
			Vector2.new(0, 0)
		)
		v2.Size = UDim2.new(0, textSize.x, 0, v3.Size.Y.Offset)
		v2.Position = UDim2.new(1, -textSize.x, 0, -4)

		local v4 = textSize.x + v3.Size.X.Offset + 8

		parent3.Size = UDim2.new(0, v4, 0, v3.Size.Y.Offset)

		parent3.Position = UDim2.new(
			p.X.Scale,
			p.X.Offset * parent3.Size.X.Offset,
			p.Y.Scale,
			p.Y.Offset * parent3.Size.Y.Offset
		)
	end

	return {
		BindAction = function(_, p2, p3)
			if not p2 then
				return
			end

			ContextActionService:UnbindCoreAction(v)

			if getFFlagDebugLuaAppAlwaysUseGamepad() and RoactGamepad.Config.DebugKeyboardBindings then
				local v4 = RoactGamepad.Config.DebugKeyboardBindings[p3] or {}
				ContextActionService:BindCoreAction(v, p2, false, p3, table.unpack(v4))
			else
				ContextActionService:BindCoreAction(v, p2, false, p3)
			end
		end,
		UnbindAction = function(_)
			ContextActionService:UnbindCoreAction(v)
		end,
		SetParent = function(_, parent)
			parent3.Parent = parent
		end,
		SetVisible = function(_, visible)
			parent3.Visible = visible
		end,
		SetTransparency = function(_, p2)
			v2.TextTransparency = p2
			v3.ImageTransparency = p2
		end,
		SetVisibleWithTween = function(_, p2)
			Utility.PropertyTweener(v2, "TextTransparency", v2.TextTransparency, p2, 0.25, Utility.EaseOutQuad, true)
			Utility.PropertyTweener(v3, "ImageTransparency", v3.ImageTransparency, p2, 0.25, Utility.EaseOutQuad, true)
		end,
		SetText = function(_, text)
			if text == v2.Text then
				return
			end

			v2.Text = text
			updateLayout()
		end,
		SetImage = function(_, image)
			if image == v3.Image then
				return
			end

			v3.Image = image
		end
	}
end

return createHintActionView
