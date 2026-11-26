local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local focusable = RoactGamepad.Focusable
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")

local withNavigation = RoactNavigation.withNavigation
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local getTextSize = require("@game/CorePackages/Workspace/Packages/Style").GetTextSize
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local withSelectionCursorProvider = UIBlox.App.SelectionImage.withSelectionCursorProvider
local cursorKind = UIBlox.App.SelectionImage.CursorKind
require("@luauforge/bundled/dKT")

local roactAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").RoactAppPolicy
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
local robuxBalance = AvatarExperienceCommon.Components.RobuxBalance

local numberLocalization = require("@game/CorePackages/Workspace/Packages/Localization").NumberLocalization

local images = UIBlox.App.ImageSet.Images

local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local module2 = require("@luauforge/bundled/egY")
local module3 = require("@luauforge/bundled/egx")

local module4 = require("@luauforge/bundled/fAe")

local withStyle = UIBlox.Style.withStyle
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local imageSetButton = UIBlox.Core.ImageSet.ImageSetButton
local v5 = UIBlox.Core.Control.Interactable
local controlState = UIBlox.Core.Control.Enum.ControlState

local module5 = require("@luauforge/bundled/fCy")

local module6 = require("@luauforge/bundled/fAF")

local defineFastFlag = game:DefineFastFlag("RobuxCounterBorderHover", false)

local v6 = require("@luauforge/bundled/dRs")()
	and game:DefineFastFlag("AXNewRobuxBalanceButton2", false)

local component_assetscircle_17 = images["component_assets/circle_17"]
local component_assetscircle_17_stroke_1 = images["component_assets/circle_17_stroke_1"]
local iconscommongoldrobux = images["icons/common/goldrobux"]

local extended = Roact.PureComponent:extend("RobuxBalance")

local module7 = require("@luauforge/bundled/dFm")
local module8 = require("@luauforge/bundled/dzD")

if not defineFastFlag then
	v5 = imageSetButton
end

extended.defaultProps = { LayoutOrder = 1 }

function extended:init()
	if defineFastFlag then
		self.state = { hovered = false }
	end

	function self.fetchRobuxBalance()
		local localUserId = self.props.localUserId
		local networking = self.props.networking

		if typeof(localUserId) == "string" and localUserId ~= "" then
			self.props.requestRobuxInfo(networking, localUserId)
		end
	end

	function self.openPurchaseRobuxPage()
		local navigation = self.props.navigation
		local disableIAPEntryPoint = self.props.disableIAPEntryPoint
		local networking = self.props.networking
		self.props.openPurchaseRobuxPage(navigation, disableIAPEntryPoint, networking)
	end
end

function extended.didMount(p2)
	p2.fetchRobuxBalance()
end

local function isCatalogPageOpen(p2): boolean
	return p2.avatarRoute.opaque.name == avatarScreen.Catalog
end

function extended.didUpdate(p2, p3, p4)
	local localUserId = p2.props.localUserId

	if p3.localUserId ~= localUserId then
		p2.fetchRobuxBalance()
		return
	end

	local v7 = p2.props.avatarRoute.opaque.name == avatarScreen.Catalog

	if p3.avatarRoute.opaque.name ~= avatarScreen.Catalog and v7 then
		p2.fetchRobuxBalance()
	end
end

