local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local useStyle = UIBlox.Core.Style.useStyle

local AvatarPartViewport = require(script.Parent.AvatarPartViewport)

local GetFFlagSingleUploadMakeupSupport = require(script.Parent.Parent.Parent.Parent.Flags.GetFFlagSingleUploadMakeupSupport)

local function AvatarItemCard(props)
	local v = useStyle()
	local font = v.Font
	local theme = v.Theme
	local asset = props.asset

	local captionHeader = font.CaptionHeader
	local color = theme.TextEmphasis.Color

	if GetFFlagSingleUploadMakeupSupport() then
		assert(
			typeof(asset) == "table" or (asset:IsA("MeshPart") or asset:IsA("Accessory") or asset:IsA("Decal")),
			"Assert that asset is a table, MeshPart, Accessory, or Decal"
		)
	else
		assert(
			typeof(asset) == "table" or (asset:IsA("MeshPart") or asset:IsA("Accessory")),
			"Assert that asset is a table, MeshPart, or Accessory"
		)
	end

	local bodyName = props.bodyName
	local partName = props.partName

	local text = nil
	local v2

	if GetFFlagSingleUploadMakeupSupport() then
		if bodyName and partName then
			text = bodyName .. "'s " .. partName
		else
			text = partName or text
		end

		v2 = text ~= nil
	else
		if bodyName == nil then
			v2 = false
		else
			v2 = partName ~= nil
		end

		if bodyName and partName then
			text = bodyName .. "'s " .. partName
		end
	end

	local createElement = React.createElement
	local v3 = {
		Size = UDim2.fromScale(1, 1),
		LayoutOrder = props.LayoutOrder,
		BackgroundTransparency = 1
	}

	local v4 = {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 5)
		}),
		AvatarPartViewport = 0,
		TitleText = 0
	}

	local createElement2 = React.createElement
	local assetType

	if GetFFlagSingleUploadMakeupSupport() then
		assetType = props.assetType
	end

	v4.AvatarPartViewport = createElement2(AvatarPartViewport, {
		asset = asset,
		assetType = assetType,
		LayoutOrder = 1,
		viewportSize = props.viewportSize
	})

	v4.TitleText = v2 and React.createElement("TextLabel", {
		LayoutOrder = 2,
		BackgroundTransparency = 1,
		Text = text,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
		Size = UDim2.new(1, 0, 0, 50),
		TextColor3 = color,
		TextWrapped = true,
		FontFace = normalizeFontFace(v.Tokens.Typography.CaptionLarge.Font),
		TextSize = captionHeader.RelativeSize * font.BaseSize,
		TextTruncate = Enum.TextTruncate.AtEnd
	})
	return createElement("Frame", v3, v4)
end

return AvatarItemCard
