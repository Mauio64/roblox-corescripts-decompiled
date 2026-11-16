local InsertService = game:GetService("InsertService")
local StarterGui = game:GetService("StarterGui")

local theme = {
	BackgroundImage = "rbxasset://textures/blackBkg_round.png",
	BackgroundImageScaleType = Enum.ScaleType.Slice,
	BackgroundImageSliceCenter = Rect.new(12, 12, 12, 12),
	BackgroundImageTransparency = 0,
	BackgroundTransparency = 1,
	BackgroundColor = Color3.fromRGB(31, 31, 31),
	NameTagColor = Color3.fromRGB(79, 79, 79),
	NameUnderlineColor = Color3.fromRGB(255, 255, 255),
	ButtonFrameColor = Color3.fromRGB(79, 79, 79),
	ButtonFrameTransparency = 0,
	ButtonImage = "",
	ButtonImageScaleType = Enum.ScaleType.Slice,
	ButtonImageSliceCenter = Rect.new(8, 6, 46, 44),
	ButtonColor = Color3.fromRGB(79, 79, 79),
	ButtonTransparency = 1,
	ButtonHoverColor = Color3.fromRGB(163, 162, 165),
	ButtonHoverTransparency = 0.5,
	ButtonUnderlineColor = Color3.fromRGB(137, 137, 137),
	Font = Enum.Font.SourceSansBold,
	TextColor = Color3.fromRGB(255, 255, 255),
	TextScale = 1,
	LeaveMenuImage = "rbxasset://textures/loading/cancelButton.png",
	ScrollRightImage = "rbxasset://textures/ui/AvatarContextMenu_Arrow.png",
	ScrollLeftImage = "",
	SelectedCharacterIndicator = InsertService:LoadLocalAsset("rbxasset://models/AvatarContextMenu/AvatarContextArrow.rbxm"),
	Size = UDim2.new(0.95, 0, 0.9, 0),
	MinSize = Vector2.new(200, 200),
	MaxSize = Vector2.new(300, 300),
	AspectRatio = 1.15,
	AnchorPoint = Vector2.new(0.5, 1),
	OnScreenPosition = UDim2.new(0.5, 0, 0.98, 0),
	OffScreenPosition = UDim2.new(0.5, 0, 1, 300)
}

local class = {}
class.__index = class

function class:UpdateTheme(p)
	local theme2 = {}

	for k, v in pairs(theme) do
		if typeof(p[k]) == typeof(v) then
			theme2[k] = p[k]
		elseif p[k] == nil then
			theme2[k] = v
		else
			error(
				string.format(
					"AvatarContextMenuTheme wrong type for key %s: %s. Expected type %s",
					k,
					typeof(p[k]),
					(typeof(v))
				),
				2
			)
		end
	end

	self.Theme = theme2
end

function class:RegisterCoreMethods()
	local function setMenuTheme(items)
		if type(items) ~= "table" then
			error("AvatarContextMenuTheme argument must be a table")

			return
		end

		for k in pairs(items) do
			if theme[k] == nil then
				error(string.format("AvatarContextMenuTheme got invalid key: %s", k))
			end
		end

		self:UpdateTheme(items)
	end
	StarterGui:RegisterSetCore("AvatarContextMenuTheme", setMenuTheme)
end

function class.GetTheme(p)
	return p.Theme
end

function class.new()
	local self = setmetatable({}, class)

	self.Theme = theme

	self:RegisterCoreMethods()

	return self
end

return class.new()
