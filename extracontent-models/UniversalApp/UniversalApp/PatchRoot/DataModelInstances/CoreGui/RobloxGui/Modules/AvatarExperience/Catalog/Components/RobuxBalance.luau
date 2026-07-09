local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local TextService = game:GetService("TextService")
local Modules = CoreGui.RobloxGui.Modules
local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local Focusable = require(CorePackages.Packages.RoactGamepad).Focusable
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local withNavigation = RoactNavigation.withNavigation
local UIBlox = require(CorePackages.Packages.UIBlox)
local withSelectionCursorProvider = UIBlox.App.SelectionImage.withSelectionCursorProvider
local CursorKind = UIBlox.App.SelectionImage.CursorKind

require(Modules.AvatarExperience.Common.AvatarExperienceState)

local RoactAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy).RoactAppPolicy
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local RobuxBalance = AvatarExperienceCommon.Components.RobuxBalance
local NumberLocalization = require(CorePackages.Workspace.Packages.Localization).NumberLocalization
local Images = UIBlox.App.ImageSet.Images
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local RoactLocalization = require(Modules.LuaApp.Services.RoactLocalization)
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local withAvatarRoute = require(Modules.AvatarExperience.Common.Components.RoactNavigation.withAvatarRoute)
local withStyle = UIBlox.Style.withStyle
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local ImageSetButton = UIBlox.Core.ImageSet.ImageSetButton
local Interactable = UIBlox.Core.Control.Interactable
local ControlState = UIBlox.Core.Control.Enum.ControlState
local ApiFetchEconomyCurrency = require(Modules.LuaApp.Thunks.ApiFetchEconomyCurrency)
local OpenPurchaseRobuxPage = require(Modules.LuaApp.Thunks.Economy.OpenPurchaseRobuxPage)
local v31 = game:DefineFastFlag("RobuxCounterBorderHover", false)
local v32 = require(Modules.AvatarExperience.Flags.GetFFlagAXEnableSlotBasedEditor)() and game:DefineFastFlag("AXNewRobuxBalanceButton2", false)
local v33 = Images["component_assets/circle_17"]
local v34 = Images["component_assets/circle_17_stroke_1"]
local v35 = Images["icons/common/goldrobux"]
local v36 = Roact.PureComponent:extend("RobuxBalance")
local SetCurrentToastMessage = require(Modules.LuaApp.Actions.SetCurrentToastMessage)
local Constants = require(Modules.LuaApp.Constants)
local v39 = if not v31 then ImageSetButton else Interactable

v36.defaultProps = {
	LayoutOrder = 1
}

function v36.init(p1) -- line: 72
	-- upvalues: v31 (copy)
	if v31 then
		p1.state = {
			hovered = false
		}
	end

	function p1.fetchRobuxBalance() -- line: 79
		-- upvalues: p1 (copy)
		local localUserId = p1.props.localUserId
		local networking = p1.props.networking

		if typeof(localUserId) == "string" and localUserId ~= "" then
			p1.props.requestRobuxInfo(networking, localUserId)
		end
	end
	function p1.openPurchaseRobuxPage() -- line: 88
		-- upvalues: p1 (copy)
		local navigation = p1.props.navigation
		local disableIAPEntryPoint = p1.props.disableIAPEntryPoint
		local networking = p1.props.networking

		p1.props.openPurchaseRobuxPage(navigation, disableIAPEntryPoint, networking)
	end
end
function v36.didMount(p2) -- line: 96
	p2.fetchRobuxBalance()
end

local function isCatalogPageOpen(p3) -- line: 100
	-- upvalues: AvatarScreen (copy)
	return p3.avatarRoute.opaque.name == AvatarScreen.Catalog
end

function v36.didUpdate(p4, p5, _) -- line: 104
	-- upvalues: AvatarScreen (copy)
	if p4.props.localUserId ~= p5.localUserId then
		p4.fetchRobuxBalance()

		return
	end

	local v52 = p4.props.avatarRoute.opaque.name == AvatarScreen.Catalog

	if p5.avatarRoute.opaque.name ~= AvatarScreen.Catalog and v52 then
		p4.fetchRobuxBalance()
	end
