local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local peekViewState = require("@luauforge/bundled/dzD").PeekViewState
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation
local module = require("@luauforge/deferred/gfA")

local module2 = require("@luauforge/bundled/fTi")
local module3 = require("@luauforge/bundled/eeH")
local module4 = require("@luauforge/bundled/eda")
local setTryOnManagerPeekViewState = require("@luauforge/bundled/dHL").Actions.SetTryOnManagerPeekViewState
local module5 = require("@luauforge/deferred/goc")
local module6 = require("@luauforge/deferred/gfq")
local module7 = require("@luauforge/bundled/dTM")
local navigateWithLock = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Thunks.NavigateWithLock

local module8 = require("@luauforge/bundled/dCh")
local module9 = require("@luauforge/bundled/dwB")

local actionBar = UIBlox.App.Button.ActionBar
local buttonStack = UIBlox.App.Button.ButtonStack
local buttonType = UIBlox.App.Button.Enum.ButtonType

local module10 = require("@luauforge/deferred/god")

local function DraftLookBottomBar()
	local v5 = useDispatch()
	local v6 = module3(module4)
	local v7 = useNavigation()

	local state, setState = React.useState(false)

	local v8 = module()
	local supportShareButton = v8 and (v8.supportShareButton or v8.supportCopyLinkButton)
	local v9

	if module10() then
		v9 = module2({
			goBack = "Feature.Avatar.Action.GoBack",
			post = "Feature.Avatar.Action.ComposerPost"
		})
	else
		v9 = nil
	end

	local v10 = React.useMemo(function()
		return {
			props = {
				onActivated = function()
					v5(setTryOnManagerPeekViewState(peekViewState.Closed))
				end,
				text = not module10() and "Go Back" or v9.goBack,
				isLoading = false
			}
		}
	end, { v5 })

	local v11 = React.useMemo(function()
		return {
			buttonType = buttonType.PrimarySystem,
			isDefaultChild = true,
			props = {
				onActivated = function()
					if state then
						return
					end

					setState(true)

					v5(module5(v6)):andThen(function(p2)
						setState(false)

						if not p2 then
							return
						end

						v5(setTryOnManagerPeekViewState(peekViewState.Closed))
						module7.closeLookComposer(v7)
						v5(module6(v6))
						module7.navigateFromOverlay(v7, avatarScreen.MySharedAvatars)

						if supportShareButton then
							v5(navigateWithLock(function()
								local communityAvatarSharePrompt = avatarScreen.CommunityAvatarSharePrompt
								v7.navigate(communityAvatarSharePrompt, { lookId = p2 })
							end))
						end
					end):catch(function(p2)
						setState(false)

						v5(module8({
							toastMessage = "Feature.Toast.NetworkingError.SomethingIsWrong",
							toastType = module9.NetworkingError
						}))
					end)
				end,
				text = not module10() and "Share" or v9.post,
				isLoading = state
			}
		}
	end, { v5, state, supportShareButton })

	return React.createElement(actionBar, {}, {
		ButtonStack = React.createElement(buttonStack, {
			buttons = { v10, v11 }
		})
	})
end

return DraftLookBottomBar
