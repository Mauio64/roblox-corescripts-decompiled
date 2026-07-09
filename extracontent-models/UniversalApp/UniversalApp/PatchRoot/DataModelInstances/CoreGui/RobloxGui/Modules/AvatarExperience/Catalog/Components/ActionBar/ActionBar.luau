local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local t = require(CorePackages.Packages.t)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local Cryo = require(CorePackages.Packages.Cryo)
local Focusable = RoactGamepad.Focusable
local withStyle = UIBlox.Style.withStyle
local CatalogConstants = require(Modules.AvatarExperience.Catalog.CatalogConstants)
local Constants = require(Modules.LuaApp.Constants)
local ActionButton = require(Modules.AvatarExperience.Catalog.Components.ActionBar.ActionButton)
local ItemDetailMoreButton = require(Modules.AvatarExperience.Catalog.Components.ActionBar.ItemDetailMoreButton)
local MiddleButton = require(Modules.AvatarExperience.Catalog.Components.ActionBar.MiddleButton)
local OwnedActionBar = require(CorePackages.Workspace.Packages.AvatarExperienceCatalog).Components.Checkout.OwnedActionBar
local BuyActionButtonTypeEnum = require(script.Parent.BuyActionBar.BuyActionButtonTypeEnum)
local Display = require(CorePackages.Workspace.Packages.Display)
local useSignalState = require(CorePackages.Packages.SignalsReact).useSignalState
local FFlagAXMISEnableMultiShopping = AvatarExperienceFlags.FFlagAXMISEnableMultiShopping
local FFlagAXDurablesForMIS = AvatarExperienceFlags.FFlagAXDurablesForMIS
local FFlagEnableLeftNavOnConsole = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableLeftNavOnConsole
local ActionBarHeight = CatalogConstants.ActionBar.ActionBarHeight
local ActionBarGradientHeight = CatalogConstants.ActionBar.ActionBarGradientHeight
local v26 = not FFlagAXMISEnableMultiShopping and 10 or 12
local v27 = Roact.PureComponent:extend("ActionBar")
local v28 = t.strictInterface({
	buttonProps = t.table,
	bottomPadding = t.number,
	leftPadding = t.number,
	rightPadding = t.number,
	topPadding = t.optional(t.number),
	ZIndex = t.number,
	topComponent = t.optional(t.table),
	topComponentHeight = t.optional(t.number),
	showMoreButton = t.boolean,
	onMoreButtonActivated = t.optional(t.callback),
	isMoreButtonSelected = t.optional(t.boolean),
	bottomComponent = t.optional(t.table),
	bottomComponentHeight = t.optional(t.number),
	hideGradient = t.optional(t.boolean),
	showMiddleButton = t.optional(t.boolean),
	onMiddleButtonActivated = t.optional(t.callback),
	middleButtonIcon = t.optional(t.table),
	showSecondaryButton = if not FFlagAXDurablesForMIS then nil else t.optional(t.boolean),
	secondaryButtonText = if not FFlagAXDurablesForMIS then nil else t.optional(t.string),
	onSecondaryButtonActivated = if not FFlagAXDurablesForMIS then nil else t.optional(t.callback),
	deviceSafePadding = if not FFlagEnableLeftNavOnConsole then nil else t.table
})

v27.defaultProps = {
	topComponentHeight = 0
}

function v27.init(p1) -- line: 97
	-- upvalues: Roact (copy)
	p1.moreButtonRef = Roact.createRef()
	p1.actionButtonRef = Roact.createRef()
	p1.bottomComponentRef = Roact.createRef()
	p1.middleButtonRef = Roact.createRef()
