local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local module = require("@luauforge/bundled/fvF")
local module2 = require("@luauforge/bundled/eda")

local module3 = require("@luauforge/bundled/fTi")
local module4 = require("@luauforge/bundled/dMx")

local module5 = require("@luauforge/deferred/gfb")
local module6 = require("@luauforge/deferred/gfc")
local module7 = require("@luauforge/bundled/dTM")
local module8 = require("@luauforge/deferred/gfE")
local module9 = require("@luauforge/bundled/eeH")
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation

local UIBlox = require(CorePackages.Packages.UIBlox)
local interactiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local buttonType = UIBlox.App.Button.Enum.ButtonType

local function DeleteAvatarConfirmationPrompt(p2)
	local v5 = useDispatch()
	local v6 = useNavigation()
	local v7 = module9(module2)
	local v8 = module9(module)
	local v9 = module3({
		titleText = "Feature.Catalog.Action.DeleteAvatar",
		messageText = "Feature.Catalog.Label.DeleteAvatarConfirmationPromptMessage",
		deleteButtonText = "Feature.Catalog.Action.Delete",
		cancelButtonText = "Feature.Catalog.Action.Cancel"
	})

	local state, setState = React.useState(false)

	local v10 = useSelector(function(p3)
		return p3.ScreenSize
	end)

	local v11 = React.useCallback(function()
		module7.closeOverlay(v6)
	end, { v6 })

	local v12 = React.useCallback(function()
		setState(true)
		local lookId = p2.lookId
		local onOverlayClosed = p2.onOverlayClosed
		local v13 = v8

		v5(module8(v7, lookId)):andThen(function()
			module7.closeOverlay(v6)
			onOverlayClosed()
			module7.closeTryOnManager(v6, { avatarScreen.LookDetails })
		end):catch(function(p3)
			v13.sendAXCounterV2(module4.Counter.MySharedAvatars.MySharedAvatarsDeleteAvatarError)
		end):finally(function()
			setState(false)
		end)
	end, { p2.lookId, p2.onOverlayClosed, v7, v8, v6, state })

	return Roact.createElement(interactiveAlert, {
		title = v9.titleText,
		bodyText = v9.messageText,
		buttonStackInfo = {
			buttons = {
				{
					props = { onActivated = v11, text = v9.cancelButtonText },
					isDefaultChild = true
				},
				{
					buttonType = buttonType.PrimarySystem,
					props = {
						onActivated = v12,
						text = v9.deleteButtonText,
						isLoading = state
					}
				}
			}
		},
		screenSize = v10
	})
end

return (module5((module6(DeleteAvatarConfirmationPrompt))))
