local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local GridMetrics = UIBlox.App.Grid.GridMetrics
local DefaultMetricsGridView = UIBlox.App.Grid.DefaultMetricsGridView
local Constants = require(script.Parent.Parent.Parent.Parent.Constants)
local AvatarItemCard = require(script.Parent.AvatarItemCard)
local ItemTile = UIBlox.Tile.ItemTile
local vector2 = Vector2.new(20, 20)

local function createObjectsFolder(t1: {[any]: any}) -- line: 33
	local Folder = Instance.new("Folder")

	Folder.Name = "R15ArtistIntent"

	for _, v17 in t1 do
		v17.Parent = Folder
	end

	return {
		[1] = Folder
	}
end
local function getPart(p1, s1: string) -- line: 43
	return (p1:FindFirstChild(s1))
end
local function getItems(p2, _: string) -- line: 47
	local v22 = nil
	local v23 = nil
	local v24 = nil

	for _, child in ipairs(p2:GetChildren()) do
		if child:IsA("Accessory") then
			if child.AccessoryType == Enum.AccessoryType.Eyebrow then
				v23 = child
			elseif child.AccessoryType == Enum.AccessoryType.Eyelash then
				v22 = child
			elseif child.AccessoryType == Enum.AccessoryType.Hair then
				v24 = child
			end
		end
	end

	local t2 = {}
	local t3 = {
		partName = "Head",
		asset = p2:FindFirstChild("Head")
	}
	local t4 = {
		partName = "Torso"
	}
	local t5 = {
		p2:FindFirstChild("UpperTorso"),
		(p2:FindFirstChild("LowerTorso"))
	}
	local Folder = Instance.new("Folder")

	Folder.Name = "R15ArtistIntent"

	for _, v33 in t5 do
		v33.Parent = Folder
	end

	t4.asset = {
		[1] = Folder
	}

	local t6 = {
		partName = "Left Arm"
	}
	local t7 = {
		p2:FindFirstChild("LeftUpperArm"),
		p2:FindFirstChild("LeftLowerArm"),
		(p2:FindFirstChild("LeftHand"))
	}
	local Folder2 = Instance.new("Folder")

	Folder2.Name = "R15ArtistIntent"

	for _, v38 in t7 do
		v38.Parent = Folder2
	end

	t6.asset = {
		[1] = Folder2
	}

	local t8 = {
		partName = "Left Leg"
	}
	local t9 = {
		p2:FindFirstChild("LeftUpperLeg"),
		p2:FindFirstChild("LeftLowerLeg"),
		(p2:FindFirstChild("LeftFoot"))
	}
	local Folder3 = Instance.new("Folder")

	Folder3.Name = "R15ArtistIntent"

	for _, v43 in t9 do
		v43.Parent = Folder3
	end

	t8.asset = {
		[1] = Folder3
	}

	local t10 = {
		partName = "Right Arm"
	}
	local t11 = {
		p2:FindFirstChild("RightUpperArm"),
		p2:FindFirstChild("RightLowerArm"),
		(p2:FindFirstChild("RightHand"))
	}
	local Folder4 = Instance.new("Folder")

	Folder4.Name = "R15ArtistIntent"

	for _, v48 in t11 do
		v48.Parent = Folder4
	end

	t10.asset = {
		[1] = Folder4
	}

	local t12 = {
		partName = "Right Leg"
	}
	local t13 = {
		p2:FindFirstChild("RightUpperLeg"),
		p2:FindFirstChild("RightLowerLeg"),
		(p2:FindFirstChild("RightFoot"))
	}
	local Folder5 = Instance.new("Folder")

	Folder5.Name = "R15ArtistIntent"

	for _, v53 in t13 do
		v53.Parent = Folder5
	end

	t12.asset = {
		[1] = Folder5
	}
	t2[1] = t3
	t2[2] = t4
	t2[3] = t6
	t2[4] = t8
	t2[5] = t10
	t2[6] = t12

	if v23 then
		table.insert(t2, {
			partName = "Eyebrows",
			asset = v23
		})
	end

	if v22 then
		table.insert(t2, {
			partName = "Eyelashes",
			asset = v22
		})
	end

	if v24 then
		table.insert(t2, {
			partName = "Hair",
			asset = v24
		})
	end

	return t2
end
local function AvatarPartGrid(t14: {[any]: any}) -- line: 132
	-- upvalues: React (copy), getItems (copy), Constants (copy), AvatarItemCard (copy), ItemTile (copy), DefaultMetricsGridView (copy), GridMetrics (copy), vector2 (copy)
	local v55, v56 = React.useState({})

	React.useEffect(function() -- line: 134
		-- upvalues: t14 (copy), v56 (copy), getItems (copy)
		if t14.humanoidModel then
			local clone = t14.humanoidModel:Clone()

			v56((getItems(clone, t14.name)))

			return
		end

		local t15 = {}

		for i = 1, 6 do
			t15[i] = {}
		end

		v56(t15)
	end, { t14.humanoidModel })
	React.useEffect(function() -- line: 150
		-- upvalues: v55 (copy), v56 (copy)
		if v55[1] and v55[1].asset then
			local t16 = {}

			for v63, v64 in v55 do
				t16[v63] = {
					asset = v64.asset,
					partName = v64.partName
				}
			end

			v56(t16)
		end
	end, { t14.name })

	local v57 = if not (t14.screenSize.Y > t14.screenSize.X) then Constants.ItemCardWidthLandscape else Constants.ItemCardWidthPortrait
	local v58 = React.useCallback(function(p3) -- line: 168
		-- upvalues: React (copy), AvatarItemCard (copy), t14 (copy), v57 (copy), ItemTile (copy)
		if p3.asset then
			return React.createElement(AvatarItemCard, {
				asset = p3.asset,
				bodyName = t14.name,
				partName = p3.partName,
				viewportSize = v57
			})
		end

		return React.createElement(ItemTile)
	end, {
		v57,
		t14.name
	})

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = t14.LayoutOrder
	}, {
		Grid = React.createElement(DefaultMetricsGridView, {
			getItemHeight = function(n1: number) -- line: 190
				return n1 * 1.3333333333333333
			end,
			getItemMetrics = GridMetrics.makeCustomMetricsGetter({
				minimumItemsPerRow = 2,
				minimumItemWidth = v57
			}),
			renderItem = v58,
			itemPadding = vector2,
			items = v55
		})
	})
end

return AvatarPartGrid
