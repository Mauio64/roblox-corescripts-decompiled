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
local module2 = require("@luauforge/bundled/dPU")
local module3 = require("@luauforge/bundled/dzD")

local module4 = require("@luauforge/deferred/fDd")
local module5 = require("@luauforge/deferred/gQY")

local ownedActionBar = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog").Components.Checkout.OwnedActionBar
local module6 = require("@luauforge/deferred/fDu")
local module7 = require("@luauforge/bundled/fHh")
local blackbirdUpsellBanner = module7.Components.BlackbirdUpsellBanner
local surfaceName = module7.SurfaceName
local surfaceContext = module7.SurfaceContext
local robloxPlusSheetKind = module7.RobloxPlusSheetKind
local module8 = require("@luauforge/bundled/dXA")
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState

local fFlagAXDurablesForMIS = AvatarExperienceFlags.FFlagAXDurablesForMIS
local fFlagAXGifting = AvatarExperienceFlags.FFlagAXGifting
local fFlagAXShowMoreButtonOnOwnedItems = AvatarExperienceFlags.FFlagAXShowMoreButtonOnOwnedItems
local fFlagAppIaHomeShowCampaignTab = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagAppIaHomeShowCampaignTab

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
	shouldShowNewPlusBanner = 0,
	newPlusBannerLocalizations = 0,
	onNewPlusBannerHeightChanged = 0,
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
local v10 = if fFlagAppIaHomeShowCampaignTab then t.optional(t.boolean) else nil
v5.shouldShowNewPlusBanner = v10
local v11 = if fFlagAppIaHomeShowCampaignTab then t.optional(t.table) else nil
v5.newPlusBannerLocalizations = v11
local v12 = if fFlagAppIaHomeShowCampaignTab then t.optional(t.callback) else nil
v5.onNewPlusBannerHeightChanged = v12
v5.deviceSafePadding = t.table
local v13 = strictInterface(v5)

extended.defaultProps = { topComponentHeight = 0 }

local function onActivated()
	module7.initiateRobloxSubscriptionPurchase(
		{ showBackButton = true, sheetKind = robloxPlusSheetKind.TT },
		{
			onFlowComplete = function(p2) end
		},
		nil,
		surfaceName.TTGrantSheet,
		surfaceContext.InApp,
		nil,
		nil
	)
end

function extended:init()
	self.moreButtonRef = Roact.createRef()
	self.actionButtonRef = Roact.createRef()
	self.bottomComponentRef = Roact.createRef()
	self.middleButtonRef = Roact.createRef()

	if fFlagAppIaHomeShowCampaignTab then
		self.state = { blackbirdUpsellBannerHeight = 0 }

		function self.onBlackbirdUpsellBannerSizeChanged(p2)
			local y = p2.AbsoluteSize.Y

			if y <= 0 then
				return
			end

			if y ~= self.state.blackbirdUpsellBannerHeight then
				self:setState({ blackbirdUpsellBannerHeight = y })
			end

			if self.props.onNewPlusBannerHeightChanged then
				self.props.onNewPlusBannerHeightChanged(y)
			end
		end

		function self.onBlackbirdUpsellBannerRef(p2)
			if p2 == nil and self.props.onNewPlusBannerHeightChanged then
				self.props.onNewPlusBannerHeightChanged(0)
			end
		end
	end
end

