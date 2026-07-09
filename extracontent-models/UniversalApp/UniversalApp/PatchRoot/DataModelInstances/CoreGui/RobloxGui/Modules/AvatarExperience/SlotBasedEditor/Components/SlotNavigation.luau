local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local useCallback = React.useCallback
local FitFrameHorizontal = require(CorePackages.Packages.AvatarExperienceDeps).RoactFitComponents.FitFrameHorizontal

require(CorePackages.Workspace.Packages.AvatarExperienceSlotBasedEditor)

local NavHighlight = require(Modules.AvatarExperience.Common.Components.NavBar.NavHighlight)
local DEPRECATED_CategoryButton = require(Modules.AvatarExperience.Common.Components.NavBar.DEPRECATED_CategoryButton)
local ScrollingArrowsAndGradient = require(Modules.AvatarExperience.SlotBasedEditor.Components.ScrollingArrowsAndGradient)
local FFlagAXSlotsDesktopCrashFix = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXSlotsDesktopCrashFix

return function(t1: {[any]: any}) -- line: 34
	-- upvalues: FFlagAXSlotsDesktopCrashFix (copy), React (copy), useCallback (copy), DEPRECATED_CategoryButton (copy), FitFrameHorizontal (copy), NavHighlight (copy), ScrollingArrowsAndGradient (copy)
	local categories = t1.categories
	local slotCategory = t1.slotCategory

	if FFlagAXSlotsDesktopCrashFix then
		React.useEffect(function() -- line: 39
			-- upvalues: categories (copy), slotCategory (copy), t1 (copy)
			if categories[slotCategory].hide and t1.onSlotCategorySelected then
				for v14, v15 in categories do
					if not v15.hide then
						t1.onSlotCategorySelected(v14, v15)

						return
					end
				end
			end
		end, {
			slotCategory,
			categories,
			t1.onSlotCategorySelected
		})
	end

	local v13 = useCallback(function(p1) -- line: 53
		-- upvalues: categories (copy), slotCategory (copy), React (copy), DEPRECATED_CategoryButton (copy), t1 (copy), FitFrameHorizontal (copy), NavHighlight (copy)
		local t2 = {}
		local getScrollingFrameItemRef = p1.getScrollingFrameItemRef

		for v19, v20 in categories do
			if not v20.hide then
				local v21 = v19 == slotCategory
				local v22 = React.createElement(DEPRECATED_CategoryButton, {
					categoryIndex = v20.index,
					categoryTitle = v20.nameTranslationKey,
					layoutOrder = v20.index,
					isSelected = v21,
					frameRef = getScrollingFrameItemRef(v19),
					onActivate = function() -- line: 68
						-- upvalues: t1 (copy), v19 (copy), v20 (copy)
						if t1.onSlotCategorySelected then
							t1.onSlotCategorySelected(v19, v20)
						end
					end,
					ref = getScrollingFrameItemRef(v19)
				})

				t2[`Category{ v19 }`] = v22
			end
		end

		return React.createElement(React.Fragment, {}, {
			SlotNavFrame = React.createElement(FitFrameHorizontal, {
				height = UDim.new(1, 0),
				FillDirection = Enum.FillDirection.Horizontal,
				BackgroundTransparency = 1,
				[React.Change.AbsoluteSize] = p1.onNavFrameSizeChanged
			}, t2),
			Highlight = React.createElement(NavHighlight, {
				scrollingFrameRef = p1.getScrollingFrameRef(),
				selectedCategoryButtonInstance = p1.selectedItemInstance
			})
		})
	end, {
		categories,
		slotCategory,
		t1.onSlotCategorySelected
	})

	return React.createElement(ScrollingArrowsAndGradient, {
		LayoutOrder = t1.LayoutOrder,
		ZIndex = t1.ZIndex,
		navHeight = t1.navHeight,
		selectedItemKey = slotCategory,
		enableSnapToSelectedItem = t1.enableSnapToSelectedItem,
		renderScrollingListContent = v13
	})
end
