local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local t = require(CorePackages.Packages.t)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local Cryo = require(CorePackages.Packages.Cryo)

local focusable = RoactGamepad.Focusable

local withStyle = UIBlox.Style.withStyle
local module2 = require("@luauforge/bundled/dME")
local module3 = require("@luauforge/bundled/dwA")

local module4 = require("@luauforge/deferred/fvD")
local module5 = require("@luauforge/deferred/gmt")

local ownedActionBar = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog").Components.Checkout.OwnedActionBar
local module6 = require("@luauforge/deferred/fvU")
local module7 = require("@luauforge/bundled/dUd")
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState

local fFlagAXDurablesForMIS = AvatarExperienceFlags.FFlagAXDurablesForMIS
local fFlagAXGifting = AvatarExperienceFlags.FFlagAXGifting
local fFlagAXShowMoreButtonOnOwnedItems = AvatarExperienceFlags.FFlagAXShowMoreButtonOnOwnedItems

local actionBarHeight = module2.ActionBar.ActionBarHeight
local actionBarGradientHeight = module2.ActionBar.ActionBarGradientHeight

local extended = Roact.PureComponent:extend("ActionBar")

local strictInterface = t.strictInterface
local v5 = {
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
	giftButton = 0,
	showSecondaryButton = 0,
	secondaryButtonText = 0,
	onSecondaryButtonActivated = 0,
	deviceSafePadding = 0
}
local v6 = if fFlagAXGifting then t.optional(t.table) else nil
v5.giftButton = v6
local v7 = if fFlagAXDurablesForMIS then t.optional(t.boolean) else nil
v5.showSecondaryButton = v7
local v8 = if fFlagAXDurablesForMIS then t.optional(t.string) else nil
v5.secondaryButtonText = v8
local v9 = if fFlagAXDurablesForMIS then t.optional(t.callback) else nil
v5.onSecondaryButtonActivated = v9
v5.deviceSafePadding = t.table
local v10 = strictInterface(v5)

extended.defaultProps = { topComponentHeight = 0 }

function extended:init()
	self.moreButtonRef = Roact.createRef()
	self.actionButtonRef = Roact.createRef()
	self.bottomComponentRef = Roact.createRef()
	self.middleButtonRef = Roact.createRef()
end

