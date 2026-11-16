local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local GridMetrics = UIBlox.App.Grid.GridMetrics
local DefaultMetricsGridView = UIBlox.App.Grid.DefaultMetricsGridView
local Constants = require(script.Parent.Parent.Parent.Parent.Constants)

local AvatarItemCard = require(script.Parent.AvatarItemCard)
local ItemTile = UIBlox.Tile.ItemTile

local vector2 = Vector2.new(20, 20)

local function createObjectsFolder(items) -- 4 equivalent calls inferred from this helper
	local r15ArtistIntent = Instance.new("Folder")
	r15ArtistIntent.Name = "R15ArtistIntent"

	for _, item in items do
		item.Parent = r15ArtistIntent
	end

	return { r15ArtistIntent }
end

local function getPart(instance, childName: string) -- 15 equivalent calls inferred from this helper
	return (instance:FindFirstChild(childName))
end

local function getItems(clone, _: string)
	local asset = nil
	local asset2 = nil
	local asset3 = nil

	for _, accessory in ipairs(clone:GetChildren()) do
		if not accessory:IsA("Accessory") then
			continue
		end

		if accessory.AccessoryType == Enum.AccessoryType.Eyebrow then
			asset = accessory
		elseif accessory.AccessoryType == Enum.AccessoryType.Eyelash then
			asset2 = accessory
		elseif accessory.AccessoryType == Enum.AccessoryType.Hair then
			asset3 = accessory
		end
	end

	local v = { asset = getPart(clone, "Head"), partName = "Head" } -- inferred equivalent call

	local v2 = { getPart(clone, "UpperTorso"), getPart(clone, "LowerTorso") } -- inferred equivalent call
	local r15ArtistIntent = Instance.new("Folder")
	r15ArtistIntent.Name = "R15ArtistIntent"

	local v3 = { asset = 0, partName = "Torso" }
	local items = { nil, nil, nil, nil, nil, nil }

	for _, v4 in v2 do
		v4.Parent = r15ArtistIntent
	end

	v3.asset = { r15ArtistIntent }

	items[1], items[2], items[3], items[4], items[5], items[6] = v, v3, {
	asset = createObjectsFolder({ getPart(clone, "LeftUpperArm"), getPart(clone, "LeftLowerArm"), getPart(clone, "LeftHand") }),
	partName = "Left Arm"
}, {
	asset = createObjectsFolder({ getPart(clone, "LeftUpperLeg"), getPart(clone, "LeftLowerLeg"), getPart(clone, "LeftFoot") }),
	partName = "Left Leg"
}, {
	asset = createObjectsFolder({ getPart(clone, "RightUpperArm"), getPart(clone, "RightLowerArm"), getPart(clone, "RightHand") }),
	partName = "Right Arm"
}, {
	asset = createObjectsFolder({ getPart(clone, "RightUpperLeg"), getPart(clone, "RightLowerLeg"), getPart(clone, "RightFoot") }),
	partName = "Right Leg"
} -- inferred equivalent call

	if asset then
		table.insert(items, { asset = asset, partName = "Eyebrows" })
	end

	if asset2 then
		table.insert(items, { asset = asset2, partName = "Eyelashes" })
	end

	if asset3 then
		table.insert(items, { asset = asset3, partName = "Hair" })
	end

	return items
end

local function AvatarPartGrid(props)
	local state, setState = React.useState({})
	React.useEffect(function()
		if props.humanoidModel then
			setState(getItems(props.humanoidModel:Clone(), props.name))
			return
		end

		local v = {}

		for i = 1, 6 do
			v[i] = {}
		end

		setState(v)
	end, { props.humanoidModel })

	React.useEffect(function()
		if state[1] and state[1].asset then
			local v = {}

			for k, v2 in state do
				v[k] = { asset = v2.asset, partName = v2.partName }
			end

			setState(v)
		end
	end, { props.name })
	local v

	if props.screenSize.Y > props.screenSize.X then
		v = Constants.ItemCardWidthPortrait
	else
		v = Constants.ItemCardWidthLandscape
	end

	local renderItem = React.useCallback(function(p)
		if p.asset then
			return React.createElement(AvatarItemCard, {
				asset = p.asset,
				bodyName = props.name,
				partName = p.partName,
				viewportSize = v
			})
		end

		return React.createElement(ItemTile)
	end, { v, props.name })

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
					minimumItemWidth = v
				}),
				renderItem = renderItem,
				itemPadding = vector2,
				items = state
			})
		}
	)
end

return AvatarPartGrid
