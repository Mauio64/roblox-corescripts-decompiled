local HttpService = game:GetService("HttpService")

local parent = script:FindFirstAncestor("InExperienceShop").Parent

local React = require(parent.React)
local Http = require(parent.Http)
local requestInternalWrapper = Http.NetworkLayers.requestInternalWrapper
local CoreScriptsRoactCommon = require(parent.CoreScriptsRoactCommon)
local CoreScriptsRootProvider = CoreScriptsRoactCommon.CoreScriptsRootProvider
local RoactNavigation = require(parent.RoactNavigation)
local RoactServiceTags = require(parent.RoactServiceTags)
local RoactNetworking = RoactServiceTags.RoactNetworking
local RoactServices = require(parent.RoactServices)
local roactServices = RoactServices.RoactServices
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local FocusRoot = FocusNavigationUtils.FocusRoot
local DynamicReportContainer = require(parent.GenericAbuseReporting.DynamicReportContainer)
require(parent.GenericAbuseReporting.AbuseVector)

local v = {
	isFocused = function(): boolean
		return true
	end,
	addListener = function(_: string, _)
		return {
			remove = function() end
		}
	end
}

local function ShopAbuseReportOverlay(props)
	return React.createElement(
		"Frame",
		{
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ZIndex = 10
		},
		{
			Providers = React.createElement(CoreScriptsRootProvider, {}, {
				Navigation = React.createElement(RoactNavigation.Provider, { value = v }, {
					Services = React.createElement(roactServices.ServiceProvider, {
						services = {
							[RoactNetworking] = requestInternalWrapper(HttpService)
						}
					}, {
						FocusNavigationCoreScriptsWrapper = React.createElement(FocusRoot, {
							frameProps = { Size = UDim2.fromScale(1, 1) },
							surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.CentralOverlay,
							isIsolated = true,
							isAutoFocusRoot = true
						}, {
							DynamicReport = React.createElement(DynamicReportContainer, {
								abuseVector = props.abuseVector,
								targetId = props.targetId,
								onClose = props.onClose
							})
						})
					})
				})
			})
		}
	)
end

return ShopAbuseReportOverlay
