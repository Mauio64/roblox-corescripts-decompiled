local CorePackages = game:GetService("CorePackages")
local Shell = game:GetService("CoreGui"):FindFirstChild("RobloxGui"):FindFirstChild("Modules"):FindFirstChild("Shell")
local ContextActionService = game:GetService("ContextActionService")
local TextService = game:GetService("TextService")
local GlobalSettings = require(Shell:FindFirstChild("GlobalSettings"))
local Utility = require(Shell:FindFirstChild("Utility"))
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local Create = require(CorePackages.Workspace.Packages.AppCommonLib).Create
local getFFlagDebugLuaAppAlwaysUseGamepad = require(CorePackages.Workspace.Packages.SharedFlags).getFFlagDebugLuaAppAlwaysUseGamepad

local function createHintActionView(p1, p2, p3) -- line: 26
	-- upvalues: Create (copy), GlobalSettings (copy), TextService (copy), Utility (copy), ContextActionService (copy), getFFlagDebugLuaAppAlwaysUseGamepad (copy), RoactGamepad (copy)
	if p3 == nil then
		p3 = UDim2.new(1, -1, 1, -1)
	end

	local t1 = {}

	if p2 == nil or #p2 == 0 then
		p2 = "DefaultHintAction"
	end

	local v17 = Create("Frame")({
		Name = "HintActionContainer",
		BackgroundTransparency = 1,
		Size = UDim2.new(0, 0, 0, 0),
		Parent = p1
	})
	local v18 = Create("TextLabel")({
		Name = "HintActionText",
		BackgroundTransparency = 1,
		Text = "",
		ZIndex = 10,
		Font = GlobalSettings.RegularFont,
		FontSize = GlobalSettings.TitleSize,
		TextColor3 = GlobalSettings.WhiteTextColor,
		TextXAlignment = Enum.TextXAlignment.Right,
		Parent = v17
	})
	local v19 = Create("ImageLabel")({
		Name = "HintActionImage",
		BackgroundTransparency = 1,
		Image = "",
		ZIndex = 10,
		Size = UDim2.new(0, 83, 0, 83),
		Parent = v17
	})

	local function updateLayout() -- line: 69
		-- upvalues: TextService (copy), v18 (copy), Utility (copy), v19 (copy), v17 (copy), p3 (ref)
		local TextSize = TextService:GetTextSize(v18.Text, Utility.ConvertFontSizeEnumToInt(v18.FontSize), v18.Font, Vector2.new(0, 0))

		v18.Size = UDim2.new(0, TextSize.x, 0, v19.Size.Y.Offset)
		v18.Position = UDim2.new(1, -TextSize.x, 0, -4)

		local v22 = TextSize.x + v19.Size.X.Offset + 8

		v17.Size = UDim2.new(0, v22, 0, v19.Size.Y.Offset)
		v17.Position = UDim2.new(p3.X.Scale, p3.X.Offset * v17.Size.X.Offset, p3.Y.Scale, p3.Y.Offset * v17.Size.Y.Offset)
	end

	function t1.BindAction(_, p5, p6) -- line: 86
		-- upvalues: ContextActionService (copy), p2 (ref), getFFlagDebugLuaAppAlwaysUseGamepad (copy), RoactGamepad (copy)
		if not p5 then
			return
		end

		ContextActionService:UnbindCoreAction(p2)

		if getFFlagDebugLuaAppAlwaysUseGamepad() and RoactGamepad.Config.DebugKeyboardBindings then
			local v26 = RoactGamepad.Config.DebugKeyboardBindings[p6] or {}

			ContextActionService:BindCoreAction(p2, p5, false, p6, table.unpack(v26))

			return
		end

		ContextActionService:BindCoreAction(p2, p5, false, p6)
	end
	function t1.UnbindAction(_) -- line: 100
		-- upvalues: ContextActionService (copy), p2 (ref)
		ContextActionService:UnbindCoreAction(p2)
	end
	function t1.SetParent(_, p9) -- line: 104
		-- upvalues: v17 (copy)
		v17.Parent = p9
	end
	function t1.SetVisible(_, p11) -- line: 108
		-- upvalues: v17 (copy)
		v17.Visible = p11
	end
	function t1.SetTransparency(_, p13) -- line: 112
		-- upvalues: v18 (copy), v19 (copy)
		v18.TextTransparency = p13
		v19.ImageTransparency = p13
	end
	function t1.SetVisibleWithTween(_, p15) -- line: 117
		-- upvalues: Utility (copy), v18 (copy), v19 (copy)
		Utility.PropertyTweener(v18, "TextTransparency", v18.TextTransparency, p15, 0.25, Utility.EaseOutQuad, true)
		Utility.PropertyTweener(v19, "ImageTransparency", v19.ImageTransparency, p15, 0.25, Utility.EaseOutQuad, true)
	end
	function t1.SetText(_, p17) -- line: 122
		-- upvalues: v18 (copy), updateLayout (copy)
		if p17 == v18.Text then
			return
		end

		v18.Text = p17
		updateLayout()
	end
	function t1.SetImage(_, p19) -- line: 131
		-- upvalues: v19 (copy)
		if p19 == v19.Image then
			return
		end

		v19.Image = p19
	end

	return t1
end

return createHintActionView
