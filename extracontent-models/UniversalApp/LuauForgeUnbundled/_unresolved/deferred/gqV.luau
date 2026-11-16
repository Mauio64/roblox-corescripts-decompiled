local CorePackages = game:GetService("CorePackages")
local IXPService = game:GetService("IXPService")
local t = require(CorePackages.Packages.t)
local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local RoactRodux = require(CorePackages.Packages.RoactRodux)

local module = require("@luauforge/deferred/fXb")
local Cryo = require(CorePackages.Packages.Cryo)
local module2 = require("@luauforge/bundled/eee")
local RobloxAppToastsRodux = require("@game/CorePackages/Workspace/Packages/_Index/RobloxAppToastsRodux/RobloxAppToastsRodux")
local module4 = require("@luauforge/deferred/fYy")
local module5 = require("@luauforge/bundled/fsq")
local module6 = require("@luauforge/bundled/dCp")
local appUserLayers = require("@luauforge/bundled/dMA").AppUserLayers
local module7 = require("@luauforge/bundled/frl")
local withLocalization = require("@game/CorePackages/Workspace/Packages/Localization").withLocalization
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local module8 = require("@luauforge/bundled/dYU")
local module9 = require("@luauforge/bundled/eda")
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").useAppPolicy

local fFlagLuaAppEdpBackendV2HydrateLegacyIxp = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpBackendV2HydrateLegacyIxp
local fFlagSignalsNavP3dRouteGated = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSignalsNavP3dRouteGated
local getLegacyNavigationStore

if fFlagSignalsNavP3dRouteGated then
	getLegacyNavigationStore = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").GetLegacyNavigationStore
else
	getLegacyNavigationStore = nil
end

local UIBlox = require(CorePackages.Packages.UIBlox)
local partialPageModal = UIBlox.App.Dialog.Modal.PartialPageModal
local styledTextLabel = UIBlox.App.Text.StyledTextLabel
local buttonType = UIBlox.App.Button.Enum.ButtonType
local withStyle = UIBlox.Core.Style.withStyle

local extended = Roact.PureComponent:extend("AgeVerificationModal")

local strictInterface = t.strictInterface
local v5 = {
	universeId = t.string,
	pageName = 0,
	screenSize = 0,
	navigateDown = 0,
	navigateBack = 0,
	dispatchFetchGameDetailsPageData = 0,
	eventIngest = 0,
	networking = 0,
	areWebviewsSupported = 0,
	shouldHydrateLegacyIxp = 0
}
local v6 = if fFlagSignalsNavP3dRouteGated then t.optional(t.string) else t.string
v5.pageName = v6
v5.screenSize = t.Vector2
v5.navigateDown = t.callback
v5.navigateBack = t.callback
v5.dispatchFetchGameDetailsPageData = t.callback
v5.eventIngest = t.table
v5.networking = t.callback
v5.areWebviewsSupported = t.boolean
local v7 = if fFlagLuaAppEdpBackendV2HydrateLegacyIxp then t.optional(t.boolean) else nil
v5.shouldHydrateLegacyIxp = v7
extended.validateProps = strictInterface(v5)

function extended:init()
	self.isMounted = false

	function self.trackDeeplinkClick(p3, p4)
		if fFlagSignalsNavP3dRouteGated then
			p3 = getLegacyNavigationStore(false).getCurrentPage(false).name
		end

		self.props.eventIngest:setRBXEventStream(p3, "ageVerificationUpsellClick", {
			universeId = p4
		})
	end
end

function extended:didMount()
	self.isMounted = true
end

function extended:willUnmount()
	local networking = self.props.networking
	local universeId = self.props.universeId

	if fFlagLuaAppEdpBackendV2HydrateLegacyIxp then
		self.props.dispatchFetchGameDetailsPageData(
			networking,
			universeId,
			nil,
			self.props.shouldHydrateLegacyIxp
		)
	else
		self.props.dispatchFetchGameDetailsPageData(networking, universeId)
	end

	self.isMounted = false
end