function extended.render(props)
	local userRobuxBalance = props.props.userRobuxBalance
	local localization = props.props.localization

	local v7 = userRobuxBalance
		and numberLocalization.abbreviate(userRobuxBalance, localization:GetLocale())
		or "-"

	if v6 then
		return Roact.createElement(focusable[robuxBalance], {
			text = v7,
			onActivated = props.openPurchaseRobuxPage,
			ref = props.props.forwardRef,
			NextSelectionLeft = props.props.NextSelectionLeft
		})
	end

	return withStyle(function(data)
		local font = data.Font
		local theme = data.Theme

		local v8 = font.BaseSize * font.CaptionHeader.RelativeSize

		local v9 = 40 + getTextSize(
			v7,
			v8,
			data.Tokens.Typography.CaptionLarge.Font,
			Vector2.new(1e999, v8),
			{ addTemporaryPadding = false }
		).X + 8

		return withSelectionCursorProvider(function(callback)
			local forwardRef = props.props.forwardRef

			local createElement = Roact.createElement
			local v10 = focusable[v5]
			local v11 = {
				BackgroundTransparency = 1,
				Image = component_assetscircle_17,
				ImageColor3 = theme.BackgroundUIDefault.Color,
				ImageTransparency = theme.BackgroundUIDefault.Transparency,
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = Rect.new(8, 8, 9, 9),
				Size = UDim2.new(0, v9, 0, 40),
				[Roact.Event.Activated] = props.openPurchaseRobuxPage,
				[Roact.Ref] = forwardRef,
				onStateChanged = defineFastFlag and function(p2, p3)
					props:setState({
						hovered = p3 == controlState.Hover
					})
				end or nil,
				NextSelectionLeft = props.props.NextSelectionLeft,
				SelectionImageObject = callback(cursorKind.RoundedRectNoInset)
			}

			local createElement2 = Roact.createElement
			local v13 = {
				BackgroundTransparency = 1,
				Image = component_assetscircle_17_stroke_1,
				ImageColor3 = 0,
				ImageTransparency = 0,
				ScaleType = 0,
				SliceCenter = 0,
				Size = 0
			}

			local v14 = if defineFastFlag and props.state.hovered then theme.SecondaryOnHover.Color else theme.Divider.Color
			v13.ImageColor3 = v14

			local v15 = if defineFastFlag and props.state.hovered then theme.SecondaryOnHover.Transparency else theme.Divider.Transparency
			v13.ImageTransparency = v15

			v13.ScaleType = Enum.ScaleType.Slice
			v13.SliceCenter = Rect.new(8, 8, 9, 9)
			v13.Size = UDim2.new(1, 0, 1, 0)
			return createElement(v10, v11, {
				Border = createElement2(imageSetLabel, v13),
				Content = Roact.createElement(
					"Frame",
					{ BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0) },
					{
						UIListLayout = Roact.createElement("UIListLayout", {
							FillDirection = Enum.FillDirection.Horizontal,
							VerticalAlignment = Enum.VerticalAlignment.Center,
							HorizontalAlignment = Enum.HorizontalAlignment.Center,
							SortOrder = Enum.SortOrder.LayoutOrder,
							Padding = UDim.new(0, 4)
						}),
						RobuxIcon = Roact.createElement(imageSetLabel, {
							Size = UDim2.new(0, 28, 0, 28),
							BackgroundTransparency = 1,
							Image = iconscommongoldrobux,
							LayoutOrder = 1
						}),
						RobuxInfo = Roact.createElement("TextLabel", {
							AutomaticSize = Enum.AutomaticSize.XY,
							BackgroundTransparency = 1,
							Text = v7,
							FontFace = normalizeFontFace(data.Tokens.Typography.CaptionLarge.Font),
							TextSize = v8,
							TextColor3 = theme.TextEmphasis.Color,
							TextTransparency = theme.TextEmphasis.Transparency,
							LayoutOrder = 2
						})
					}
				)
			})
		end)
	end)
end

local function mapStateToProps(p2, p3)
	local localUserId = p2.LocalUserId

	return { localUserId = localUserId, userRobuxBalance = p2.UserRobux[localUserId] }
end

local function mapDispatchToProps(callback, p2)
	return {
		openPurchaseRobuxPage = function(p3, p4, p5)
			if not p4 then
				return callback(module6(nil, p5))
			end

			callback(module7(module8.WEBVIEWS_UNAVAILABLE_TOAST))
		end,
		requestRobuxInfo = function(p3, p4)
			return callback(module5(p3, p4, false))
		end
	}
end

local v7 = roactServices.connect({ localization = module2, networking = module3 })(extended)

local v8 = roactAppPolicy.connect(function(p2)
	return { disableIAPEntryPoint = p2.getDisableIAPEntryPoint() }
end)(v7)

local v9 = module4((withNavigation((RoactRodux.connect(mapStateToProps, mapDispatchToProps)(v8)))))

return Roact.forwardRef(function(p2, p3)
	return Roact.createElement(v9, Cryo.Dictionary.join(p2, { forwardRef = p3 }))
end)
