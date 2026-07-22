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
local t1 = {
	[Enum.AvatarAssetType.FaceMakeup] = "Face Makeup",
	[Enum.AvatarAssetType.LipMakeup] = "Lip Makeup",
	[Enum.AvatarAssetType.EyeMakeup] = "Eye Makeup",
	[Enum.AvatarAssetType.EyebrowAccessory] = "Eyebrow",
	[Enum.AvatarAssetType.EyelashAccessory] = "Eyelash"
}

local function getItemsFromFolder(p1, s1: string, t2: {[any]: any}?, b1: boolean) -- line: 42
	-- upvalues: GetFFlagUploadMakeupSupport (copy), t1 (copy)
	local t3 = {}
	local children = p1:GetChildren()

	for i, v in ipairs(children) do
		if v:IsA("Decal") or v:IsA("Accessory") then
			local v22 = nil
			local v23 = s1
			local assetType = nil

			if t2 and t2[i] then
				assetType = t2[i].assetType
			end

			if b1 then
				if GetFFlagUploadMakeupSupport() then
					local vName = v.Name

					if assetType and t1[assetType] then
						vName = t1[assetType]
					end

					v23 = s1 .. " - " .. vName
				else
					v22 = s1
					v23 = v.Name

					if assetType and t1[assetType] then
						v23 = t1[assetType]
					end
				end
			end

			local v26 = i

			if t2 and t2[i] and t2[i].sortOrder then
				v26 = t2[i].sortOrder
			end

			table.insert(t3, {
				asset = v,
				assetType = assetType,
				bodyName = v22,
				partName = v23,
				LayoutOrder = v26
			})
		end
	end

	table.sort(t3, function(p2, p3) -- line: 92
		return (p2.LayoutOrder or 0) < (p3.LayoutOrder or 0)
	end)

	return t3
end
local function MakeupPartGrid(t4: {[any]: any}) -- line: 99
	-- upvalues: React (copy), getItemsFromFolder (copy), t1 (copy), GetFFlagUploadMakeupSupport (copy), Constants (copy), AvatarItemCard (copy), ItemTile (copy), DefaultMetricsGridView (copy), GridMetrics (copy), vector2 (copy)
	local v28, v29 = React.useState({})
	local v30 = t4.showAssetTypeInLabel == nil or t4.showAssetTypeInLabel

	React.useEffect(function() -- line: 104
		-- upvalues: t4 (copy), v29 (copy), getItemsFromFolder (copy), v30 (copy), t1 (copy)
		if t4.makeupFolder then
			v29((getItemsFromFolder(t4.makeupFolder, t4.name, t4.makeupEntries, v30)))

			return
		end

		if t4.singleDecal then
			local name = nil
			local name2 = t4.name
			local singleAssetType = t4.singleAssetType

			if v30 then
				name = t4.name
				name2 = t4.singleDecal.Name

				if singleAssetType and t1[singleAssetType] then
					name2 = t1[singleAssetType]
				end
			end

			v29({{
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

		v29(t5)
	end, {
		t4.makeupFolder,
		t4.singleDecal
	})
	React.useEffect(function() -- line: 139
		-- upvalues: v28 (copy), GetFFlagUploadMakeupSupport (copy), v30 (copy), t1 (copy), t4 (copy), v29 (copy)
		if v28[1] and v28[1].asset then
			local t6 = {}

			for v40, v41 in v28 do
				local bodyName = v41.bodyName
				local partName = v41.partName

				if GetFFlagUploadMakeupSupport() then
					if v30 then
						local v44 = v41.assetType and t1[v41.assetType] or ""

						partName = t4.name .. " - " .. v44
					else
						partName = t4.name
					end

					bodyName = nil
				elseif v30 then
					bodyName = t4.name
				else
					partName = t4.name
				end

				t6[v40] = {
					asset = v41.asset,
					assetType = v41.assetType,
					bodyName = bodyName,
					partName = partName,
					LayoutOrder = v41.LayoutOrder
				}
			end

			v29(t6)
		end
	end, { t4.name })

	local v31 = if not (t4.screenSize.Y > t4.screenSize.X) then Constants.ItemCardWidthLandscape else Constants.ItemCardWidthPortrait
	local v32 = React.useCallback(function(p4) -- line: 177
		-- upvalues: React (copy), AvatarItemCard (copy), v31 (copy), ItemTile (copy)
		if p4.asset then
			return React.createElement(AvatarItemCard, {
				asset = p4.asset,
				assetType = p4.assetType,
				bodyName = p4.bodyName,
				partName = p4.partName,
				viewportSize = v31
			})
		end

		return React.createElement(ItemTile)
	end, {
		v31,
		t4.name
	})

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = t4.LayoutOrder
	}, {
		Grid = React.createElement(DefaultMetricsGridView, {
			getItemHeight = function(n1: number) -- line: 198
				return n1 * 1.3333333333333333
			end,
			getItemMetrics = GridMetrics.makeCustomMetricsGetter({
				minimumItemsPerRow = 2,
				minimumItemWidth = v31
			}),
			renderItem = v32,
			itemPadding = vector2,
			items = v28
		})
	})
end

return MakeupPartGrid