end
function v27.renderWithStyle(p2, p3, _) -- line: 104
	-- upvalues: v28 (copy), ActionBarHeight (copy), ActionBarGradientHeight (copy), v26 (copy), FFlagAXMISEnableMultiShopping (copy), BuyActionButtonTypeEnum (copy), Roact (copy), Constants (copy), OwnedActionBar (copy), Focusable (copy), FFlagEnableLeftNavOnConsole (copy), ItemDetailMoreButton (copy), Foundation (copy), FFlagAXDurablesForMIS (copy), MiddleButton (copy), ActionButton (copy)
	assert(v28(p2.props))

	local propsZIndex = p2.props.ZIndex
	local leftPadding = p2.props.leftPadding
	local rightPadding = p2.props.rightPadding
	local topPadding = p2.props.topPadding
	local bottomPadding = p2.props.bottomPadding
	local showMoreButton = p2.props.showMoreButton
	local onMoreButtonActivated = p2.props.onMoreButtonActivated
	local isMoreButtonSelected = p2.props.isMoreButtonSelected
	local showMiddleButton = p2.props.showMiddleButton
	local onMiddleButtonActivated = p2.props.onMiddleButtonActivated
	local middleButtonIcon = p2.props.middleButtonIcon
	local buttonProps = p2.props.buttonProps
	local topComponent = p2.props.topComponent
	local topComponentHeight = p2.props.topComponentHeight
	local bottomComponent = p2.props.bottomComponent
	local v49 = p2.props.bottomComponentHeight or 0
	local v50 = ActionBarHeight + bottomPadding
	local v51 = v50 + topComponentHeight + v49

	if not p2.props.hideGradient then
		v51 += ActionBarGradientHeight
	end

	local Theme = p3.Theme
	local p3Font = p3.Font
	local v54 = if not showMoreButton then p2.actionButtonRef else p2.moreButtonRef
	local bottomComponentRef = p2.bottomComponentRef
	local moreButtonRef = p2.moreButtonRef

	if not bottomComponent then
		bottomComponentRef = nil
	end

	if not showMoreButton then
		moreButtonRef = nil
	end

	local v57 = if not showMoreButton or not showMiddleButton then not showMoreButton and not showMiddleButton and 0 or 1 else 2
	local v58 = showMoreButton or showMiddleButton
	local v59 = v57 * 44
	local v60 = not v58 and 0 or v26
	local v61 = -v59 - v60

	if FFlagAXMISEnableMultiShopping and buttonProps.buttonActionType == BuyActionButtonTypeEnum.CustomizeLink then
		return Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, (math.max(v51, Constants.GAMEPAD_BOTTOM_BAR_SIZE))),
			ZIndex = propsZIndex
		}, {
			ActionBarFrame = Roact.createElement(OwnedActionBar, {
				onActivated = buttonProps.onActivated
			})
		})
	end

	return Roact.createElement(Focusable.Frame, {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, v51),
		ZIndex = propsZIndex,
		defaultChild = v54
	}, {
		TopComponent = topComponent ~= nil and Roact.createElement("Frame", {
			BackgroundTransparency = 0,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, topComponentHeight),
			Position = UDim2.new(0, 0, 1, -v49 - v50 - topComponentHeight),
			BackgroundColor3 = Theme.BackgroundDefault.Color
		}, topComponent) or nil,
		ActionBarFrame = Roact.createElement(Focusable.Frame, {
			BackgroundTransparency = 0,
			BorderSizePixel = 0,
			Size = UDim2.new(1, not FFlagEnableLeftNavOnConsole and 0 or p2.props.deviceSafePadding.right, 0, v50),
			Position = UDim2.new(0, 0, 1, -v49 - v50),
			BackgroundColor3 = Theme.BackgroundDefault.Color,
			NextSelectionDown = bottomComponentRef
		}, {
			ListLayout = Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 0)
			}),
			Padding = Roact.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, leftPadding),
				PaddingRight = UDim.new(0, rightPadding + (FFlagEnableLeftNavOnConsole and p2.props.deviceSafePadding.right or 0)),
				PaddingTop = if not topPadding then nil else UDim.new(0, topPadding)
			}),
			MoreButton = not FFlagAXMISEnableMultiShopping and (showMoreButton and Roact.createElement(ItemDetailMoreButton, {
				onActivated = onMoreButtonActivated,
				isSelected = isMoreButtonSelected,
				NextSelectionRight = if not showMiddleButton then p2.actionButtonRef else p2.middleButtonRef,
				[Roact.Ref] = p2.moreButtonRef
			})),
			MoreButtonMIS = FFlagAXMISEnableMultiShopping and (showMoreButton and Roact.createElement(Foundation.Button, {
				icon = "circle-three-dots-horizontal",
				onActivated = onMoreButtonActivated,
				variant = Foundation.Enums.ButtonVariant.Standard,
				size = Foundation.Enums.ButtonSize.Medium,
				LayoutOrder = not FFlagAXDurablesForMIS and 4 or 5
			})),
			MiddleButton = showMiddleButton and Roact.createElement(MiddleButton, {
				onActivated = onMiddleButtonActivated,
				icon = middleButtonIcon,
				NextSelectionRight = p2.actionButtonRef,
				NextSelectionLeft = if not showMoreButton then nil else p2.moreButtonRef,
				[Roact.Ref] = p2.middleButtonRef
			}),
			Spacer = v58 and Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(0, v26, 0, 44),
				LayoutOrder = not FFlagAXDurablesForMIS and 3 or 4
			}),
			ActionButton = Roact.createElement(ActionButton, {
				Size = UDim2.new((not FFlagAXDurablesForMIS or not p2.props.showSecondaryButton) and 1 or 0.5, if not FFlagAXDurablesForMIS or not p2.props.showSecondaryButton then v61 else v61 / 2, 0, v50 - bottomPadding),
				LayoutOrder = not FFlagAXMISEnableMultiShopping and 4 or 1,
				Font = p3Font,
				buttonProps = buttonProps,
				NextSelectionLeft = if not showMiddleButton then moreButtonRef else p2.middleButtonRef,
				[Roact.Ref] = p2.actionButtonRef
			}),
			SecondaryButtonSpacer = if not FFlagAXDurablesForMIS or not p2.props.showSecondaryButton then nil else Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 2,
				Size = UDim2.new(0, v26, 0, 44)
			}),
			SecondaryButton = if not FFlagAXDurablesForMIS or not p2.props.showSecondaryButton then nil else Roact.createElement(Foundation.Button, {
				LayoutOrder = 3,
				fillBehavior = Foundation.Enums.FillBehavior.Fill,
				size = Foundation.Enums.ButtonSize.Medium,
				text = p2.props.secondaryButtonText,
				onActivated = p2.props.onSecondaryButtonActivated
			})
		}),
		BottomComponent = bottomComponent ~= nil and Roact.createElement(Focusable.Frame, {
			Size = UDim2.new(1, 0, 0, v49),
			Position = UDim2.new(0, 0, 1, -v49),
			BackgroundColor3 = Theme.BackgroundDefault.Color,
			BackgroundTransparency = 0,
			BorderSizePixel = 0,
			[Roact.Ref] = p2.bottomComponentRef,
			NextSelectionUp = p2.actionButtonRef
		}, {
			BottomComponentContents = bottomComponent
		}),
		GamepadBottomBarComponent = Roact.createElement("Frame", {
			BackgroundTransparency = 0,
			BorderSizePixel = 0,
			Size = UDim2.new(1, not FFlagEnableLeftNavOnConsole and 0 or p2.props.deviceSafePadding.right, 0, Constants.GAMEPAD_BOTTOM_BAR_SIZE),
			Position = UDim2.new(0, 0, 1, 0),
			BackgroundColor3 = Theme.BackgroundDefault.Color
		}),
		Gradient = not p2.props.hideGradient and Roact.createElement("ImageLabel", {
			BackgroundTransparency = 1,
			Image = "rbxasset://textures/ui/LuaApp/graphic/gradient_0_100.png",
			Size = UDim2.new(1, 0, 0, ActionBarGradientHeight),
			Position = UDim2.new(0, 0, 1, -v49 - v50 - topComponentHeight),
			AnchorPoint = Vector2.new(0, 1),
			ImageColor3 = Theme.BackgroundDefault.Color
		}) or nil
	})
end
function v27.render(p5) -- line: 313
	-- upvalues: withStyle (copy)
	return withStyle(function(p6) -- line: 314
		-- upvalues: p5 (copy)
		return p5:renderWithStyle(p6)
	end)
end

if FFlagEnableLeftNavOnConsole then
	local function ActionBarFunctional(p7) -- line: 320
		-- upvalues: useSignalState (copy), Display (copy), Cryo (copy), Roact (copy), v27 (copy)
		local v64 = useSignalState(Display.GetDisplayStore().getDeviceSafePadding)
		local v65 = Cryo.Dictionary.join(p7, {
			deviceSafePadding = v64
		})

		return Roact.createElement(v27, v65)
	end

	return ActionBarFunctional
end

return v27
