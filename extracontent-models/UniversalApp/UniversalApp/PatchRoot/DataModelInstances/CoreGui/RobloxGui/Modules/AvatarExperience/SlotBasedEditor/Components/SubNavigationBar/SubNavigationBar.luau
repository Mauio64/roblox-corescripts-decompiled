local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local useTokens = Foundation.Hooks.useTokens
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local useRoactService = require(Modules.LuaApp.Hooks.useRoactService)
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local SetCategoryAndSubcategory = require(Modules.AvatarExperience.AvatarEditor.Thunks.SetCategoryAndSubcategory)
local Analytics = require(Modules.AvatarExperience.AvatarEditor.Services.Analytics)
local GetAvatarEditorCategories = require(Modules.AvatarExperience.AvatarEditor.GetAvatarEditorCategories)

require(CorePackages.Workspace.Packages.AvatarExperienceCommon)

local ScrollingListWithArrowsAndGradient = require(Modules.AvatarExperience.Common.Components.ScrollingListWithArrowsAndGradient)
local FitFrameHorizontal = require(CorePackages.Packages.AvatarExperienceDeps).RoactFitComponents.FitFrameHorizontal
local Responsive = require(CorePackages.Workspace.Packages.Responsive)

local function selectCategoryIndex(p1) -- line: 30
	return p1.AvatarExperience.AvatarEditor.Categories.category
end
local function selectSubcategoryIndex(p2) -- line: 34
	return p2.AvatarExperience.AvatarEditor.Categories.subcategory
end
local function SubcategoryPill(t1: {[any]: any}) -- line: 46
	-- upvalues: useDispatch (copy), useLocalization (copy), useRoactService (copy), Analytics (copy), React (copy), SetCategoryAndSubcategory (copy), Foundation (copy)
	local v22 = useDispatch()
	local v23 = useLocalization({
		label = t1.subCategory.Title
	})
	local v24 = useRoactService(Analytics)
	local v25 = React.useCallback(function() -- line: 53
		-- upvalues: v22 (copy), SetCategoryAndSubcategory (copy), t1 (copy), v24 (copy)
		v22(SetCategoryAndSubcategory(t1.subCategory.Category, t1.subCategory.Subcategory, v24))
	end, {
		t1.subCategory,
		v22,
		v24
	})

	return React.createElement(Foundation.Chip, {
		text = v23.label,
		isChecked = t1.isActive,
		onActivated = v25,
		LayoutOrder = t1.layoutOrder
	})
end

function SubNavigationBar(t2: {[any]: any}) -- line: 69
	-- upvalues: useTokens (copy), GetAvatarEditorCategories (copy), useSelector (copy), selectCategoryIndex (copy), selectSubcategoryIndex (copy), React (copy), Responsive (copy), Foundation (copy), SubcategoryPill (copy), FitFrameHorizontal (copy), ScrollingListWithArrowsAndGradient (copy)
	local v27 = useTokens()
	local v28 = GetAvatarEditorCategories()
	local v29 = useSelector(selectCategoryIndex)
	local v30 = useSelector(selectSubcategoryIndex)
	local v31 = v28[v29]
	local v32 = if not v31 or not v31.ShowSubcategoriesAsSubnavigation then nil else v31.Subcategories
	local v33 = React.useRef(nil)
	local v34 = React.useRef({})
	local v35 = Responsive.useOrientation() == Responsive.BreakpointConfig.Enum.Portrait
	local v36 = React.useCallback(function(p3) -- line: 85
		-- upvalues: v33 (copy)
		local v40 = p3.AbsoluteSize.X or 0

		if v33.current then
			v33.current.CanvasSize = UDim2.new(0, v40, 1, 0)
		end
	end, {})
	local v37 = React.useCallback(function() -- line: 93
		-- upvalues: v32 (copy), React (copy), Foundation (copy), v27 (copy), v34 (copy), v30 (copy), SubcategoryPill (copy), FitFrameHorizontal (copy), v36 (copy)
		local t3 = {}

		if v32 then
			local n1 = 1

			t3.LeftPadding = React.createElement(Foundation.View, {
				tag = "auto-xy",
				BackgroundTransparency = 1,
				Size = UDim2.new(0, v27.Size.Size_300, 1, 0),
				LayoutOrder = n1
			})

			local v43 = n1 + 1

			for v44, v45 in v32 do
				if not v34.current[v44] then
					v34.current[v44] = React.createRef()
				end

				local v46 = v44 == v30

				t3[v45.Name or tostring(v44)] = React.createElement(SubcategoryPill, {
					subCategory = v45,
					isActive = v46,
					layoutOrder = v43
				})
				v43 += 1
			end

			t3.RightPadding = React.createElement(Foundation.View, {
				tag = "auto-xy",
				BackgroundTransparency = 1,
				Size = UDim2.new(0, v27.Size.Size_300, 1, 0),
				LayoutOrder = v43
			})
		end

		return {
			NavFrame = React.createElement(FitFrameHorizontal, {
				height = UDim.new(1, 0),
				FillDirection = Enum.FillDirection.Horizontal,
				BackgroundTransparency = 1,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				[React.Change.AbsoluteSize] = v36,
				contentPadding = UDim.new(0, v27.Size.Size_200)
			}, t3)
		}
	end, {
		v32,
		v30,
		v36,
		v27
	})

	if not v31 or not v31.ShowSubcategoriesAsSubnavigation then
		return nil
	end

	local Size_1200 = v27.Size.Size_1200

	return React.createElement(Foundation.View, {
		tag = "clip gui-object-defaults",
		BorderSizePixel = 0,
		LayoutOrder = t2.LayoutOrder,
		Size = UDim2.new(1, 0, 0, Size_1200),
		padding = if v35 then nil else {
			top = UDim.new(0, v27.Size.Size_250)
		}
	}, {
		ScrollingListWithArrowsAndGradient = React.createElement(ScrollingListWithArrowsAndGradient, {
			buttonPadding = 0,
			getScollingListContent = v37,
			listHeight = Size_1200,
			scrollingFrameRef = v33,
			buttonRefs = v34.current
		})
	})
end

return SubNavigationBar
