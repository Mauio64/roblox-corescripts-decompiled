local HttpService = game:GetService("HttpService")
local Parent = script:FindFirstAncestor("InExperienceShop").Parent
local React = require(Parent.React)
local requestInternalWrapper = require(Parent.Http).NetworkLayers.requestInternalWrapper
local CoreScriptsRootProvider = require(Parent.CoreScriptsRoactCommon).CoreScriptsRootProvider
local RoactNavigation = require(Parent.RoactNavigation)
local RoactNetworking = require(Parent.RoactServiceTags).RoactNetworking
local RoactServices = require(Parent.RoactServices).RoactServices
local FocusNavigationUtils = require(Parent.FocusNavigationUtils)
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local FocusRoot = FocusNavigationUtils.FocusRoot
local DynamicReportContainer = require(Parent.GenericAbuseReporting.DynamicReportContainer)

require(Parent.GenericAbuseReporting.AbuseVector)

local t1 = {
	isFocused = function() -- line: 30
		return true
	end,
	addListener = function(_: string, _: ((...any) -> ...any)) -- line: 33
		return {
			remove = function() -- line: 35
			end
		}
	end
}

local function ShopAbuseReportOverlay(t2: {[any]: any}) -- line: 40
	-- upvalues: React (copy), CoreScriptsRootProvider (copy), RoactNavigation (copy), t1 (copy), RoactServices (copy), RoactNetworking (copy), requestInternalWrapper (copy), HttpService (copy), FocusRoot (copy), FocusNavigableSurfaceIdentifierEnum (copy), DynamicReportContainer (copy)
	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ZIndex = 10,
		Size = UDim2.fromScale(1, 1)
	}, {
		Providers = React.createElement(CoreScriptsRootProvider, {}, {
			Navigation = React.createElement(RoactNavigation.Provider, {
				value = t1
			}, {
				Services = React.createElement(RoactServices.ServiceProvider, {
					services = {
						[RoactNetworking] = requestInternalWrapper(HttpService)
					}
				}, {
					FocusNavigationCoreScriptsWrapper = React.createElement(FocusRoot, {
						isIsolated = true,
						isAutoFocusRoot = true,
						frameProps = {
							Size = UDim2.fromScale(1, 1)
						},
						surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.CentralOverlay
					}, {
						DynamicReport = React.createElement(DynamicReportContainer, {
							abuseVector = t2.abuseVector,
							targetId = t2.targetId,
							onClose = t2.onClose
						})
					})
				})
			})
		})
	})
end

return ShopAbuseReportOverlay
