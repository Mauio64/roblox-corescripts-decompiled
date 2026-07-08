local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local GridMetrics = UIBlox.App.Grid.GridMetrics
local DefaultMetricsGridView = UIBlox.App.Grid.DefaultMetricsGridView
local ItemTile = UIBlox.Tile.ItemTile
local Constants = require(script.Parent.Parent.Parent.Constants)
local AvatarItemCard = require(script.Parent.Parent.PublishAvatarPrompt.AvatarParts.AvatarItemCard)
local vector2 = Vector2.new(20, 20)
local t1 = {
	[Enum.AvatarAssetType.FaceMakeup] = "Face Makeup",
	[Enum.AvatarAssetType.LipMakeup] = "Lip Makeup",
	[Enum.AvatarAssetType.EyeMakeup] = "Eye Makeup",
	[Enum.AvatarAssetType.EyebrowAccessory] = "Eyebrow",
	[Enum.AvatarAssetType.EyelashAccessory] = "Eyelash"
}

local function getItemsFromFolder(p1, s1: string, t2: {[any]: any}?, b1: boolean) -- line: 40
	-- upvalues: t1 (copy)
	local t3 = {}
	local children = p1:GetChildren()

	for i, v in ipairs(children) do
		if v:IsA("Decal") or v:IsA("Accessory") then
			local v21 = nil
			local v22 = s1
			local assetType = nil

			if t2 and t2[i] then
				assetType = t2[i].assetType
			end

			if b1 then
				v21 = s1
				v22 = v.Name

				if assetType and t1[assetType] then
					v22 = t1[assetType]
				end
			end

			local v24 = i

			if t2 and t2[i] and t2[i].sortOrder then
				v24 = t2[i].sortOrder
			end

			table.insert(t3, {
				asset = v,
				assetType = assetType,
				bodyName = v21,
				partName = v22,
				LayoutOrder = v24
			})
		end
	end

	table.sort(t3, function(p2, p3) -- line: 82
		return (p2.LayoutOrder or 0) < (p3.LayoutOrder or 0)
	end)

	return t3
end
local function MakeupPartGrid(t4: {[any]: any}) -- line: 89
	-- upvalues: React (copy), getItemsFromFolder (copy), t1 (copy), Constants (copy), AvatarItemCard (copy), ItemTile (copy), DefaultMetricsGridView (copy), GridMetrics (copy), vector2 (copy)
	local v26, v27 = React.useState({})
	local v28 = t4.showAssetTypeInLabel == nil or t4.showAssetTypeInLabel

	React.useEffect(function() -- line: 94
		-- upvalues: t4 (copy), v27 (copy), getItemsFromFolder (copy), v28 (copy), t1 (copy)
		if t4.makeupFolder then
			v27((getItemsFromFolder(t4.makeupFolder, t4.name, t4.makeupEntries, v28)))

			return
		end

		if t4.singleDecal then
			local name = nil
			local name2 = t4.name
			local singleAssetType = t4.singleAssetType

			if v28 then
				name = t4.name
				name2 = t4.singleDecal.Name

				if singleAssetType and t1[singleAssetType] then
					name2 = t1[singleAssetType]
				end
			end

			v27({{
				LayoutOrder = 1,
				asset = t4.singleDecal,
				assetType = singleAssetType,
				bodyName = name,
				partName = name2
			}})

			return
		end

		local t5 = {
			[1] = {},
			[2] = {}
		}

		v27(t5)
	end, {
		t4.makeupFolder,
		t4.singleDecal
	})
	React.useEffect(function() -- line: 129
		-- upvalues: v26 (copy), v28 (copy), t4 (copy), v27 (copy)
		if v26[1] and v26[1].asset then
			local t6 = {}

			for v38, v39 in v26 do
				local bodyName = v39.bodyName
				local partName = v39.partName

				if v28 then
					bodyName = t4.name
				else
					partName = t4.name
				end

				t6[v38] = {
					asset = v39.asset,
					assetType = v39.assetType,
					bodyName = bodyName,
					partName = partName,
					LayoutOrder = v39.LayoutOrder
				}
			end

			v27(t6)
		end
	end, { t4.name })

	local v29 = if not (t4.screenSize.Y > t4.screenSize.X) then Constants.ItemCardWidthLandscape else Constants.ItemCardWidthPortrait
	local v30 = React.useCallback(function(p4) -- line: 157
		-- upvalues: React (copy), AvatarItemCard (copy), v29 (copy), ItemTile (copy)
		if p4.asset then
			return React.createElement(AvatarItemCard, {
				asset = p4.asset,
				assetType = p4.assetType,
				bodyName = p4.bodyName,
				partName = p4.partName,
				viewportSize = v29
			})
		end

		return React.createElement(ItemTile)
	end, {
		v29,
		t4.name
	})

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = t4.LayoutOrder
	}, {
		Grid = React.createElement(DefaultMetricsGridView, {
			getItemHeight = function(n1: number) -- line: 178
				return n1 * 1.3333333333333333
			end,
			getItemMetrics = GridMetrics.makeCustomMetricsGetter({
				minimumItemsPerRow = 2,
				minimumItemWidth = v29
			}),
			renderItem = v30,
			itemPadding = vector2,
			items = v26
		})
	})
end

return MakeupPartGrid