end
function v36.render(p7) -- line: 120
	-- upvalues: NumberLocalization (copy), v32 (copy), Roact (copy), Focusable (copy), RobuxBalance (copy), withStyle (copy), TextService (copy), withSelectionCursorProvider (copy), v39 (copy), v33 (copy), v31 (copy), ControlState (copy), CursorKind (copy), ImageSetLabel (copy), v34 (copy), v35 (copy)
	local userRobuxBalance = p7.props.userRobuxBalance
	local localization = p7.props.localization
	local v56 = userRobuxBalance and NumberLocalization.abbreviate(userRobuxBalance, localization:GetLocale()) or "-"

	if v32 then
		return Roact.createElement(Focusable[RobuxBalance], {
			text = v56,
			onActivated = p7.openPurchaseRobuxPage,
			ref = p7.props.forwardRef,
			NextSelectionLeft = p7.props.NextSelectionLeft
		})
	end

	return withStyle(function(p8) -- line: 136
		-- upvalues: TextService (copy), v56 (copy), withSelectionCursorProvider (copy), p7 (copy), Roact (copy), Focusable (copy), v39 (copy), v33 (copy), v31 (copy), ControlState (copy), CursorKind (copy), ImageSetLabel (copy), v34 (copy), v35 (copy)
		local p8Font = p8.Font
		local Theme = p8.Theme
		local CaptionHeaderFont = p8Font.CaptionHeader.Font
		local v74 = p8Font.BaseSize * p8Font.CaptionHeader.RelativeSize
		local v75 = 40 + TextService:GetTextSize(v56, v74, CaptionHeaderFont, Vector2.new(1e999, v74)).X + 8

		return withSelectionCursorProvider(function(p9) -- line: 148
			-- upvalues: p7 (copy), Roact (copy), Focusable (copy), v39 (copy), v33 (copy), Theme (copy), v75 (copy), v31 (copy), ControlState (copy), CursorKind (copy), ImageSetLabel (copy), v34 (copy), v35 (copy), v56 (copy), CaptionHeaderFont (copy), v74 (copy)
			local forwardRef = p7.props.forwardRef

			return Roact.createElement(Focusable[v39], {
				BackgroundTransparency = 1,
				Image = v33,
				ImageColor3 = Theme.BackgroundUIDefault.Color,
				ImageTransparency = Theme.BackgroundUIDefault.Transparency,
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = Rect.new(8, 8, 9, 9),
				Size = UDim2.new(0, v75, 0, 40),
				[Roact.Event.Activated] = p7.openPurchaseRobuxPage,
				[Roact.Ref] = forwardRef,
				onStateChanged = if not v31 then nil else function(_, p11) -- line: 163
					-- upvalues: p7 (copy), ControlState (copy)
					p7:setState({
						hovered = p11 == ControlState.Hover
					})
				end,
				NextSelectionLeft = p7.props.NextSelectionLeft,
				SelectionImageObject = p9(CursorKind.RoundedRectNoInset)
			}, {
				Border = Roact.createElement(ImageSetLabel, {
					BackgroundTransparency = 1,
					Image = v34,
					ImageColor3 = if not v31 or not p7.state.hovered then Theme.Divider.Color else Theme.SecondaryOnHover.Color,
					ImageTransparency = if not v31 or not p7.state.hovered then Theme.Divider.Transparency else Theme.SecondaryOnHover.Transparency,
					ScaleType = Enum.ScaleType.Slice,
					SliceCenter = Rect.new(8, 8, 9, 9),
					Size = UDim2.new(1, 0, 1, 0)
				}),
				Content = Roact.createElement("Frame", {
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 1, 0)
				}, {
					UIListLayout = Roact.createElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Horizontal,
						VerticalAlignment = Enum.VerticalAlignment.Center,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						SortOrder = Enum.SortOrder.LayoutOrder,
						Padding = UDim.new(0, 4)
					}),
					RobuxIcon = Roact.createElement(ImageSetLabel, {
						BackgroundTransparency = 1,
						LayoutOrder = 1,
						Size = UDim2.new(0, 28, 0, 28),
						Image = v35
					}),
					RobuxInfo = Roact.createElement("TextLabel", {
						BackgroundTransparency = 1,
						LayoutOrder = 2,
						AutomaticSize = Enum.AutomaticSize.XY,
						Text = v56,
						Font = CaptionHeaderFont,
						TextSize = v74,
						TextColor3 = Theme.TextEmphasis.Color,
						TextTransparency = Theme.TextEmphasis.Transparency
					})
				})
			})
		end)
	end)
end

local function mapStateToProps(p12, _) -- line: 221
	local LocalUserId = p12.LocalUserId

	return {
		localUserId = LocalUserId,
		userRobuxBalance = p12.UserRobux[LocalUserId]
	}
end
local function mapDispatchToProps(p14, _) -- line: 230
	-- upvalues: SetCurrentToastMessage (copy), Constants (copy), OpenPurchaseRobuxPage (copy), ApiFetchEconomyCurrency (copy)
	return {
		openPurchaseRobuxPage = function(_, p17, p18) -- line: 232
			-- upvalues: p14 (copy), SetCurrentToastMessage (copy), Constants (copy), OpenPurchaseRobuxPage (copy)
			if p17 then
				p14(SetCurrentToastMessage(Constants.WEBVIEWS_UNAVAILABLE_TOAST))

				return
			end

			return p14(OpenPurchaseRobuxPage(nil, p18))
		end,
		requestRobuxInfo = function(p19, p20) -- line: 240
			-- upvalues: p14 (copy), ApiFetchEconomyCurrency (copy)
			return p14(ApiFetchEconomyCurrency(p19, p20, false))
		end
	}
end

local v43 = RoactServices.connect({
	localization = RoactLocalization,
	networking = RoactNetworking
})(v36)
local v44 = RoactAppPolicy.connect(function(p21) -- line: 251
	return {
		disableIAPEntryPoint = p21.getDisableIAPEntryPoint()
	}
end)(v43)
local u45 = withAvatarRoute((withNavigation((RoactRodux.connect(mapStateToProps, mapDispatchToProps)(v44)))))

return Roact.forwardRef(function(p22, p23) -- line: 263
	-- upvalues: Roact (copy), u45 (ref), Cryo (copy)
	return Roact.createElement(u45, Cryo.Dictionary.join(p22, {
		forwardRef = p23
	}))
end)
