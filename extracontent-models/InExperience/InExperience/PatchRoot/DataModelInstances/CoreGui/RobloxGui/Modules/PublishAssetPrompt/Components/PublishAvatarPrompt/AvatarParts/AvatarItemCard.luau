local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local FoundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
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
	local titleText

	if GetFFlagSingleUploadMakeupSupport() then
		if bodyName and partName then
			text = bodyName .. "'s " .. partName
		else
			text = partName or text
		end

		titleText = text ~= nil
	else
		if bodyName == nil then
			titleText = false
		else
			titleText = partName ~= nil
		end

		if bodyName and partName then
			text = bodyName .. "'s " .. partName
		end
	end

	local createElement = React.createElement
	local v2 = {
		Size = UDim2.fromScale(1, 1),
		LayoutOrder = props.LayoutOrder,
		BackgroundTransparency = 1
	}

	local v3 = {
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

	v3.AvatarPartViewport = createElement2(AvatarPartViewport, {
		asset = asset,
		assetType = assetType,
		LayoutOrder = 1,
		viewportSize = props.viewportSize
	})

	if titleText then
		local createElement3 = React.createElement
		local v4 = {
			LayoutOrder = 2,
			BackgroundTransparency = 1,
			Text = text,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
			Size = UDim2.new(1, 0, 0, 50),
			TextColor3 = color,
			TextWrapped = true,
			Font = 0,
			FontFace = 0,
			TextSize = 0,
			TextTruncate = 0
		}
		local font2

		if not FoundationFontFaceMigration then
			font2 = captionHeader.Font
		end

		v4.Font = font2
		local fontFace

		if FoundationFontFaceMigration then
			fontFace = normalizeFontFace(v.Tokens.Typography.CaptionLarge.Font)
		end

		v4.FontFace = fontFace

		v4.TextSize = captionHeader.RelativeSize * font.BaseSize
		v4.TextTruncate = Enum.TextTruncate.AtEnd
		titleText = createElement3("TextLabel", v4)
	end

	v3.TitleText = titleText
	return createElement("Frame", v2, v3)
end

return AvatarItemCard