function extended:renderWithStyle(p2, p3)
	assert(v13(self.props))
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

	local v14 = fFlagAppIaHomeShowCampaignTab

	if v14 then
		v14 = self.props.shouldShowNewPlusBanner == true and not buttonProps.buttonIsLoading
	end

	local v15 = not (fFlagAppIaHomeShowCampaignTab and v14) and 0 or self.state.blackbirdUpsellBannerHeight

	local v16 = actionBarHeight + bottomPadding
	local v17 = v16 + topComponentHeight + bottomComponentHeight

	if not self.props.hideGradient then
		v17 += actionBarGradientHeight
	end

	local theme = p2.Theme
	local font = p2.Font

	local v18 = if showMoreButton then self.moreButtonRef else self.actionButtonRef

	local bottomComponentRef = self.bottomComponentRef
	local v19 = self.moreButtonRef

	if not bottomComponent then
		bottomComponentRef = nil
	end

	if not showMoreButton then
		v19 = nil
	end

	local v20 = showMoreButton or showMiddleButton or fFlagAXGifting and giftButton ~= nil
	local v21 = -((showMoreButton and showMiddleButton and 2 or (showMoreButton or showMiddleButton) and 1 or 0) * 44) - (v20 and 12 or 0)

	local v22 = showMoreButton and Roact.createElement(Foundation.Button, {
		icon = "circle-three-dots-horizontal",
		onActivated = onMoreButtonActivated,
		variant = Foundation.Enums.ButtonVariant.Standard,
		size = Foundation.Enums.ButtonSize.Medium,
		LayoutOrder = fFlagAXGifting and 2 or fFlagAXDurablesForMIS and 5 or 4
	})

	if buttonProps.buttonActionType == module6.CustomizeLink then
		local createElement = Roact.createElement
		local v24 = {
			Size = UDim2.new(1, 0, 0, (math.max(v17, module3.GAMEPAD_BOTTOM_BAR_SIZE))),
			BackgroundTransparency = 1,
			ZIndex = zIndex
		}

		local createElement2 = Roact.createElement
		local v27 = { onActivated = buttonProps.onActivated, onMoreButtonActivated = 0 }

		if not (fFlagAXShowMoreButtonOnOwnedItems and showMoreButton) then
			onMoreButtonActivated = nil
		end

		v27.onMoreButtonActivated = onMoreButtonActivated
		return createElement("Frame", v24, {
			ActionBarFrame = createElement2(ownedActionBar, v27)
		})
	else
		if fFlagAppIaHomeShowCampaignTab and v14 then
			v17 += v15
		end

		local createElement = Roact.createElement
		local frame = focusable.Frame
		local v23 = {
			Size = UDim2.new(1, 0, 0, v17),
			BackgroundTransparency = 1,
			ZIndex = zIndex,
			defaultChild = v18
		}

		local v24 = if topComponent ~= nil then Roact.createElement("Frame", {
			Size = UDim2.new(1, 0, 0, topComponentHeight),
			Position = UDim2.new(0, 0, 1, -bottomComponentHeight - v16 - topComponentHeight),
			BackgroundColor3 = theme.BackgroundDefault.Color,
			BackgroundTransparency = 0,
			BorderSizePixel = 0
		}, topComponent) or nil else nil
		local v25

		if fFlagAppIaHomeShowCampaignTab and v14 then
			local createElement2 = Roact.createElement
			local v27 = {
				Size = UDim2.fromScale(1, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				[Roact.Change.AbsoluteSize] = self.onBlackbirdUpsellBannerSizeChanged,
				[Roact.Ref] = self.onBlackbirdUpsellBannerRef,
				Visible = v15 > 0,
				AnchorPoint = Vector2.new(0, 1),
				Position = UDim2.new(0, 0, 1, -bottomComponentHeight - v16 - topComponentHeight),
				BackgroundColor3 = theme.BackgroundDefault.Color,
				BackgroundTransparency = 0,
				BorderSizePixel = 0
			}

			local v28 = {
				Padding = Roact.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, leftPadding),
					PaddingRight = UDim.new(0, rightPadding + self.props.deviceSafePadding.right),
					PaddingTop = UDim.new(0, 12)
				}),
				Banner = 0
			}

			local createElement3 = Roact.createElement
			local v30 = {
				onActivated = onActivated,
				bannerText = 0,
				ctaText = 0,
				productInfo = 0
			}

			local v31 = if self.props.newPlusBannerLocalizations then self.props.newPlusBannerLocalizations.newUpsellBannerTitle else nil
			v30.bannerText = v31

			local v32 = if self.props.newPlusBannerLocalizations then self.props.newPlusBannerLocalizations.newUpsellBannerCta else nil
			v30.ctaText = v32

			v30.productInfo = { isFreeTrial = false, initialDiscountPercentage = 10 }
			v28.Banner = createElement3(blackbirdUpsellBanner, v30)
			v25 = createElement2("Frame", v27, v28)
		end

		local createElement2 = Roact.createElement
		local frame2 = focusable.Frame
		local v26 = {
			Size = UDim2.new(1, self.props.deviceSafePadding.right, 0, v16),
			Position = UDim2.new(0, 0, 1, -bottomComponentHeight - v16),
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
		local v28 = {
			PaddingLeft = UDim.new(0, leftPadding),
			PaddingRight = UDim.new(0, rightPadding + self.props.deviceSafePadding.right),
			PaddingTop = 0
		}
		local v29 = if topPadding then UDim.new(0, topPadding) else nil
		v28.PaddingTop = v29
		children2.Padding = createElement3("UIPadding", v28)

		children2.MoreButton = if not fFlagAXGifting then v22 else nil

		local v31 = if fFlagAXGifting and (giftButton ~= nil or showMoreButton) then Roact.createElement(Foundation.View, {
			tag = "row auto-xy gap-small align-y-center",
			LayoutOrder = fFlagAXDurablesForMIS and 5 or 4
		}, { GiftButton = giftButton, MoreButton = v22 }) else nil
		children2.TrailingButtons = v31
		local v32

		if showMiddleButton then
			local createElement4 = Roact.createElement
			local middleButtonRefsByRef = {
				["onActivated"] = nil,
				["onActivated"] = nil,
				onActivated = onMiddleButtonActivated,
				icon = middleButtonIcon,
				NextSelectionRight = self.actionButtonRef
			}
			local v34 = if showMoreButton then self.moreButtonRef else nil
			middleButtonRefsByRef.NextSelectionLeft = v34
			middleButtonRefsByRef[Roact.Ref] = self.middleButtonRef
			v32 = createElement4(module5, middleButtonRefsByRef)
		else
			v32 = showMiddleButton
		end

		children2.MiddleButton = v32

		if v20 then
			local createElement4 = Roact.createElement

			local v35 = if fFlagAXGifting and giftButton ~= nil then UDim2.new(0, 8, 0, 44) else UDim2.new(0, 12, 0, 44)
			v20 = createElement4("Frame", {
				Size = v35,
				BackgroundTransparency = 1,
				LayoutOrder = fFlagAXDurablesForMIS and 4 or 3
			})
		end

		children2.Spacer = v20

		local createElement4 = Roact.createElement
		local udim

		if fFlagAXGifting then
			udim = UDim2.new(1, 0, 0, v16 - bottomPadding)
		else
			local newUDim2 = UDim2.new
			local v34 = fFlagAXDurablesForMIS and self.props.showSecondaryButton and 0.5 or 1

			if fFlagAXDurablesForMIS and self.props.showSecondaryButton then
				v21 /= 2
			end

			udim = newUDim2(v34, v21, 0, v16 - bottomPadding)
		end

		local actionButtonRefsByRef = {
			["Size"] = udim,
			fillWidth = fFlagAXGifting and true or nil,
			LayoutOrder = 1,
			Font = font,
			buttonProps = buttonProps
		}

		if showMiddleButton then
			v19 = self.middleButtonRef
		end

		actionButtonRefsByRef.NextSelectionLeft = v19
		actionButtonRefsByRef[Roact.Ref] = self.actionButtonRef
		children2.ActionButton = createElement4(module4, actionButtonRefsByRef)

		local v34 = if fFlagAXDurablesForMIS and self.props.showSecondaryButton then Roact.createElement("Frame", {
			Size = UDim2.new(0, 12, 0, 44),
			BackgroundTransparency = 1,
			LayoutOrder = 2
		}) else nil
		children2.SecondaryButtonSpacer = v34

		local v35 = if fFlagAXDurablesForMIS and self.props.showSecondaryButton then Roact.createElement(Foundation.Button, {
			fillBehavior = Foundation.Enums.FillBehavior.Fill,
			LayoutOrder = 3,
			size = Foundation.Enums.ButtonSize.Medium,
			text = self.props.secondaryButtonText,
			onActivated = self.props.onSecondaryButtonActivated
		}) else nil
		children2.SecondaryButton = v35
		local children = {
			TopComponent = v24,
			BlackbirdUpsellBanner = v25,
			ActionBarFrame = createElement2(frame2, v26, children2),
			BottomComponent = 0,
			GamepadBottomBarComponent = 0,
			Gradient = 0
		}
		local v36

		if bottomComponent == nil then
			v36 = false
		else
			v36 = Roact.createElement(focusable.Frame, {
				Size = UDim2.new(1, 0, 0, bottomComponentHeight),
				Position = UDim2.new(0, 0, 1, -bottomComponentHeight),
				BackgroundColor3 = theme.BackgroundDefault.Color,
				BackgroundTransparency = 0,
				BorderSizePixel = 0,
				[Roact.Ref] = self.bottomComponentRef,
				NextSelectionUp = self.actionButtonRef
			}, { BottomComponentContents = bottomComponent })
		end

		children.BottomComponent = v36

		children.GamepadBottomBarComponent = Roact.createElement("Frame", {
			Size = UDim2.new(1, self.props.deviceSafePadding.right, 0, module3.GAMEPAD_BOTTOM_BAR_SIZE),
			Position = UDim2.new(0, 0, 1, 0),
			BackgroundColor3 = theme.BackgroundDefault.Color,
			BackgroundTransparency = 0,
			BorderSizePixel = 0
		})
		local v37

		if not self.props.hideGradient then
			local createElement5 = Roact.createElement
			local v39 = {
				Size = UDim2.new(1, 0, 0, actionBarGradientHeight),
				Position = 0,
				AnchorPoint = 0,
				BackgroundTransparency = 1,
				Image = "rbxasset://textures/ui/LuaApp/graphic/gradient_0_100.png",
				ImageColor3 = 0
			}
			local newUDim2 = UDim2.new
			local v43

			if fFlagAppIaHomeShowCampaignTab and v14 then
				v43 = -bottomComponentHeight - v16 - topComponentHeight - v15
			else
				v43 = -bottomComponentHeight - v16 - topComponentHeight
			end

			v39.Position = newUDim2(0, 0, 1, v43)

			v39.AnchorPoint = Vector2.new(0, 1)

			v39.ImageColor3 = theme.BackgroundDefault.Color
			v37 = createElement5("ImageLabel", v39) or nil
		end

		children.Gradient = v37
		return createElement(frame, v23, children)
	end
end

function extended:render()
	return withStyle(function(p2)
		return self:renderWithStyle(p2)
	end)
end

local function ActionBarFunctional(p2)
	local v14 = useSignalState(module8.GetDisplayStore().getDeviceSafePadding)
	local joined = Cryo.Dictionary.join(p2, { deviceSafePadding = v14 })

	return Roact.createElement(extended, joined)
end

return ActionBarFunctional
