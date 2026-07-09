local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local React = require(CorePackages.Packages.React)
local RoactUtils = require(CorePackages.Workspace.Packages.RoactUtils)
local AvatarExperienceInitialization = require(Modules.AvatarExperience.Common.Components.AvatarExperienceInitialization)
local AvatarSceneManager = require(Modules.AvatarExperience.Common.Managers.AvatarSceneManager)
local ItemSelectionManager = require(Modules.AvatarExperience.Common.Components.ItemSelectionManager)
local LoginStatus = require(Modules.LuaApp.Enum.LoginStatus)
local AvatarExperienceIXPDiagnostics = require(Modules.AvatarExperience.Common.Debug.AvatarExperienceIXPDiagnostics)
local AXPrefetchMarketplaceIXP = require(CorePackages.Workspace.Packages.AvatarExperienceExperiments).AXPrefetchMarketplaceIXP
local usePrefetchMarketplace = require(Modules.AvatarExperience.Common.Components.WidgetList.Hooks.usePrefetchMarketplace)
local useIsSpatial = require(CorePackages.Workspace.Packages.Responsive).useIsSpatial
local useStore = RoactUtils.Hooks.RoactRodux.useStore
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local FFlagAXDebugPanel = AvatarExperienceFlags.FFlagAXDebugPanel
local FFlagAXBackgroundsCycloramaVR = AvatarExperienceFlags.FFlagAXBackgroundsCycloramaVR

local function AvatarExperienceMountedAtStartup(p1) -- line: 48
	-- upvalues: useIsSpatial (copy), useStore (copy), LoginStatus (copy), AXPrefetchMarketplaceIXP (copy), usePrefetchMarketplace (copy), FFlagAXDebugPanel (copy), React (copy), CorePackages (copy), ItemSelectionManager (copy), AvatarSceneManager (copy), FFlagAXBackgroundsCycloramaVR (copy), AvatarExperienceInitialization (copy), AvatarExperienceIXPDiagnostics (copy)
	local v22 = useIsSpatial()
	local shouldStart = p1.shouldStart
	local v24 = useStore()
	local v25 = p1.authStatus == LoginStatus.LOGGED_IN or shouldStart

	if AXPrefetchMarketplaceIXP.isEnabled() then
		usePrefetchMarketplace()
	end

	if FFlagAXDebugPanel then
		React.useEffect(function() -- line: 64
			-- upvalues: CorePackages (copy)
			return (require(CorePackages.Workspace.Packages.AvatarExperienceDebugSections).register())
		end, {})
	end

	return React.createElement(React.Fragment, {}, {
		ItemSelectionManager = React.createElement(ItemSelectionManager),
		AvatarSceneManager = if not v25 then nil else React.createElement(AvatarSceneManager, {
			store = v24,
			shouldStart = shouldStart,
			shouldManageBackground = not v22 or FFlagAXBackgroundsCycloramaVR,
			isSpatial = v22,
			renderSky = shouldStart
		}),
		AvatarExperienceInitialization = if not v25 then nil else React.createElement(AvatarExperienceInitialization),
		AvatarExperienceIXPDiagnostics = React.createElement(AvatarExperienceIXPDiagnostics)
	})
end
local function mapStateToProps(p2, _) -- line: 97
	return {
		authStatus = p2.AuthenticationStatus.status
	}
end

return (RoactRodux.connect(mapStateToProps, nil)(AvatarExperienceMountedAtStartup))
