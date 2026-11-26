local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local useTokens = Foundation.Hooks.useTokens

local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local module = require("@luauforge/bundled/eie")
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization

local module2 = require("@luauforge/deferred/gJZ")
local module3 = require("@luauforge/bundled/gJz")
local module4 = require("@luauforge/bundled/dRz")

require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")

local module5 = require("@game/CorePackages/Packages/_Index/UIBlox/UIBlox/App/Control/HorizontalNav/ScrollingListWithArrowsAndGradient")
local AvatarExperienceDeps = require(CorePackages.Packages.AvatarExperienceDeps)
local fitFrameHorizontal = AvatarExperienceDeps.RoactFitComponents.FitFrameHorizontal
local Responsive = require("@game/CorePackages/Workspace/Packages/Responsive")

local function selectCategoryIndex(p2)
	return p2.AvatarExperience.AvatarEditor.Categories.category
end

local function selectSubcategoryIndex(p2)
	return p2.AvatarExperience.AvatarEditor.Categories.subcategory
end

local function SubcategoryPill(props)
	local v5 = useDispatch()
	local v6 = useLocalization({ label = props.subCategory.Title })

	local v7 = module(module3)

	local v8 = React.useCallback(function()
		v5(module2(props.subCategory.Category, props.subCategory.Subcategory, v7))
	end, { props.subCategory, v5, v7 })

	return React.createElement(Foundation.Chip, {
		text = v6.label,
		isChecked = props.isActive,
		onActivated = v8,
		LayoutOrder = props.layoutOrder
	})
end

function LUAUFORGE_MODULE_GLOBALS_hfl_SubNavigationBar(p2)
	local v5 = useTokens()
	local v6 = module4()

	local v7 = useSelector(selectCategoryIndex)
	local v8 = useSelector(selectSubcategoryIndex)

	local v9 = v6[v7]
	local subcategories = if v9 and v9.ShowSubcategoriesAsSubnavigation then v9.Subcategories else nil

	local ref = React.useRef(nil)
	local ref2 = React.useRef({})

	local v10 = Responsive.useOrientation() == Responsive.BreakpointConfig.Enum.Portrait

	local v11 = React.useCallback(function(p3)
		local x = p3.AbsoluteSize.X or 0

		if ref.current then
			ref.current.CanvasSize = UDim2.new(0, x, 1, 0)
		end
	end, {})

	local v12 = React.useCallback(function()
		local children = {}

		if subcategories then
			local v13 = 1

			children.LeftPadding = React.createElement(Foundation.View, {
				tag = "auto-xy",
				Size = UDim2.new(0, v5.Size.Size_300, 1, 0),
				BackgroundTransparency = 1,
				LayoutOrder = v13
			})

			local v14 = v13 + 1

			for k, subcategory in subcategories do
				if not ref2.current[k] then
					ref2.current[k] = React.createRef()
				end

				local v15 = v8 == k
				children[subcategory.Name or tostring(k)] = React.createElement(SubcategoryPill, {
					subCategory = subcategory,
					isActive = v15,
					layoutOrder = v14
				})

				v14 += 1
			end

			children.RightPadding = React.createElement(Foundation.View, {
				tag = "auto-xy",
				Size = UDim2.new(0, v5.Size.Size_300, 1, 0),
				BackgroundTransparency = 1,
				LayoutOrder = v14
			})
		end

		return {
			NavFrame = React.createElement(fitFrameHorizontal, {
				height = UDim.new(1, 0),
				FillDirection = Enum.FillDirection.Horizontal,
				BackgroundTransparency = 1,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				[React.Change.AbsoluteSize] = v11,
				contentPadding = UDim.new(0, v5.Size.Size_200)
			}, children)
		}
	end, { subcategories, v8, v11, v5 })

	if v9 and v9.ShowSubcategoriesAsSubnavigation then
		local size_1200 = v5.Size.Size_1200

		return React.createElement(Foundation.View, {
			tag = "clip gui-object-defaults",
			BorderSizePixel = 0,
			LayoutOrder = p2.LayoutOrder,
			Size = UDim2.new(1, 0, 0, size_1200),
			padding = not v10 and { top = UDim.new(0, v5.Size.Size_250) } or nil
		}, {
			ScrollingListWithArrowsAndGradient = React.createElement(module5, {
				getScollingListContent = v12,
				listHeight = size_1200,
				scrollingFrameRef = ref,
				buttonRefs = ref2.current,
				buttonPadding = 0
			})
		})
	end

	return nil
end

return LUAUFORGE_MODULE_GLOBALS_hfl_SubNavigationBar
