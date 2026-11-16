local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local GridMetrics = UIBlox.App.Grid.GridMetrics
local DefaultMetricsGridView = UIBlox.App.Grid.DefaultMetricsGridView
local ItemTile = UIBlox.Tile.ItemTile

local Constants = require(script.Parent.Parent.Parent.Constants)
local AvatarItemCard = require(script.Parent.Parent.PublishAvatarPrompt.AvatarParts.AvatarItemCard)

local GetFFlagUploadMakeupSupport = require(script.Parent.Parent.Parent.Flags.GetFFlagUploadMakeupSupport)

local vector2 = Vector2.new(20, 20)

local v = {
	[Enum.AvatarAssetType.FaceMakeup] = "Face Makeup",
	[Enum.AvatarAssetType.LipMakeup] = "Lip Makeup",
	[Enum.AvatarAssetType.EyeMakeup] = "Eye Makeup",
	[Enum.AvatarAssetType.EyebrowAccessory] = "Eyebrow",
	[Enum.AvatarAssetType.EyelashAccessory] = "Eyelash"
}

local function getItemsFromFolder(makeupFolder, name: string, makeupEntries, flag: boolean)
	local children = makeupFolder:GetChildren()
	local items = {}

	for sortOrder, instance in ipairs(children) do
		if not (instance:IsA("Decal") or instance:IsA("Accessory")) then
			continue
		end

		local bodyName = nil
		local assetType

		if makeupEntries and makeupEntries[sortOrder] then
			assetType = makeupEntries[sortOrder].assetType
		end

		local partName

		if flag then
			if GetFFlagUploadMakeupSupport() then
				local v2 = instance.Name

				if assetType and v[assetType] then
					v2 = v[assetType]
				end

				partName = name .. " - " .. v2
			else
				partName = instance.Name

				if assetType and v[assetType] then
					partName = v[assetType]
				end

				bodyName = name
			end
		else
			partName = name
		end

		if makeupEntries and makeupEntries[sortOrder] and makeupEntries[sortOrder].sortOrder then
			sortOrder = makeupEntries[sortOrder].sortOrder
		end

		table.insert(items, {
			asset = instance,
			assetType = assetType,
			bodyName = bodyName,
			partName = partName,
			LayoutOrder = sortOrder
		})
	end

	table.sort(items, function(a, b): boolean
		return (a.LayoutOrder or 0) < (b.LayoutOrder or 0)
	end)

	return items
end

local function MakeupPartGrid(props)
	local state, setState = React.useState({})

	local v2 = props.showAssetTypeInLabel == nil or props.showAssetTypeInLabel

	React.useEffect(function()
		if props.makeupFolder then
			setState(getItemsFromFolder(props.makeupFolder, props.name, props.makeupEntries, v2))
		elseif props.singleDecal then
			local partName = props.name
			local singleAssetType = props.singleAssetType
			local name

			if v2 then
				name = props.name
				partName = props.singleDecal.Name

				if singleAssetType and v[singleAssetType] then
					partName = v[singleAssetType]
				end
			end

			setState({
				{
					asset = props.singleDecal,
					assetType = singleAssetType,
					bodyName = name,
					partName = partName,
					LayoutOrder = 1
				}
			})
		else
			local v3 = {}

			v3[1] = {}
			v3[2] = {}

			setState(v3)
		end
	end, { props.makeupFolder, props.singleDecal })

	React.useEffect(function()
		if state[1] and state[1].asset then
			local v3 = {}

			for k, v4 in state do
				local bodyName = v4.bodyName
				local partName = v4.partName

				if GetFFlagUploadMakeupSupport() then
					if v2 then
						local v5 = v4.assetType and v[v4.assetType] or ""
						partName = props.name .. " - " .. v5
					else
						partName = props.name
					end

					bodyName = nil
				elseif v2 then
					bodyName = props.name
				else
					partName = props.name
				end

				v3[k] = {
					asset = v4.asset,
					assetType = v4.assetType,
					bodyName = bodyName,
					partName = partName,
					LayoutOrder = v4.LayoutOrder
				}
			end

			setState(v3)
		end
	end, { props.name })
	local v3

	if props.screenSize.Y > props.screenSize.X then
		v3 = Constants.ItemCardWidthPortrait
	else
		v3 = Constants.ItemCardWidthLandscape
	end

	local renderItem = React.useCallback(function(props2)
		if props2.asset then
			return React.createElement(AvatarItemCard, {
				asset = props2.asset,
				assetType = props2.assetType,
				bodyName = props2.bodyName,
				partName = props2.partName,
				viewportSize = v3
			})
		end

		return React.createElement(ItemTile)
	end, { v3, props.name })

	return React.createElement(
		"Frame",
		{
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			LayoutOrder = props.LayoutOrder,
			BackgroundTransparency = 1
		},
		{
			Grid = React.createElement(DefaultMetricsGridView, {
				getItemHeight = function(p: number)
					return p * (4 / 3)
				end,
				getItemMetrics = GridMetrics.makeCustomMetricsGetter({
					minimumItemsPerRow = 2,
					minimumItemWidth = v3
				}),
				renderItem = renderItem,
				itemPadding = vector2,
				items = state
			})
		}
	)
end

return MakeupPartGrid