function extended.render(data)
	return withStyle(function(p2)
		return withLocalization({
			title = "Feature.AgeVerificationUpsell.Modal.Title",
			message = "Feature.AgeVerificationUpsell.Modal.ContentText",
			buttonCancel = "Feature.AgeVerificationUpsell.Button.Cancel",
			buttonSettings = "Feature.AgeVerificationUpsell.Button.Settings"
		})(function(props)
			local v8 = {
				{
					buttonType = buttonType.Secondary,
					props = {
						isDisabled = false,
						onActivated = data.props.navigateBack,
						text = props.buttonCancel
					}
				}
			}

			if data.props.areWebviewsSupported then
				table.insert(v8, {
					buttonType = buttonType.PrimarySystem,
					props = {
						isDisabled = false,
						onActivated = function()
							if data.isMounted then
								data.trackDeeplinkClick(data.props.pageName, data.props.universeId)
								data.props.navigateDown({
									name = module6.GenericWebPage,
									detail = module5.static.settings.account(),
									extraProps = { title = props.buttonSettings }
								})
							end
						end,
						text = props.buttonSettings
					}
				})
			end

			local element = Roact.createElement(partialPageModal, {
				title = props.title,
				screenSize = data.props.screenSize,
				buttonStackProps = {
					forcedFillDirection = Enum.FillDirection.Horizontal,
					buttonHeight = 48,
					buttons = v8
				}
			}, {
				ViewFrame = Roact.createElement(
					"Frame",
					{
						AutomaticSize = Enum.AutomaticSize.XY,
						BackgroundTransparency = 1
					},
					{
						UIPadding = Roact.createElement("UIPadding", {
							PaddingTop = UDim.new(0, 24),
							PaddingBottom = UDim.new(0, 24)
						}),
						Text = Roact.createElement(styledTextLabel, {
							fontStyle = p2.Font.Body,
							colorStyle = p2.Theme.TextEmphasis,
							size = UDim2.new(1, 0, 0, 0),
							fluidSizing = false,
							textXAlignment = Enum.TextXAlignment.Left,
							textYAlignment = Enum.TextYAlignment.Center,
							automaticSize = Enum.AutomaticSize.Y,
							text = props.message
						})
					}
				)
			})

			return Roact.createElement("ImageButton", {
				AutoButtonColor = false,
				Size = UDim2.new(1, 0, 1, 0),
				ImageTransparency = 1,
				BackgroundColor3 = Color3.new(0, 0, 0),
				BackgroundTransparency = 1,
				BorderSizePixel = 0
			}, {
				Overlay = Roact.createElement(
					"Frame",
					{
						Size = UDim2.new(1, 0, 1, 0),
						BorderSizePixel = 0,
						BackgroundTransparency = 1
					},
					{ Content = element }
				)
			})
		end)
	end)
end

local v8 = roactServices.connect({ eventIngest = module8, networking = module9 })(extended)

local v9 = RoactRodux.connect(function(p2, p3)
	local v10 = { screenSize = p2.ScreenSize, pageName = 0 }
	local v11 = if not fFlagSignalsNavP3dRouteGated then module7(p2) else nil
	v10.pageName = v11
	return v10
end, function(callback)
	return {
		navigateDown = function(p2)
			return callback(module2(p2))
		end,
		navigateBack = function()
			return callback(RobloxAppToastsRodux())
		end,
		dispatchFetchGameDetailsPageData = function(p2, p3, p4, p5)
			if not fFlagLuaAppEdpBackendV2HydrateLegacyIxp then
				p5 = nil
			end

			return callback(module4(p2, p3, p4, p5))
		end
	}
end)(v8)

local fn = fFlagLuaAppEdpBackendV2HydrateLegacyIxp and function(p2)
	local shouldHydrateLegacy = module.getShouldHydrateLegacy()

	React.useEffect(function()
		IXPService:LogUserLayerExposure(appUserLayers.ExperienceDetailsPageExposureLayer)
	end, {})

	return Roact.createElement(
		v9,
		Cryo.Dictionary.join(p2, { shouldHydrateLegacyIxp = shouldHydrateLegacy })
	)
end or v9

return function(p2)
	local v10 = useAppPolicy(function(p3)
		return p3.getWebViewSupport()
	end)

	local joined = Cryo.Dictionary.join(p2, { areWebviewsSupported = v10 })

	return Roact.createElement(fn, joined)
end
