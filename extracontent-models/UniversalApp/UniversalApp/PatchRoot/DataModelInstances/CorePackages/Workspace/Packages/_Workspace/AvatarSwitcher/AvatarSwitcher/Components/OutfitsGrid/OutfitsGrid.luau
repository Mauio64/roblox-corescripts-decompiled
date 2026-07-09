local AvatarSwitcher = script:FindFirstAncestor("AvatarSwitcher")
local AvatarSwitcherParent = AvatarSwitcher.Parent
local React = require(AvatarSwitcherParent.React)
local Foundation = require(AvatarSwitcherParent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local FlatList = require(AvatarSwitcherParent.VirtualizedList).FlatList
local OutfitsRow = require(AvatarSwitcher.Components.OutfitsRow)

require(AvatarSwitcher.types)

local v8 = game:DefineFastInt("AvatarSwitcherGridWindowSize", 10)
local v9 = game:DefineFastInt("AvatarSwitcherGridInitialNumToRender", 10)
local v10 = game:DefineFastInt("AvatarSwitcherGridOnEndReachedThreshold", 200) / 100
local v11 = not require(AvatarSwitcherParent.AvatarExperienceFlags).FFlagAvatarSwitcherUiFixes and 108 or game:DefineFastInt("AvatarSwitcherTileSize", 98)

local function OutfitsGrid(t1: {[any]: any}) -- line: 35
	-- upvalues: useTokens (copy), React (copy), OutfitsRow (copy), v11 (copy), Foundation (copy), FlatList (copy), v8 (copy), v9 (copy), v10 (copy)
	local v14 = useTokens()
	local v15, v16 = React.useState(3)

	React.useEffect(function() -- line: 40
		-- upvalues: t1 (copy)
		task.spawn(function() -- line: 41
			-- upvalues: t1 (copy)
			t1.fetchNextOutfitsPage()
		end)
	end, {})

	local v17 = React.useMemo(function() -- line: 46
		-- upvalues: t1 (copy), v15 (copy)
		local t2 = {}

		for i = 1, #t1.outfits, v15 do
			table.insert(t2, { unpack(t1.outfits, i, i + v15 - 1) })
		end

		return t2
	end, {
		t1.outfits,
		v15
	})
	local v18 = React.useCallback(function(p1) -- line: 55
		-- upvalues: React (copy), OutfitsRow (copy), v15 (copy), t1 (copy)
		return React.createElement(OutfitsRow, {
			outfits = p1.item,
			desiredItemsCount = v15,
			rowNumber = p1.index,
			disabled = t1.disabled
		})
	end, { v15 })
	local v19 = React.useCallback(function(p2) -- line: 64
		-- upvalues: v16 (copy), v11 (copy)
		local AbsoluteSizeX = p2.AbsoluteSize.X

		v16((math.max(3, (math.floor(AbsoluteSizeX / v11)))))
	end, {})

	return (React.createElement(Foundation.View, {
		tag = "size-full-full",
		onAbsoluteSizeChanged = v19,
		padding = {
			left = UDim.new(0, -v14.Padding.XXSmall),
			right = UDim.new(0, -v14.Padding.XXSmall)
		}
	}, {
		ClipFrame = React.createElement(Foundation.View, {
			tag = "size-full-full clip",
			padding = {
				top = UDim.new(0, v14.Padding.XXSmall),
				left = UDim.new(0, v14.Padding.XXSmall),
				right = UDim.new(0, v14.Padding.XXSmall)
			}
		}, {
			OutfitsList = React.createElement(FlatList, {
				renderItem = v18,
				data = v17,
				onEndReached = t1.fetchNextOutfitsPage,
				windowSize = v8,
				initialNumToRender = v9,
				onEndReachedThreshold = v10,
				contentContainerStyle = {
					BackgroundTransparency = 1
				},
				style = {
					BackgroundTransparency = 1,
					ScrollBarThickness = 0,
					ClipsDescendants = false
				},
				ListFooterComponent = not t1.lastPageReached and React.createElement(Foundation.View, {
					tag = "size-0-full position-top-center padding-small"
				}, { React.createElement(Foundation.Loading) })
			})
		})
	}))
end

return OutfitsGrid
