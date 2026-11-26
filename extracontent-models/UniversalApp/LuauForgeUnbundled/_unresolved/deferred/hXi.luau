local CorePackages = game:GetService("CorePackages")

local closeCentralOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/CentralOverlay").Thunks.CloseCentralOverlay
local deviceOrientationMode = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").DeviceOrientationMode
local module = require("@luauforge/bundled/fIC")
local Otter = require(CorePackages.Packages.Otter)
local React = require(CorePackages.Packages.React)
local RobloxAppHooks = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks")
local UIBlox = require(CorePackages.Packages.UIBlox)
local mutedError = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/Loggers").mutedError
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization

local fFlagEnablePrivatePartyStartJoin = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnablePrivatePartyStartJoin

local useDeviceOrientation = RobloxAppHooks.useDeviceOrientation
local useScreenSize = RobloxAppHooks.useScreenSize

local contextualMenu = UIBlox.App.Menu.ContextualMenu
local menuDirection = UIBlox.App.Menu.MenuDirection

local playButtonStates = module.PlayButtonStates
local useOnPlayButtonCallback = module.useOnPlayButtonCallback

return function(props)
	local v5 = useDispatch()

	local v6 = useLocalization({
		joinWithParty = "Feature.Squads.Action.JoinWithParty",
		joinWithPrivateParty = fFlagEnablePrivatePartyStartJoin and "Feature.Squads.Action.JoinWithPrivateParty" or nil,
		soloPlay = "Feature.Squads.Label.SoloPlay"
	})

	local v7 = useOnPlayButtonCallback(
		props.universeId,
		props.referralSource,
		"SquadContextualMenu",
		nil,
		nil,
		nil,
		nil
	)

	local v8 = useOnPlayButtonCallback(
		props.universeId,
		props.referralSource,
		"SquadContextualMenu",
		nil,
		nil,
		{ joinAttemptOrigin = "SquadJoinSoloButton" },
		nil
	)

	local v9 = useScreenSize()
	local v10 = useDeviceOrientation() or deviceOrientationMode.Portrait

	local v11 = nil
	local udim = nil
	local udim2 = nil

	if v10 == deviceOrientationMode.Landscape then
		if props.landscapeMenuDirection == menuDirection.Up then
			udim = UDim2.fromOffset(
				props.menuAnchorPosition.X + props.menuAnchorSize.X - 250,
				props.menuAnchorPosition.Y - 12
			)
		elseif props.landscapeMenuDirection == menuDirection.Down then
			udim = UDim2.fromOffset(
				props.menuAnchorPosition.X + props.menuAnchorSize.X - 250,
				props.menuAnchorPosition.Y + props.menuAnchorSize.Y + 12
			)
		else
			mutedError(`Squad contextual menu received unsupported menu direction: {props.landscapeMenuDirection}`)
		end

		v11 = props.landscapeMenuDirection
		udim2 = UDim2.new(0, 250, 1, 0)
	elseif v10 == deviceOrientationMode.Portrait then
		v11 = menuDirection.Up
		udim = UDim2.fromOffset(0, 0)
		udim2 = UDim2.fromScale(1, 1)
	else
		mutedError(`Squad contextual menu received unsupported device orientation: {v10}`)
	end

	local v12 = React.useCallback(function()
		v5(closeCentralOverlay())
	end, { v5 })

	local useMemo = React.useMemo
	local function fn()
		local v13 = {}
		table.insert(v13, {
			text = v6.joinWithParty,
			onActivated = function()
				v7(playButtonStates.PlayableWithParty)
				v12()
			end
		})

		if fFlagEnablePrivatePartyStartJoin then
			table.insert(v13, {
				text = v6.joinWithPrivateParty,
				onActivated = function()
					v7(playButtonStates.PlayableWithParty, nil, {
						isPrivateParty = true
					})

					v12()
				end
			})
		end

		table.insert(v13, {
			text = v6.soloPlay,
			onActivated = function()
				v8(playButtonStates.Playable)
				v12()
			end
		})

		return v13
	end

	local soloPlay = v6.soloPlay
	local joinWithParty = v6.joinWithParty
	local v14 = if fFlagEnablePrivatePartyStartJoin then v6.joinWithPrivateParty else nil
	local v15 = useMemo(fn, { soloPlay, joinWithParty, v14, v12, v8, v7 })

	local v16 = React.useMemo(function()
		if v10 == deviceOrientationMode.Landscape then
			return React.createElement(contextualMenu, {
				buttonProps = v15,
				closeBackgroundVisible = false,
				contextMenuWidthOverride = UDim.new(1, 0),
				horizontalAlignment = Enum.HorizontalAlignment.Left,
				menuDirection = v11,
				motorOverrideOptions = {
					motorCallback = Otter.instant,
					open = { targetValue = 1 },
					close = { targetValue = 0 }
				},
				onDismiss = v12,
				open = true,
				openPositionY = UDim.new(0, 0),
				screenSize = v9,
				showDropShadow = true
			})
		end

		return React.createElement(contextualMenu, {
			buttonProps = v15,
			closeBackgroundVisible = false,
			menuDirection = v11,
			onDismiss = v12,
			open = true,
			openPositionY = UDim.new(1, -76),
			screenSize = v9,
			showDropShadow = true
		})
	end, { v15, v10, v11, v12, v9 })

	return React.createElement("Frame", {
		Position = udim,
		Size = udim2,
		BackgroundTransparency = 1
	}, {
		ContextMenu = v16
	})
end
