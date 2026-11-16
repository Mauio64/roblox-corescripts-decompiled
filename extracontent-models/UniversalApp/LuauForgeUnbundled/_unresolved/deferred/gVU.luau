local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)
local React = require(CorePackages.Packages.React)
local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)

local focusable = RoactGamepad.Focusable
local useStyle = UIBlox.Core.Style.useStyle
local cursorKind = UIBlox.App.SelectionImage.CursorKind
local useSelectionCursor = UIBlox.App.SelectionImage.useSelectionCursor
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local useProperty = require("@luauforge/bundled/frw").useProperty
local module = require("@luauforge/bundled/eeH")

local module2 = require("@luauforge/deferred/gVP")
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen

local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local withNavigationFocus = RoactNavigation.withNavigationFocus
local module3 = require("@luauforge/bundled/goD")
local module4 = require("@luauforge/deferred/fvk")
local loadableImage = UIBlox.App.Loading.LoadableImage
local module5 = require("@luauforge/bundled/cgr")
local getRbxthumbWithTypeSizeAndOptions = module5.Utils.getRbxthumbWithTypeSizeAndOptions
local constants = module5.Utils.Constants
local module6 = require("@luauforge/bundled/dTw")
local module7 = require("@luauforge/deferred/ggP")
local isVRAppBuild = require("@game/CorePackages/Workspace/Packages/AppCommonLib").IsVRAppBuild
local module8 = require("@luauforge/deferred/gVS")
local module9 = require("@luauforge/deferred/gVT")
local module10 = require("@luauforge/bundled/dNQ")
local defineFastFlag = game:DefineFastFlag("AXVerticalDrawerCropTiles", false)

local udim = UDim.new(0, 6)

local function selectTopbarHeight(p2)
	return p2.TopBar.topBarHeight
end

local function selectMaxScreenHeight(data)
	local globalGuiInset = data.GlobalGuiInset
	local screenSize = data.ScreenSize
	local topBarHeight = data.TopBar.topBarHeight

	local maxScreenHeight = screenSize.Y - topBarHeight - globalGuiInset.bottom - globalGuiInset.top - 32 - 48

	if defineFastFlag and (maxScreenHeight - 16) % 50 < 12.5 then
		maxScreenHeight -= 25
	end

	return maxScreenHeight
end

local function selectAllowedAATypes(p2)
	return p2.AvatarExperience.AvatarEditor.AvatarSettings[module10.AvatarSettings.accessoryRefinementTypes]
end

local function getChildren(ref, p2, p3)
	local v5 = useSelector(selectAllowedAATypes)
	local value = module2().appliedDescriptionBinding:getValue()
	local v6 = not value and {} or module4.getAdjustableAccessories(value, v5)

	local children = {}
	local theme = useStyle().Theme
	local v7 = useDispatch()
	local v8 = module(module8)
	local v9 = useSelectionCursor(cursorKind.RoundedRectNoInset)

	children.UIListLayout = React.createElement("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		VerticalAlignment = Enum.VerticalAlignment.Top,
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		FillDirection = Enum.FillDirection.Vertical,
		Padding = UDim.new(0, 8),
		ref = ref
	})

	children.UIPadding = React.createElement("UIPadding", {
		PaddingTop = UDim.new(0, 16),
		PaddingBottom = UDim.new(0, 16),
		PaddingLeft = UDim.new(0, 8),
		PaddingRight = UDim.new(0, 8)
	})

	for k, v10 in v6 do
		local rbxthumbWithTypeSizeAndOptions = getRbxthumbWithTypeSizeAndOptions(
			v10,
			constants.RbxthumbTypes.Asset,
			150
		)

		local createElement = Roact.createElement
		local imageButton = focusable.ImageButton
		local v11 = {
			["Size"] = nil,
			["Size"] = nil,
			["Size"] = nil,
			Size = UDim2.fromOffset(50, 50),
			BackgroundTransparency = 1,
			SizeConstraint = Enum.SizeConstraint.RelativeXX,
			LayoutOrder = k,
			ref = p2[k],
			[Roact.Event.Activated] = function()
				p3.navigation.navigate(avatarScreen.AdjustAccessoryView)
				v7(module9(v8.avatarRefineAccessoryStart))
				v7(module6(v10))
			end
		}
		local v12 = if k < #v6 then p2[k + 1] or nil else nil
		v11.NextSelectionDown = v12
		local v13 = if k > 1 then p2[k - 1] or nil else nil
		v11.NextSelectionUp = v13
		v11.SelectionImageObject = v9
		children[k] = createElement(imageButton, v11, {
			BackgroundImage = Roact.createElement("Frame", {
				BackgroundColor3 = theme.PlaceHolder.Color,
				BackgroundTransparency = theme.PlaceHolder.Transparency,
				BorderSizePixel = 0,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromScale(1, 1),
				ZIndex = 0
			}, {
				Image = Roact.createElement(loadableImage, {
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundTransparency = 1,
					Image = rbxthumbWithTypeSizeAndOptions,
					Position = UDim2.new(0.5, 0, 0.5, 0),
					Size = UDim2.fromScale(1, 1),
					ZIndex = 0,
					cornerRadius = udim,
					showFailedStateWhenLoadingFailed = true,
					useShimmerAnimationWhileLoading = true
				}),
				UICorner = Roact.createElement("UICorner", { CornerRadius = udim })
			})
		})
	end

	return children
end

local function VerticalDrawer(p2)
	local theme = useStyle().Theme
	local forwardRef = p2.forwardRef
	local v5 = RoactGamepad.useRefCache()
	local ref = React.useRef(nil)
	local v6 = useProperty(ref, "AbsoluteContentSize") or Vector2.new(0, 0)

	local function useVerticalDrawerHeight()
		return (math.min(useSelector(selectMaxScreenHeight), v6.Y + 32))
	end

	local v7 = math.min(useSelector(selectMaxScreenHeight), v6.Y + 32)

	local children = getChildren(ref, v5, p2)
	local v8 = useSelector(selectTopbarHeight)

	local createElement = React.createElement

	if isVRAppBuild() then
	end

	local v10 = {
		AnchorPoint = Vector2.new(1, 0),
		Size = UDim2.new(0, 66, 0, v7),
		Position = 0,
		BackgroundColor3 = 0,
		BackgroundTransparency = 0,
		ClipsDescendants = true,
		ref = 0,
		ZIndex = 3
	}
	local v11 = if isVRAppBuild() then UDim2.new(
		1,
		0,
		0,
		module7.Tile.MoreIconSize + module7.VerticalList.Padding
	) else UDim2.new(1, -module7.RightMargin, 0, v8)
	v10.Position = v11

	v10.BackgroundColor3 = theme.BackgroundMuted.Color
	v10.BackgroundTransparency = theme.BackgroundMuted.Transparency

	v10.ref = forwardRef
	return createElement("Frame", v10, {
		UICorner = React.createElement("UICorner", { CornerRadius = UDim.new(0, 8) }),
		ScrollingFrame = React.createElement("ScrollingFrame", {
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			CanvasSize = UDim2.new(1, 0, 0, 0),
			ScrollBarThickness = 0,
			ScrollingDirection = Enum.ScrollingDirection.Y,
			Size = UDim2.fromScale(1, 1),
			Selectable = false
		}, children)
	})
end

local v5 = withNavigationFocus((module3(VerticalDrawer)))

return Roact.forwardRef(function(p2, p3)
	return Roact.createElement(v5, Cryo.Dictionary.join(p2, { forwardRef = p3 }))
end)
