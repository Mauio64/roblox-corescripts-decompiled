local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local PeekViewState = require(CorePackages.Workspace.Packages.PeekView).PeekViewState
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local useNavigation = require(CorePackages.Workspace.Packages.Navigation).useNavigation
local useSharePolicy = require(Modules.AvatarExperience.Common.Hooks.useSharePolicy)
local useLocalization = require(Modules.LuaApp.Hooks.useLocalization)
local useRoactService = require(Modules.LuaApp.Hooks.useRoactService)
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local SetTryOnManagerPeekViewState = require(CorePackages.Workspace.Packages.AvatarExperienceRodux).Actions.SetTryOnManagerPeekViewState
local CreateLook = require(Modules.AvatarExperience.AvatarEditor.Thunks.CreateLook)
local FetchMySharedAvatars = require(Modules.AvatarExperience.AvatarEditor.Thunks.FetchMySharedAvatars)
local NavigationUtils = require(Modules.AvatarExperience.Common.Components.RoactNavigation.NavigationUtils)
local NavigateWithLock = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Thunks.NavigateWithLock
local SetCurrentToastMessage = require(Modules.LuaApp.Actions.SetCurrentToastMessage)
local ToastType = require(Modules.LuaApp.Enum.ToastType)
local ActionBar = UIBlox.App.Button.ActionBar
local ButtonStack = UIBlox.App.Button.ButtonStack
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local GetFFlagAXLooksTranslationAudit = require(Modules.AvatarExperience.Flags.GetFFlagAXLooksTranslationAudit)
local v24 = game:DefineFastFlag("AXFixCommunityAvatarsPeekViewClose", false)

local function DraftLookBottomBar() -- line: 36
	-- upvalues: useDispatch (copy), useRoactService (copy), RoactNetworking (copy), useNavigation (copy), React (copy), useSharePolicy (copy), GetFFlagAXLooksTranslationAudit (copy), useLocalization (copy), SetTryOnManagerPeekViewState (copy), PeekViewState (copy), ButtonType (copy), CreateLook (copy), v24 (copy), NavigationUtils (copy), FetchMySharedAvatars (copy), AvatarScreen (copy), NavigateWithLock (copy), SetCurrentToastMessage (copy), ToastType (copy), ActionBar (copy), ButtonStack (copy)
	local v26 = useDispatch()
	local v27 = useRoactService(RoactNetworking)
	local v28 = useNavigation()
	local v29, v30 = React.useState(false)
	local v31 = useSharePolicy()
	local v32 = v31 and (v31.supportShareButton or v31.supportCopyLinkButton)
	local v33 = if not GetFFlagAXLooksTranslationAudit() then nil else useLocalization({
		goBack = "Feature.Avatar.Action.GoBack",
		post = "Feature.Avatar.Action.ComposerPost"
	})
	local v34 = React.useMemo(function() -- line: 53
		-- upvalues: v26 (copy), SetTryOnManagerPeekViewState (copy), PeekViewState (copy), GetFFlagAXLooksTranslationAudit (copy), v33 (copy)
		return {
			props = {
				isLoading = false,
				onActivated = function() -- line: 56
					-- upvalues: v26 (copy), SetTryOnManagerPeekViewState (copy), PeekViewState (copy)
					v26(SetTryOnManagerPeekViewState(PeekViewState.Closed))
				end,
				text = not GetFFlagAXLooksTranslationAudit() and "Go Back" or v33.goBack
			}
		}
	end, { v26 })
	local v35 = React.useMemo(function() -- line: 65
		-- upvalues: ButtonType (copy), v29 (copy), v30 (copy), v26 (copy), CreateLook (copy), v27 (copy), v24 (copy), SetTryOnManagerPeekViewState (copy), PeekViewState (copy), NavigationUtils (copy), v28 (copy), FetchMySharedAvatars (copy), AvatarScreen (copy), v32 (copy), NavigateWithLock (copy), SetCurrentToastMessage (copy), ToastType (copy), GetFFlagAXLooksTranslationAudit (copy), v33 (copy)
		return {
			isDefaultChild = true,
			buttonType = ButtonType.PrimarySystem,
			props = {
				onActivated = function() -- line: 70
					-- upvalues: v29 (copy), v30 (copy), v26 (copy), CreateLook (copy), v27 (copy), v24 (copy), SetTryOnManagerPeekViewState (copy), PeekViewState (copy), NavigationUtils (copy), v28 (copy), FetchMySharedAvatars (copy), AvatarScreen (copy), v32 (copy), NavigateWithLock (copy), SetCurrentToastMessage (copy), ToastType (copy)
					if v29 then
						return
					end

					v30(true)
					v26(CreateLook(v27)):andThen(function(p1) -- line: 78
						-- upvalues: v30 (copy), v24 (copy), v26 (copy), SetTryOnManagerPeekViewState (copy), PeekViewState (copy), NavigationUtils (copy), v28 (copy), FetchMySharedAvatars (copy), v27 (copy), AvatarScreen (copy), v32 (copy), NavigateWithLock (copy)
						v30(false)

						if not p1 then
							return
						end

						if v24 then
							v26(SetTryOnManagerPeekViewState(PeekViewState.Closed))
						end

						NavigationUtils.closeLookComposer(v28)
						v26(FetchMySharedAvatars(v27))
						NavigationUtils.navigateFromOverlay(v28, AvatarScreen.MySharedAvatars)

						if v32 then
							v26(NavigateWithLock(function() -- line: 94
								-- upvalues: AvatarScreen (copy), p1 (copy), v28 (copy)
								local CommunityAvatarSharePrompt = AvatarScreen.CommunityAvatarSharePrompt
								local t1 = {
									lookId = p1
								}

								v28.navigate(CommunityAvatarSharePrompt, t1)
							end))
						end
					end):catch(function(_) -- line: 104
						-- upvalues: v30 (copy), v26 (copy), SetCurrentToastMessage (copy), ToastType (copy)
						v30(false)
						v26(SetCurrentToastMessage({
							toastMessage = "Feature.Toast.NetworkingError.SomethingIsWrong",
							toastType = ToastType.NetworkingError
						}))
					end)
				end,
				text = not GetFFlagAXLooksTranslationAudit() and "Share" or v33.post,
				isLoading = v29
			}
		}
	end, {
		v26,
		v29,
		v32
	})

	return React.createElement(ActionBar, {}, {
		ButtonStack = React.createElement(ButtonStack, {
			buttons = {
				v34,
				v35
			}
		})
	})
end

return DraftLookBottomBar
