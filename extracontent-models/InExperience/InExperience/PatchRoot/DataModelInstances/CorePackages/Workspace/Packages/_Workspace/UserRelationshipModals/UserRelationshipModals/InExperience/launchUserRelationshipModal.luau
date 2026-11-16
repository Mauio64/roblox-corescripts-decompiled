local CoreGui = game:GetService("CoreGui")
local LocalizationService = game:GetService("LocalizationService")

local UserRelationshipModals = script:FindFirstAncestor("UserRelationshipModals")
local parent = UserRelationshipModals.Parent

local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local Provider = FocusNavigationUtils.FocusNavigableSurfaceRegistry.Provider
local Foundation = require(parent.Foundation)
local FoundationProvider = Foundation.FoundationProvider
local Localization = require(parent.Localization)
local LocalizationProvider = Localization.LocalizationProvider
local InExperienceLocales = require(parent.InExperienceLocales)
local localization = InExperienceLocales.Localization
local React = require(parent.React)
local ReactFocusNavigation = require(parent.ReactFocusNavigation)
local ReactRoblox = require(parent.ReactRoblox)
local Rodux = require(parent.Rodux)
local RoactRodux = require(parent.RoactRodux)

local installReducer = require(UserRelationshipModals.Rodux.installReducer)
local RODUX_KEY = require(UserRelationshipModals.Rodux.RODUX_KEY)

local function createRoduxStore()
	return Rodux.Store.new(Rodux.combineReducers({ [RODUX_KEY] = installReducer() }), nil, { Rodux.thunkMiddleware })
end

return function(p, p2)
	if CoreGui:FindFirstChild("UserRelationshipModal") then
		return
	end

	local userRelationshipModal = Instance.new("Folder")
	userRelationshipModal.Name = "UserRelationshipModal"
	userRelationshipModal.Parent = CoreGui
	local userRelationshipModalOverlay = Instance.new("ScreenGui")
	userRelationshipModalOverlay.Parent = userRelationshipModal
	userRelationshipModalOverlay.Name = "UserRelationshipModalOverlay"
	userRelationshipModalOverlay.DisplayOrder = -1
	userRelationshipModalOverlay.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	userRelationshipModalOverlay.Enabled = true
	userRelationshipModalOverlay.ScreenInsets = Enum.ScreenInsets.CoreUISafeInsets
	userRelationshipModalOverlay.SafeAreaCompatibility = Enum.SafeAreaCompatibility.None
	userRelationshipModalOverlay.ClipToDeviceSafeArea = false

	local clone = table.clone(p2)
	function clone.onClose()
		userRelationshipModal:Destroy()
	end

	local focusNavigationService = ReactFocusNavigation.FocusNavigationService.new(ReactFocusNavigation.EngineInterface.CoreGui)

	local element = React.createElement(
		LocalizationProvider,
		{
			localization = localization.new(LocalizationService.RobloxLocaleId)
		},
		{
			FoundationProvider = React.createElement(
				FoundationProvider,
				{
					colorMode = Foundation.Enums.ColorMode.Dark,
					overlayGui = userRelationshipModalOverlay
				},
				{
					FocusNavigationProvider = React.createElement(
						ReactFocusNavigation.FocusNavigationContext.Provider,
						{ value = focusNavigationService },
						{
							FocusNavigationRegistryProvider = React.createElement(Provider, nil, {
								StoreProvider = React.createElement(
									RoactRodux.StoreProvider,
									{ store = createRoduxStore() },
									{
										UserRelationshipModal = React.createElement(p, clone, {})
									}
								)
							})
						}
					)
				}
			)
		}
	)

	ReactRoblox.createRoot(userRelationshipModalOverlay):render(element)
end
