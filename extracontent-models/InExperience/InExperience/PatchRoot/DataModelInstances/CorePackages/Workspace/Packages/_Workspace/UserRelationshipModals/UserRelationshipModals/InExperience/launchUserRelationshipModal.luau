local CoreGui = game:GetService("CoreGui")
local LocalizationService = game:GetService("LocalizationService")
local UserRelationshipModals = script:FindFirstAncestor("UserRelationshipModals")
local UserRelationshipModalsParent = UserRelationshipModals.Parent
local Provider = require(UserRelationshipModalsParent.FocusNavigationUtils).FocusNavigableSurfaceRegistry.Provider
local Foundation = require(UserRelationshipModalsParent.Foundation)
local FoundationProvider = Foundation.FoundationProvider
local LocalizationProvider = require(UserRelationshipModalsParent.Localization).LocalizationProvider
local Localization = require(UserRelationshipModalsParent.InExperienceLocales).Localization
local React = require(UserRelationshipModalsParent.React)
local ReactFocusNavigation = require(UserRelationshipModalsParent.ReactFocusNavigation)
local ReactRoblox = require(UserRelationshipModalsParent.ReactRoblox)
local Rodux = require(UserRelationshipModalsParent.Rodux)
local RoactRodux = require(UserRelationshipModalsParent.RoactRodux)
local installReducer = require(UserRelationshipModals.Rodux.installReducer)
local RODUX_KEY = require(UserRelationshipModals.Rodux.RODUX_KEY)

local function createRoduxStore() -- line: 23
	-- upvalues: Rodux (copy), RODUX_KEY (copy), installReducer (copy)
	return Rodux.Store.new(Rodux.combineReducers({
		[RODUX_KEY] = installReducer()
	}), nil, { Rodux.thunkMiddleware })
end

return function(p1, p2) -- line: 33
	-- upvalues: CoreGui (copy), ReactFocusNavigation (copy), React (copy), LocalizationProvider (copy), Localization (copy), LocalizationService (copy), FoundationProvider (copy), Foundation (copy), Provider (copy), RoactRodux (copy), createRoduxStore (copy), ReactRoblox (copy)
	if CoreGui:FindFirstChild("UserRelationshipModal") then
		return
	end

	local Folder = Instance.new("Folder")

	Folder.Name = "UserRelationshipModal"
	Folder.Parent = CoreGui

	local ScreenGui = Instance.new("ScreenGui")

	ScreenGui.Parent = Folder
	ScreenGui.Name = "UserRelationshipModalOverlay"
	ScreenGui.DisplayOrder = -1
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	ScreenGui.Enabled = true
	ScreenGui.ScreenInsets = Enum.ScreenInsets.CoreUISafeInsets
	ScreenGui.SafeAreaCompatibility = Enum.SafeAreaCompatibility.None
	ScreenGui.ClipToDeviceSafeArea = false

	local v22 = table.clone(p2)

	function v22.onClose() -- line: 52
		-- upvalues: Folder (copy)
		Folder:Destroy()
	end

	local v23 = ReactFocusNavigation.FocusNavigationService.new(ReactFocusNavigation.EngineInterface.CoreGui)
	local v24 = React.createElement(LocalizationProvider, {
		localization = Localization.new(LocalizationService.RobloxLocaleId)
	}, {
		FoundationProvider = React.createElement(FoundationProvider, {
			theme = Foundation.Enums.Theme.Dark,
			overlayGui = ScreenGui
		}, {
			FocusNavigationProvider = React.createElement(ReactFocusNavigation.FocusNavigationContext.Provider, {
				value = v23
			}, {
				FocusNavigationRegistryProvider = React.createElement(Provider, nil, {
					StoreProvider = React.createElement(RoactRodux.StoreProvider, {
						store = createRoduxStore()
					}, {
						UserRelationshipModal = React.createElement(p1, v22, {})
					})
				})
			})
		})
	})

	ReactRoblox.createRoot(ScreenGui):render(v24)
end
