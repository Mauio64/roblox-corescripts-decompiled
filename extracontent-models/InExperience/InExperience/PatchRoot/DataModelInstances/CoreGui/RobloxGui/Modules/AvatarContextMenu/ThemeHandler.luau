local InsertService = game:GetService("InsertService")
local StarterGui = game:GetService("StarterGui")
local t1 = {
	BackgroundImage = "rbxasset://textures/blackBkg_round.png",
	BackgroundImageTransparency = 0,
	BackgroundTransparency = 1,
	ButtonFrameTransparency = 0,
	ButtonImage = "",
	ButtonTransparency = 1,
	ButtonHoverTransparency = 0.5,
	TextScale = 1,
	LeaveMenuImage = "rbxasset://textures/loading/cancelButton.png",
	ScrollRightImage = "rbxasset://textures/ui/AvatarContextMenu_Arrow.png",
	ScrollLeftImage = "",
	AspectRatio = 1.15,
	BackgroundImageScaleType = Enum.ScaleType.Slice,
	BackgroundImageSliceCenter = Rect.new(12, 12, 12, 12),
	BackgroundColor = Color3.fromRGB(31, 31, 31),
	NameTagColor = Color3.fromRGB(79, 79, 79),
	NameUnderlineColor = Color3.fromRGB(255, 255, 255),
	ButtonFrameColor = Color3.fromRGB(79, 79, 79),
	ButtonImageScaleType = Enum.ScaleType.Slice,
	ButtonImageSliceCenter = Rect.new(8, 6, 46, 44),
	ButtonColor = Color3.fromRGB(79, 79, 79),
	ButtonHoverColor = Color3.fromRGB(163, 162, 165),
	ButtonUnderlineColor = Color3.fromRGB(137, 137, 137),
	Font = Enum.Font.SourceSansBold,
	TextColor = Color3.fromRGB(255, 255, 255),
	SelectedCharacterIndicator = InsertService:LoadLocalAsset("rbxasset://models/AvatarContextMenu/AvatarContextArrow.rbxm"),
	Size = UDim2.new(0.95, 0, 0.9, 0),
	MinSize = Vector2.new(200, 200),
	MaxSize = Vector2.new(300, 300),
	AnchorPoint = Vector2.new(0.5, 1),
	OnScreenPosition = UDim2.new(0.5, 0, 0.98, 0),
	OffScreenPosition = UDim2.new(0.5, 0, 1, 300)
}
local t2 = {}

t2.__index = t2

function t2.UpdateTheme(p1, p2) -- line: 56
	-- upvalues: t1 (copy)
	local t3 = {}

	for k, v in pairs(t1) do
		if typeof(p2[k]) == typeof(v) then
			t3[k] = p2[k]
		elseif p2[k] == nil then
			t3[k] = v
		else
			error(string.format("AvatarContextMenuTheme wrong type for key %s: %s. Expected type %s", k, typeof(p2[k]), (typeof(v))), 2)
		end
	end

	p1.Theme = t3
end
function t2.RegisterCoreMethods(p3) -- line: 75
	-- upvalues: t1 (copy), StarterGui (copy)
	local function setMenuTheme(p4) -- line: 76
		-- upvalues: t1 (copy), p3 (copy)
		if type(p4) == "table" then
			for k in pairs(p4) do
				if t1[k] == nil then
					error(string.format("AvatarContextMenuTheme got invalid key: %s", k))
				end
			end

			p3:UpdateTheme(p4)

			return
		end

		error("AvatarContextMenuTheme argument must be a table")
	end

	StarterGui:RegisterSetCore("AvatarContextMenuTheme", setMenuTheme)
end
function t2.GetTheme(p5) -- line: 93
	return p5.Theme
end
function t2.new() -- line: 97
	-- upvalues: t2 (copy), t1 (copy)
	local self = setmetatable({}, t2)

	self.Theme = t1
	self:RegisterCoreMethods()

	return self
end

return t2.new()
