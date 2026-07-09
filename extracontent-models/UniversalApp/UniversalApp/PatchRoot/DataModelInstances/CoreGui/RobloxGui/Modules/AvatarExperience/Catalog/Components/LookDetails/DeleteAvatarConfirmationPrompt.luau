local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local Analytics = require(Modules.AvatarExperience.Catalog.Services.Analytics)
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local useLocalization = require(Modules.LuaApp.Hooks.useLocalization)
local Constants = require(Modules.AvatarExperience.Common.Constants)
local withMappedNavigationParams = require(Modules.AvatarExperience.Common.Components.RoactNavigation.withMappedNavigationParams)
local withOverlayFocusHandling = require(Modules.AvatarExperience.Common.Components.withOverlayFocusHandling)
local NavigationUtils = require(Modules.AvatarExperience.Common.Components.RoactNavigation.NavigationUtils)
local DeleteAvatar = require(Modules.AvatarExperience.Catalog.Thunks.DeleteAvatar)
local useRoactService = require(Modules.LuaApp.Hooks.useRoactService)
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local useNavigation = require(CorePackages.Workspace.Packages.Navigation).useNavigation
local UIBlox = require(CorePackages.Packages.UIBlox)
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType

local function DeleteAvatarConfirmationPrompt(t1: {[any]: any}) -- line: 34
	-- upvalues: useDispatch (copy), useNavigation (copy), useRoactService (copy), RoactNetworking (copy), Analytics (copy), useLocalization (copy), React (copy), useSelector (copy), NavigationUtils (copy), DeleteAvatar (copy), AvatarScreen (copy), Constants (copy), Roact (copy), InteractiveAlert (copy), ButtonType (copy)
	local v23 = useDispatch()
	local v24 = useNavigation()
	local v25 = useRoactService(RoactNetworking)
	local v26 = useRoactService(Analytics)
	local v27 = useLocalization({
		titleText = "Feature.Catalog.Action.DeleteAvatar",
		messageText = "Feature.Catalog.Label.DeleteAvatarConfirmationPromptMessage",
		deleteButtonText = "Feature.Catalog.Action.Delete",
		cancelButtonText = "Feature.Catalog.Action.Cancel"
	})
	local v28, v29 = React.useState(false)
	local v30 = useSelector(function(p1) -- line: 48
		return p1.ScreenSize
	end)
	local v31 = React.useCallback(function() -- line: 52
		-- upvalues: NavigationUtils (copy), v24 (copy)
		NavigationUtils.closeOverlay(v24)
	end, { v24 })
	local v32 = React.useCallback(function() -- line: 56
		-- upvalues: v29 (copy), t1 (copy), v26 (copy), v23 (copy), DeleteAvatar (copy), v25 (copy), NavigationUtils (copy), v24 (copy), AvatarScreen (copy), Constants (copy)
		v29(true)

		local lookId = t1.lookId
		local onOverlayClosed = t1.onOverlayClosed
		local v36 = v26

		v23(DeleteAvatar(v25, lookId)):andThen(function() -- line: 63
			-- upvalues: NavigationUtils (copy), v24 (copy), onOverlayClosed (copy), AvatarScreen (copy)
			NavigationUtils.closeOverlay(v24)
			onOverlayClosed()
			NavigationUtils.closeTryOnManager(v24, { AvatarScreen.LookDetails })
		end):catch(function(_) -- line: 68
			-- upvalues: v36 (copy), Constants (copy)
			v36.sendAXCounterV2(Constants.Counter.MySharedAvatars.MySharedAvatarsDeleteAvatarError)
		end):finally(function() -- line: 71
			-- upvalues: v29 (copy)
			v29(false)
		end)
	end, {
		t1.lookId,
		t1.onOverlayClosed,
		v25,
		v26,
		v24,
		v28
	})

	return Roact.createElement(InteractiveAlert, {
		title = v27.titleText,
		bodyText = v27.messageText,
		buttonStackInfo = {
			buttons = {
				{
					isDefaultChild = true,
					props = {
						onActivated = v31,
						text = v27.cancelButtonText
					}
				},
				{
					buttonType = ButtonType.PrimarySystem,
					props = {
						onActivated = v32,
						text = v27.deleteButtonText,
						isLoading = v28
					}
				}
			}
		},
		screenSize = v30
	})
end

return (withMappedNavigationParams((withOverlayFocusHandling(DeleteAvatarConfirmationPrompt))))
