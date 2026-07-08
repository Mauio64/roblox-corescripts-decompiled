local AvatarExperienceInspectAndBuy = script:FindFirstAncestor("AvatarExperienceInspectAndBuy")
local AvatarExperienceInspectAndBuyParent = AvatarExperienceInspectAndBuy.Parent
local React = require(AvatarExperienceInspectAndBuyParent.React)
local Foundation = require(AvatarExperienceInspectAndBuyParent.Foundation)
local Skeleton = Foundation.Skeleton
local useTokens = Foundation.Hooks.useTokens
local ViewType = require(AvatarExperienceInspectAndBuy.Enums.ViewType)

require(AvatarExperienceInspectAndBuy.Types)

local ItemCardRowContainer = require(AvatarExperienceInspectAndBuy.Components.ItemsView.ItemCardRowContainer)

local function v9(p1, p2) -- line: 45
	-- upvalues: ViewType (copy)
	if p1 == ViewType.WideLandscape then
		return {
			left = UDim.new(0, p2.Padding.XLarge),
			right = UDim.new(0, p2.Padding.XLarge),
			bottom = UDim.new(0, p2.Padding.Large)
		}
	end

	if p1 == ViewType.Compact then
		return {
			left = UDim.new(0, p2.Padding.Large),
			right = UDim.new(0, p2.Padding.Large),
			bottom = UDim.new(0, p2.Padding.Large)
		}
	end

	return {
		top = UDim.new(0, p2.Padding.Medium),
		left = UDim.new(0, p2.Margin.Large * 2),
		right = UDim.new(0, p2.Margin.Large * 2),
		bottom = UDim.new(0, p2.Padding.Large)
	}
end

return (React.forwardRef(function(t1: {[any]: any}, p3) -- line: 68
	-- upvalues: useTokens (copy), React (copy), ViewType (copy), v9 (copy), ItemCardRowContainer (copy), Skeleton (copy)
	local v14 = useTokens()
	local v15 = t1.headerHeightOffset or 0
	local v16 = t1.actionBarHeightOffset or 0
	local v17 = React.useMemo(function() -- line: 73
		-- upvalues: t1 (copy), ViewType (copy), v14 (copy)
		if t1.view == ViewType.Wide then
			return v14.Size.Size_2500
		end

		return v14.Size.Size_2000
	end, {
		t1.view,
		v14
	})
	local v18 = React.useCallback(function() -- line: 81
		-- upvalues: v9 (copy), t1 (copy), v14 (copy), React (copy), ItemCardRowContainer (copy), v17 (copy), Skeleton (copy)
		local v20 = v9(t1.view, v14)
		local t2 = {
			UIListLayout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical,
				Padding = UDim.new(0, v14.Padding.Large)
			}),
			UIPadding = React.createElement("UIPadding", {
				PaddingTop = v20.top,
				PaddingLeft = v20.left,
				PaddingRight = v20.right,
				PaddingBottom = v20.bottom
			})
		}

		if t1.items and #t1.items > 0 then
			for v22, v23 in t1.items do
				t2["Item" .. v22] = React.createElement(ItemCardRowContainer, {
					item = v23,
					view = t1.view,
					LayoutOrder = v22,
					onItemCardActivated = t1.onItemCardActivated,
					itemCardWidth = v17
				})
			end

			return t2
		end

		for i = 1, 5 do
			t2["Skeleton" .. i] = React.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, v17),
				LayoutOrder = i
			}, {
				Skeleton = React.createElement(Skeleton, {
					Size = UDim2.new(1, 0, 1, 0)
				})
			})
		end

		return t2
	end, {
		t1.items,
		t1.view,
		v16,
		v14
	})
	local v19 = React.useMemo(function() -- line: 130
		-- upvalues: t1 (copy), ViewType (copy), v15 (copy), v14 (copy), v16 (copy)
		if t1.view == ViewType.Compact then
			return UDim2.new(1, 0, 1, -v15 - v14.Padding.Small - v16)
		end

		return UDim2.new(1, 0, 1, -v15 - v14.Padding.Small)
	end, {
		t1.view,
		v15,
		v14,
		v16
	})

	return React.createElement("ScrollingFrame", {
		ScrollBarThickness = 0,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		LayoutOrder = 2,
		Size = v19,
		Position = UDim2.new(0, 0, 0, v15),
		CanvasSize = UDim2.new(1, 0, 0, 0),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		ScrollingDirection = Enum.ScrollingDirection.Y,
		ref = p3
	}, v18())
end))
