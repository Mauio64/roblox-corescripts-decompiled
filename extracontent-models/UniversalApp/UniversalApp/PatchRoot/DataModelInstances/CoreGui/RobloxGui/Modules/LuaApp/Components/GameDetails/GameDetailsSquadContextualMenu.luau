local CorePackages = game:GetService("CorePackages")
local CloseCentralOverlay = require(CorePackages.Workspace.Packages.CentralOverlay).Thunks.CloseCentralOverlay
local DeviceOrientationMode = require(CorePackages.Workspace.Packages.RobloxAppEnums).DeviceOrientationMode
local GamePlayButton = require(CorePackages.Workspace.Packages.GamePlayButton)
local Otter = require(CorePackages.Packages.Otter)
local React = require(CorePackages.Packages.React)
local RobloxAppHooks = require(CorePackages.Workspace.Packages.RobloxAppHooks)
local UIBlox = require(CorePackages.Packages.UIBlox)
local mutedError = require(CorePackages.Workspace.Packages.Loggers).mutedError
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local FFlagEnablePrivatePartyStartJoin = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnablePrivatePartyStartJoin
local useDeviceOrientation = RobloxAppHooks.useDeviceOrientation
local useScreenSize = RobloxAppHooks.useScreenSize
local ContextualMenu = UIBlox.App.Menu.ContextualMenu
local MenuDirection = UIBlox.App.Menu.MenuDirection
local PlayButtonStates = GamePlayButton.PlayButtonStates
local useOnPlayButtonCallback = GamePlayButton.useOnPlayButtonCallback

return function(t1: {[any]: any}) -- line: 39
	-- upvalues: useDispatch (copy), useLocalization (copy), FFlagEnablePrivatePartyStartJoin (copy), useOnPlayButtonCallback (copy), useScreenSize (copy), useDeviceOrientation (copy), DeviceOrientationMode (copy), MenuDirection (copy), mutedError (copy), React (copy), CloseCentralOverlay (copy), PlayButtonStates (copy), ContextualMenu (copy), Otter (copy)
	local v20 = useDispatch()
	local v21 = useLocalization({
		joinWithParty = "Feature.Squads.Action.JoinWithParty",
		soloPlay = "Feature.Squads.Label.SoloPlay",
		joinWithPrivateParty = if not FFlagEnablePrivatePartyStartJoin then nil else "Feature.Squads.Action.JoinWithPrivateParty"
	})
	local v22 = useOnPlayButtonCallback(t1.universeId, t1.referralSource, "SquadContextualMenu", nil, nil, nil, nil)
	local v23 = useOnPlayButtonCallback(t1.universeId, t1.referralSource, "SquadContextualMenu", nil, nil, {
		joinAttemptOrigin = "SquadJoinSoloButton"
	}, nil)
	local v24 = useScreenSize()
	local v25 = useDeviceOrientation() or DeviceOrientationMode.Portrait
	local landscapeMenuDirection = nil
	local uDim2 = nil
	local uDim2_2 = nil

	if v25 == DeviceOrientationMode.Landscape then
		if t1.landscapeMenuDirection == MenuDirection.Up then
			uDim2 = UDim2.fromOffset(t1.menuAnchorPosition.X + t1.menuAnchorSize.X - 250, t1.menuAnchorPosition.Y - 12)
		elseif t1.landscapeMenuDirection == MenuDirection.Down then
			uDim2 = UDim2.fromOffset(t1.menuAnchorPosition.X + t1.menuAnchorSize.X - 250, t1.menuAnchorPosition.Y + t1.menuAnchorSize.Y + 12)
		else
			mutedError(`Squad contextual menu received unsupported menu direction: { t1.landscapeMenuDirection }`)
		end

		landscapeMenuDirection = t1.landscapeMenuDirection
		uDim2_2 = UDim2.new(0, 250, 1, 0)
	elseif v25 == DeviceOrientationMode.Portrait then
		landscapeMenuDirection = MenuDirection.Up
		uDim2 = UDim2.fromOffset(0, 0)
		uDim2_2 = UDim2.fromScale(1, 1)
	else
		mutedError(`Squad contextual menu received unsupported device orientation: { v25 }`)
	end

	local v29 = React.useCallback(function() -- line: 88
		-- upvalues: v20 (copy), CloseCentralOverlay (copy)
		v20(CloseCentralOverlay())
	end, { v20 })
	local v30 = React.useMemo(function() -- line: 92
		-- upvalues: v21 (copy), v22 (copy), PlayButtonStates (copy), v29 (copy), FFlagEnablePrivatePartyStartJoin (copy), v23 (copy)
		local t2 = {}

		table.insert(t2, {
			text = v21.joinWithParty,
			onActivated = function() -- line: 96
				-- upvalues: v22 (copy), PlayButtonStates (copy), v29 (copy)
				v22(PlayButtonStates.PlayableWithParty)
				v29()
			end
		})

		if FFlagEnablePrivatePartyStartJoin then
			table.insert(t2, {
				text = v21.joinWithPrivateParty,
				onActivated = function() -- line: 104
					-- upvalues: v22 (copy), PlayButtonStates (copy), v29 (copy)
					v22(PlayButtonStates.PlayableWithParty, nil, {
						isPrivateParty = true
					})
					v29()
				end
			})
		end

		table.insert(t2, {
			text = v21.soloPlay,
			onActivated = function() -- line: 114
				-- upvalues: v23 (copy), PlayButtonStates (copy), v29 (copy)
				v23(PlayButtonStates.Playable)
				v29()
			end
		})

		return t2
	end, {
		v21.soloPlay,
		v21.joinWithParty,
		if not FFlagEnablePrivatePartyStartJoin then nil else v21.joinWithPrivateParty,
		v29,
		v23,
		v22
	})
	local v31 = React.useMemo(function() -- line: 129
		-- upvalues: v25 (copy), DeviceOrientationMode (copy), React (copy), ContextualMenu (copy), v30 (copy), landscapeMenuDirection (ref), Otter (copy), v29 (copy), v24 (copy)
		if v25 == DeviceOrientationMode.Landscape then
			return React.createElement(ContextualMenu, {
				closeBackgroundVisible = false,
				open = true,
				showDropShadow = true,
				buttonProps = v30,
				contextMenuWidthOverride = UDim.new(1, 0),
				horizontalAlignment = Enum.HorizontalAlignment.Left,
				menuDirection = landscapeMenuDirection,
				motorOverrideOptions = {
					motorCallback = Otter.instant,
					open = {
						targetValue = 1
					},
					close = {
						targetValue = 0
					}
				},
				onDismiss = v29,
				openPositionY = UDim.new(0, 0),
				screenSize = v24
			})
		end

		return React.createElement(ContextualMenu, {
			closeBackgroundVisible = false,
			open = true,
			showDropShadow = true,
			buttonProps = v30,
			menuDirection = landscapeMenuDirection,
			onDismiss = v29,
			openPositionY = UDim.new(1, -76),
			screenSize = v24
		})
	end, {
		v30,
		v25,
		landscapeMenuDirection,
		v29,
		v24
	})

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Position = uDim2,
		Size = uDim2_2
	}, {
		ContextMenu = v31
	})
end
