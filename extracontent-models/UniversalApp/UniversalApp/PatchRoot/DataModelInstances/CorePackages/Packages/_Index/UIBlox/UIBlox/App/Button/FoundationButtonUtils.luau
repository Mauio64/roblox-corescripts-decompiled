local parent = script.Parent
local parent2 = parent.Parent
local parent3 = parent2.Parent
local parent4 = parent3.Parent
local core = parent3.Core

local Foundation = require(parent4.Foundation)
local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize

local GetTextSize = require(core.Text.GetTextSize)

local BuilderIcons = require(parent4.BuilderIcons)
local uiblox = BuilderIcons.Migration.uiblox

local ButtonType = require(parent.Enum.ButtonType)
local StandardButtonSize = require(core.Button.Enum.StandardButtonSize)

local ImagesInverse = require(parent2.ImageSet.ImagesInverse)

local buttonMapping = {
	[ButtonType.Alert] = ButtonVariant.Alert,
	[ButtonType.PrimaryContextual] = ButtonVariant.Emphasis,
	[ButtonType.PrimarySystem] = ButtonVariant.SubEmphasis,
	[ButtonType.Secondary] = ButtonVariant.Subtle
}

local sizeMapping = {
	[StandardButtonSize.Regular] = InputSize.Large,
	[StandardButtonSize.Small] = InputSize.Small,
	[StandardButtonSize.XSmall] = InputSize.XSmall
}

local v = {
	[StandardButtonSize.Regular] = false,
	[StandardButtonSize.Small] = false,
	[StandardButtonSize.XSmall] = true
}

local v2 = {
	[InputSize.XSmall] = { padding = "Small", typography = "Small", height = "Size_600" },
	[InputSize.Small] = { padding = "Small", typography = "Small", height = "Size_800" },
	[InputSize.Medium] = { padding = "Medium", typography = "Medium", height = "Size_1000" },
	[InputSize.Large] = { padding = "Medium", typography = "Large", height = "Size_1200" }
}

local vector2 = Vector2.new(10000, 10000)
local FoundationButtonUtils = {}
FoundationButtonUtils.buttonMapping = buttonMapping
FoundationButtonUtils.sizeMapping = sizeMapping

function FoundationButtonUtils.findIcon(p)
	if not p then
		return nil
	end

	local v3

	if p.Image and uiblox[p.Image] ~= nil then
		v3 = p.Image
	else
		v3 = ImagesInverse[p]
	end

	if v3 == nil then
		warn("Icon not found")
	end

	return v3
end

function FoundationButtonUtils.getSizeMapping(p, udim: UDim2?, p2)
	if p then
		return sizeMapping[p]
	end

	if not udim then
		return nil
	end

	if udim.Y.Offset >= p2.Size.Size_1200 then
		return InputSize.Large
	end

	if udim.Y.Scale > 0 or udim.Y.Offset >= p2.Size.Size_1000 then
		return InputSize.Medium
	end

	if udim.Y.Offset >= p2.Size.Size_800 then
		return InputSize.Small
	end

	return InputSize.XSmall
end

function FoundationButtonUtils.getWidth(p: string?, udim: UDim2?, flag: boolean?)
	if p then
		local v3 = v[p]

		if flag == nil then
			flag = v3
		end

		if flag then
			return nil
		end

		return UDim.new(1, 0)
	end

	if udim then
		return udim.X
	end

	if flag then
		return nil
	end

	return UDim.new(1, 0)
end

function FoundationButtonUtils.getMaxWidth(p: string?, p2: number?)
	if p == nil then
		return nil
	end

	return if p2 == nil then 640 else p2
end

function FoundationButtonUtils.getFitContentSize(p: string, p2: string?, data)
	local v3

	if p2 then
		v3 = sizeMapping[p2]
	end

	local v4

	if v3 then
		v4 = v2[v3]
	end

	if not v4 then
		return nil
	end

	local v5 = data.Typography["Label" .. v4.typography]
	local x = GetTextSize(p, v5.FontSize, v5.Font, vector2).X

	return Vector2.new(math.ceil(x) + data.Padding[v4.padding] * 2, data.Size[v4.height])
end

function FoundationButtonUtils.getTestId(value: string?)
	if value and #value ~= 0 then
		return value:match("data%-testid=([^%s]+)")
	end

	return nil
end

return FoundationButtonUtils