function extended:renderWithStyle(p2, p3)
	assert(v10(self.props))
	local zIndex = self.props.ZIndex
	local leftPadding = self.props.leftPadding
	local rightPadding = self.props.rightPadding
	local topPadding = self.props.topPadding
	local bottomPadding = self.props.bottomPadding
	local showMoreButton = self.props.showMoreButton
	local onMoreButtonActivated = self.props.onMoreButtonActivated
	local showMiddleButton = self.props.showMiddleButton
	local onMiddleButtonActivated = self.props.onMiddleButtonActivated
	local middleButtonIcon = self.props.middleButtonIcon
	local giftButton = if fFlagAXGifting then self.props.giftButton else nil
	local buttonProps = self.props.buttonProps

	local topComponent = self.props.topComponent
	local topComponentHeight = self.props.topComponentHeight

	local bottomComponent = self.props.bottomComponent
	local bottomComponentHeight = self.props.bottomComponentHeight or 0

	local v11 = actionBarHeight + bottomPadding
	local v12 = v11 + topComponentHeight + bottomComponentHeight

	if not self.props.hideGradient then
		v12 += actionBarGradientHeight
	end

	local theme = p2.Theme
	local font = p2.Font

	local v13 = if showMoreButton then self.moreButtonRef else self.actionButtonRef

	local bottomComponentRef = self.bottomComponentRef
	local v14 = self.moreButtonRef

	if not bottomComponent then
		bottomComponentRef = nil
	end

	if not showMoreButton then
		v14 = nil
	end

	local v15 = showMoreButton or showMiddleButton or fFlagAXGifting and giftButton ~= nil
	local v16 = -((showMoreButton and showMiddleButton and 2 or (showMoreButton or showMiddleButton) and 1 or 0) * 44) - (v15 and 12 or 0)

	local v17 = showMoreButton and Roact.createElement(Foundation.Button, {
		icon = "circle-three-dots-horizontal",
		onActivated = onMoreButtonActivated,
		variant = Foundation.Enums.ButtonVariant.Standard,
		size = Foundation.Enums.ButtonSize.Medium,
		LayoutOrder = fFlagAXGifting and 2 or fFlagAXDurablesForMIS and 5 or 4
	})

	if buttonProps.buttonActionType == module6.CustomizeLink then
		local createElement = Roact.createElement
		local v19 = {
			Size = UDim2.new(1, 0, 0, (math.max(v12, module3.GAMEPAD_BOTTOM_BAR_SIZE))),
			BackgroundTransparency = 1,
			ZIndex = zIndex
		}

		local createElement2 = Roact.createElement
		local v22 = { onActivated = buttonProps.onActivated, onMoreButtonActivated = 0 }

		if not (fFlagAXShowMoreButtonOnOwnedItems and showMoreButton) then
			onMoreButtonActivated = nil
		end

		v22.onMoreButtonActivated = onMoreButtonActivated
		return createElement("Frame", v19, {
			ActionBarFrame = createElement2(ownedActionBar, v22)
		})
	else
		local createElement = Roact.createElement
		local frame = focusable.Frame
		local v18 = {
			Size = UDim2.new(1, 0, 0, v12),
			BackgroundTransparency = 1,
			ZIndex = zIndex,
			defaultChild = v13
		}

		local v19 = if topComponent ~= nil then Roact.createElement("Frame", {
			Size = UDim2.new(1, 0, 0, topComponentHeight),
			Position = UDim2.new(0, 0, 1, -bottomComponentHeight - v11 - topComponentHeight),
			BackgroundColor3 = theme.BackgroundDefault.Color,
			BackgroundTransparency = 0,
			BorderSizePixel = 0
		}, topComponent) or nil else nil

		local createElement2 = Roact.createElement
		local frame2 = focusable.Frame
		local v20 = {
			Size = UDim2.new(1, self.props.deviceSafePadding.right, 0, v11),
			Position = UDim2.new(0, 0, 1, -bottomComponentHeight - v11),
			BackgroundColor3 = theme.BackgroundDefault.Color,
			BackgroundTransparency = 0,
			BorderSizePixel = 0,
			NextSelectionDown = bottomComponentRef
		}

		local children2 = {
			ListLayout = Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 0)
			}),
			Padding = 0,
			MoreButton = 0,
			TrailingButtons = 0,
			MiddleButton = 0,
			Spacer = 0,
			ActionButton = 0,
			SecondaryButtonSpacer = 0,
			SecondaryButton = 0
		}

		local createElement3 = Roact.createElement
		local v22 = {
			PaddingLeft = UDim.new(0, leftPadding),
			PaddingRight = UDim.new(0, rightPadding + self.props.deviceSafePadding.right),
			PaddingTop = 0
		}
		local v23 = if topPadding then UDim.new(0, topPadding) else nil
		v22.PaddingTop = v23
		children2.Padding = createElement3("UIPadding", v22)

		children2.MoreButton = if not fFlagAXGifting then v17 else nil

		local v25 = if fFlagAXGifting and (giftButton ~= nil or showMoreButton) then Roact.createElement(Foundation.View, {
			tag = "row auto-xy gap-small align-y-center",
			LayoutOrder = fFlagAXDurablesForMIS and 5 or 4
		}, { GiftButton = giftButton, MoreButton = v17 }) else nil
		children2.TrailingButtons = v25
		local v26

		if showMiddleButton then
			local createElement4 = Roact.createElement
			local middleButtonRefsByRef = {
				["onActivated"] = nil,
				["onActivated"] = nil,
				onActivated = onMiddleButtonActivated,
				icon = middleButtonIcon,
				NextSelectionRight = self.actionButtonRef
			}
			local v28 = if showMoreButton then self.moreButtonRef else nil
			middleButtonRefsByRef.NextSelectionLeft = v28
			middleButtonRefsByRef[Roact.Ref] = self.middleButtonRef
			v26 = createElement4(module5, middleButtonRefsByRef)
		else
			v26 = showMiddleButton
		end

		children2.MiddleButton = v26

		if v15 then
			local createElement4 = Roact.createElement

			local v29 = if fFlagAXGifting and giftButton ~= nil then UDim2.new(0, 8, 0, 44) else UDim2.new(0, 12, 0, 44)
			v15 = createElement4("Frame", {
				Size = v29,
				BackgroundTransparency = 1,
				LayoutOrder = fFlagAXDurablesForMIS and 4 or 3
			})
		end

		children2.Spacer = v15

		local createElement4 = Roact.createElement
		local udim

		if fFlagAXGifting then
			udim = UDim2.new(1, 0, 0, v11 - bottomPadding)
		else
			local newUDim2 = UDim2.new
			local v28 = fFlagAXDurablesForMIS and self.props.showSecondaryButton and 0.5 or 1

			if fFlagAXDurablesForMIS and self.props.showSecondaryButton then
				v16 /= 2
			end

			udim = newUDim2(v28, v16, 0, v11 - bottomPadding)
		end

		local actionButtonRefsByRef = {
			["Size"] = udim,
			fillWidth = fFlagAXGifting and true or nil,
			LayoutOrder = 1,
			Font = font,
			buttonProps = buttonProps
		}

		if showMiddleButton then
			v14 = self.middleButtonRef
		end

		actionButtonRefsByRef.NextSelectionLeft = v14
		actionButtonRefsByRef[Roact.Ref] = self.actionButtonRef
		children2.ActionButton = createElement4(module4, actionButtonRefsByRef)

		local v28 = if fFlagAXDurablesForMIS and self.props.showSecondaryButton then Roact.createElement("Frame", {
			Size = UDim2.new(0, 12, 0, 44),
			BackgroundTransparency = 1,
			LayoutOrder = 2
		}) else nil
		children2.SecondaryButtonSpacer = v28

		local v29 = if fFlagAXDurablesForMIS and self.props.showSecondaryButton then Roact.createElement(Foundation.Button, {
			fillBehavior = Foundation.Enums.FillBehavior.Fill,
			LayoutOrder = 3,
			size = Foundation.Enums.ButtonSize.Medium,
			text = self.props.secondaryButtonText,
			onActivated = self.props.onSecondaryButtonActivated
		}) else nil
		children2.SecondaryButton = v29
		local children = {
			TopComponent = v19,
			ActionBarFrame = createElement2(frame2, v20, children2),
			BottomComponent = 0,
			GamepadBottomBarComponent = 0,
			Gradient = 0
		}
		local v30

		if bottomComponent == nil then
			v30 = false
		else
			v30 = Roact.createElement(focusable.Frame, {
				Size = UDim2.new(1, 0, 0, bottomComponentHeight),
				Position = UDim2.new(0, 0, 1, -bottomComponentHeight),
				BackgroundColor3 = theme.BackgroundDefault.Color,
				BackgroundTransparency = 0,
				BorderSizePixel = 0,
				[Roact.Ref] = self.bottomComponentRef,
				NextSelectionUp = self.actionButtonRef
			}, { BottomComponentContents = bottomComponent })
		end

		children.BottomComponent = v30

		children.GamepadBottomBarComponent = Roact.createElement("Frame", {
			Size = UDim2.new(1, self.props.deviceSafePadding.right, 0, module3.GAMEPAD_BOTTOM_BAR_SIZE),
			Position = UDim2.new(0, 0, 1, 0),
			BackgroundColor3 = theme.BackgroundDefault.Color,
			BackgroundTransparency = 0,
			BorderSizePixel = 0
		})

		local v31 = if not self.props.hideGradient then Roact.createElement("ImageLabel", {
			Size = UDim2.new(1, 0, 0, actionBarGradientHeight),
			Position = UDim2.new(0, 0, 1, -bottomComponentHeight - v11 - topComponentHeight),
			AnchorPoint = Vector2.new(0, 1),
			BackgroundTransparency = 1,
			Image = "rbxasset://textures/ui/LuaApp/graphic/gradient_0_100.png",
			ImageColor3 = theme.BackgroundDefault.Color
		}) or nil else nil
		children.Gradient = v31
		return createElement(frame, v18, children)
	end
end

function extended:render()
	return withStyle(function(p2)
		return self:renderWithStyle(p2)
	end)
end

local function ActionBarFunctional(p2)
	local v11 = useSignalState(module7.GetDisplayStore().getDeviceSafePadding)
	local joined = Cryo.Dictionary.join(p2, { deviceSafePadding = v11 })

	return Roact.createElement(extended, joined)
end

return ActionBarFunctional
