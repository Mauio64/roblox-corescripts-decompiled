local AvatarExperienceSearch = script:FindFirstAncestor("AvatarExperienceSearch")
local AvatarExperienceSearchParent = AvatarExperienceSearch.Parent
local React = require(AvatarExperienceSearchParent.React)
local AXCommon = require(AvatarExperienceSearchParent.AXCommon)
local SuggestedItem = require(AvatarExperienceSearch.Components.SuggestedItem)
local Divider = require(AvatarExperienceSearch.Components.Divider)
local AXRecentlyViewedSearchItemsIXPTest = AXCommon.Experiments.AXRecentlyViewedSearchItemsIXPTest

local function SuggestedItemList(t1: {[any]: any}) -- line: 31
	-- upvalues: React (copy), SuggestedItem (copy), Divider (copy), AXRecentlyViewedSearchItemsIXPTest (copy)
	local v10 = React.useMemo(function() -- line: 32
		-- upvalues: React (copy), t1 (copy), SuggestedItem (copy), Divider (copy)
		local t2 = {
			Layout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical
			})
		}

		for v12, v13 in t1.items do
			t2[`SuggestedItem{ v12 }`] = React.createElement("Frame", {
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.XY,
				AnchorPoint = Vector2.new(0, 0),
				Position = UDim2.new(0, 0, 0, 0),
				LayoutOrder = v12
			}, {
				ItemLayout = React.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Vertical
				}),
				Item = React.createElement(SuggestedItem, {
					layoutOrder = 0,
					text = v13.text,
					type = v13.type,
					onActivate = v13.onActivate,
					onTrailingButtonActivate = v13.onRemove,
					ref = if v12 ~= 1 then nil else t1.firstSuggestedItemRef
				}),
				Divider = if not (v12 < #t1.items) then nil else React.createElement(Divider, {
					layoutOrder = 1
				})
			})
		end

		return t2
	end, { t1.items })

	return React.createElement("ScrollingFrame", {
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		ScrollBarThickness = 0,
		Selectable = false,
		AutomaticCanvasSize = Enum.AutomaticSize.XY,
		AutomaticSize = if not AXRecentlyViewedSearchItemsIXPTest.isEnabled() or not t1.disableScroll then nil else Enum.AutomaticSize.Y,
		CanvasSize = UDim2.fromScale(1, 1),
		ScrollingDirection = Enum.ScrollingDirection.Y,
		Size = UDim2.fromScale(1, 1)
	}, v10)
end

return SuggestedItemList
