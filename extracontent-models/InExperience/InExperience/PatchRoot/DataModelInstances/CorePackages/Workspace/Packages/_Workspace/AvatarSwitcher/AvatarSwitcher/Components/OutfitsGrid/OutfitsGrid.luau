local AvatarSwitcher = script:FindFirstAncestor("AvatarSwitcher")
local parent = AvatarSwitcher.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local VirtualizedList = require(parent.VirtualizedList)
local FlatList = VirtualizedList.FlatList

local OutfitsRow = require(AvatarSwitcher.Components.OutfitsRow)
require(AvatarSwitcher.types)

local defineFastInt = game:DefineFastInt("AvatarSwitcherGridWindowSize", 10)
local defineFastInt2 = game:DefineFastInt("AvatarSwitcherGridInitialNumToRender", 10)
local onEndReachedThreshold = game:DefineFastInt("AvatarSwitcherGridOnEndReachedThreshold", 200) / 100

local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local v = not AvatarExperienceFlags.FFlagAvatarSwitcherUiFixes and 108
	or game:DefineFastInt("AvatarSwitcherTileSize", 98)

local function OutfitsGrid(props)
	local v2 = useTokens()

	local state, setState = React.useState(3)

	React.useEffect(function()
		task.spawn(function()
			props.fetchNextOutfitsPage()
		end)
	end, {})

	local v3 = React.useMemo(function()
		local result = {}

		for i = 1, #props.outfits, state do
			table.insert(result, { unpack(props.outfits, i, i + state - 1) })
		end

		return result
	end, { props.outfits, state })

	local renderItem = React.useCallback(function(p)
		return React.createElement(OutfitsRow, {
			outfits = p.item,
			desiredItemsCount = state,
			rowNumber = p.index,
			disabled = props.disabled
		})
	end, { state })

	local onAbsoluteSizeChanged = React.useCallback(function(p)
		setState((math.max(3, (math.floor(p.AbsoluteSize.X / v)))))
	end, {})

	return (React.createElement(Foundation.View, {
		tag = "size-full-full",
		onAbsoluteSizeChanged = onAbsoluteSizeChanged,
		padding = {
			left = UDim.new(0, -v2.Padding.XXSmall),
			right = UDim.new(0, -v2.Padding.XXSmall)
		}
	}, {
		ClipFrame = React.createElement(Foundation.View, {
			tag = "size-full-full clip",
			padding = {
				top = UDim.new(0, v2.Padding.XXSmall),
				left = UDim.new(0, v2.Padding.XXSmall),
				right = UDim.new(0, v2.Padding.XXSmall)
			}
		}, {
			OutfitsList = React.createElement(FlatList, {
				renderItem = renderItem,
				data = v3,
				onEndReached = props.fetchNextOutfitsPage,
				windowSize = defineFastInt,
				initialNumToRender = defineFastInt2,
				onEndReachedThreshold = onEndReachedThreshold,
				contentContainerStyle = { BackgroundTransparency = 1 },
				style = {
					BackgroundTransparency = 1,
					ScrollBarThickness = 0,
					ClipsDescendants = false
				},
				ListFooterComponent = not props.lastPageReached and React.createElement(
					Foundation.View,
					{ tag = "size-0-full position-top-center padding-small" },
					{ React.createElement(Foundation.Loading) }
				)
			})
		})
	}))
end

return OutfitsGrid
