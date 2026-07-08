local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local useStyle = require(CorePackages.Packages.UIBlox).Core.Style.useStyle
local AvatarPartViewport = require(script.Parent.AvatarPartViewport)
local GetFFlagSingleUploadMakeupSupport = require(script.Parent.Parent.Parent.Parent.Flags.GetFFlagSingleUploadMakeupSupport)

local function AvatarItemCard(t1: {[any]: any}) -- line: 25
	-- upvalues: useStyle (copy), GetFFlagSingleUploadMakeupSupport (copy), React (copy), AvatarPartViewport (copy)
	local v8 = useStyle()
	local Font = v8.Font
	local Theme = v8.Theme
	local asset = t1.asset
	local CaptionHeader = Font.CaptionHeader
	local TextEmphasisColor = Theme.TextEmphasis.Color

	if GetFFlagSingleUploadMakeupSupport() then
		assert(typeof(asset) == "table" or (asset:IsA("MeshPart") or (asset:IsA("Accessory") or asset:IsA("Decal"))), "Assert that asset is a table, MeshPart, Accessory, or Decal")
	else
		assert(typeof(asset) == "table" or (asset:IsA("MeshPart") or asset:IsA("Accessory")), "Assert that asset is a table, MeshPart, or Accessory")
	end

	local bodyName = t1.bodyName
	local partName = t1.partName
	local v16 = nil
	local v17

	if GetFFlagSingleUploadMakeupSupport() then
		if bodyName and partName then
			v16 = bodyName .. "'s " .. partName
		elseif partName then
			v16 = partName
		end

		v17 = v16 ~= nil
	else
		v17 = bodyName ~= nil and partName ~= nil

		if bodyName and partName then
			v16 = bodyName .. "'s " .. partName
		end
	end

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		LayoutOrder = t1.LayoutOrder
	}, {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 5)
		}),
		AvatarPartViewport = React.createElement(AvatarPartViewport, {
			LayoutOrder = 1,
			asset = asset,
			assetType = if not GetFFlagSingleUploadMakeupSupport() then nil else t1.assetType,
			viewportSize = t1.viewportSize
		}),
		TitleText = v17 and React.createElement("TextLabel", {
			LayoutOrder = 2,
			BackgroundTransparency = 1,
			TextWrapped = true,
			Text = v16,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
			Size = UDim2.new(1, 0, 0, 50),
			TextColor3 = TextEmphasisColor,
			Font = CaptionHeader.Font,
			TextSize = CaptionHeader.RelativeSize * Font.BaseSize,
			TextTruncate = Enum.TextTruncate.AtEnd
		})
	})
end

return AvatarItemCard
