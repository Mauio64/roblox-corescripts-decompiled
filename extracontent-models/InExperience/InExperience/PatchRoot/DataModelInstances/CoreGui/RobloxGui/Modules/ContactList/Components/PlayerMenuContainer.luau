local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Players = game:GetService("Players")
local React = require(CorePackages.Packages.React)
local Roact = require(CorePackages.Packages.Roact)
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local ContactList = RobloxGui.Modules.ContactList
local BlockPlayer = require(RobloxGui.Modules.PlayerList.Thunks.BlockPlayer)
local dependencies = require(ContactList.dependencies)
local UnfriendTargetUserId = dependencies.NetworkingFriends.UnfriendTargetUserId
local UIBlox = dependencies.UIBlox
local useSelector = dependencies.Hooks.useSelector
local useDispatch = dependencies.Hooks.useDispatch
local useLocalization = dependencies.Hooks.useLocalization
local CloseCFM = require(ContactList.Actions.CloseCFM)
local useAnalytics = require(ContactList.Analytics.useAnalytics)
local EventNamesEnum = require(ContactList.Analytics.EventNamesEnum)
local ConfigureFriendMenu = require(ContactList.Components.ContactListCommon.ConfigureFriendMenu)
local FriendAction = require(ContactList.Enums.FriendAction)
local UpdateLastFriend = require(ContactList.Actions.UpdateLastFriend)
local useStyle = UIBlox.Core.Style.useStyle
local withStyle = UIBlox.Style.withStyle
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local LocalPlayer = Players.LocalPlayer
local v26 = LocalPlayer and LocalPlayer.UserId or 0

local function PlayerMenuContainer() -- line: 43
	-- upvalues: useAnalytics (copy), useStyle (copy), useDispatch (copy), useSelector (copy), useLocalization (copy), React (copy), FriendAction (copy), BlockPlayer (copy), UpdateLastFriend (copy), UnfriendTargetUserId (copy), v26 (copy), EventNamesEnum (copy), ConfigureFriendMenu (copy), withStyle (copy), Roact (copy), InteractiveAlert (copy), ButtonType (copy), CloseCFM (copy), CoreGui (copy)
	local v28 = useAnalytics()
	local Theme = useStyle().Theme
	local v30 = useDispatch()
	local v31 = useSelector(function(p1) -- line: 50
		return p1.PlayerMenu.isOpen
	end)
	local v32 = useSelector(function(p2) -- line: 54
		return p2.PlayerMenu.friend
	end)
	local v33 = useLocalization({
		blockAction = "Feature.Friends.Action.Block",
		unfriendAction = "Feature.Friends.Action.Unfriend",
		cancelAction = "Feature.Friends.Label.Cancel",
		blockTitle = {
			"Feature.Call.Label.Block",
			combinedName = v32.combinedName
		},
		unfriendTitle = {
			"Feature.Call.Label.Unfriend",
			combinedName = v32.combinedName
		},
		confirmationDescription = {
			"Feature.SettingsHub.Message.BlockConfirmation",
			DISPLAY_NAME = v32.combinedName,
			RBX_NAME = v32.userName
		}
	})
	local v34, v35 = React.useState(FriendAction.NoAction)
	local v36, v37 = React.useState(Vector2.new(0, 0))
	local v38, v39 = React.useState("")
	local v40, v41 = React.useState("")
	local v42 = React.useCallback(function() -- line: 72
		-- upvalues: v34 (copy), FriendAction (copy), v30 (copy), BlockPlayer (copy), v32 (copy), UpdateLastFriend (copy), UnfriendTargetUserId (copy), v26 (copy), v28 (copy), EventNamesEnum (copy)
		if v34 == FriendAction.Block then
			v30(BlockPlayer({
				UserId = v32.userId
			}))
			v30(UpdateLastFriend(v32.userId))

			return
		end

		if v34 == FriendAction.Unfriend then
			local v48 = UnfriendTargetUserId.API({
				currentUserId = v26,
				targetUserId = v32.userId
			})

			v30(v48):andThen(function(_) -- line: 84
				-- upvalues: v28 (copy), EventNamesEnum (copy), v32 (copy), v30 (copy), UpdateLastFriend (copy)
				v28.fireEvent(EventNamesEnum.PhoneBookPlayerMenuUnfriendFinished, {
					success = true,
					eventTimestampMs = os.time() * 1000,
					friendUserId = v32.userId
				})
				v30(UpdateLastFriend(v32.userId))
			end):catch(function(_) -- line: 92
				-- upvalues: v28 (copy), EventNamesEnum (copy), v32 (copy)
				v28.fireEvent(EventNamesEnum.PhoneBookPlayerMenuUnfriendFinished, {
					success = false,
					eventTimestampMs = os.time() * 1000,
					friendUserId = v32.userId
				})
			end)
		end
	end, {
		v34,
		v32.userId
	})

	React.useEffect(function() -- line: 102
		-- upvalues: v34 (copy), FriendAction (copy), v39 (copy), v33 (copy), v41 (copy)
		if v34 == FriendAction.Block then
			v39(v33.blockTitle)
			v41(v33.blockAction)

			return
		end

		if v34 == FriendAction.Unfriend then
			v39(v33.unfriendTitle)
			v41(v33.unfriendAction)
		end
	end, {
		v34,
		v32.combinedName,
		v33.blockAction,
		v33.blockTitle,
		v33.unfriendAction,
		v33.unfriendTitle
	})

	local v43 = React.useCallback(function(p5) -- line: 119
		-- upvalues: v35 (copy)
		v35(p5)
	end, {})
	local v44 = React.useMemo(function() -- line: 123
		-- upvalues: React (copy), ConfigureFriendMenu (copy), v43 (copy)
		return React.createElement(ConfigureFriendMenu, {
			initiateConfirmation = v43
		})
	end, {})
	local v45 = React.useMemo(function() -- line: 129
		-- upvalues: withStyle (copy), Roact (copy), InteractiveAlert (copy), v38 (copy), v33 (copy), ButtonType (copy), v30 (copy), CloseCFM (copy), v35 (copy), FriendAction (copy), v40 (copy), v42 (copy), v36 (copy)
		return withStyle(function(_) -- line: 130
			-- upvalues: Roact (copy), InteractiveAlert (copy), v38 (copy), v33 (copy), ButtonType (copy), v30 (copy), CloseCFM (copy), v35 (copy), FriendAction (copy), v40 (copy), v42 (copy), v36 (copy)
			return Roact.createElement(InteractiveAlert, {
				title = v38,
				bodyText = v33.confirmationDescription,
				buttonStackInfo = {
					buttons = {
						{
							buttonType = ButtonType.Secondary,
							props = {
								text = v33.cancelAction,
								onActivated = function() -- line: 140
									-- upvalues: v30 (copy), CloseCFM (copy), v35 (copy), FriendAction (copy)
									v30(CloseCFM())
									v35(FriendAction.NoAction)
								end
							}
						},
						{
							buttonType = ButtonType.Alert,
							props = {
								text = v40,
								onActivated = function() -- line: 150
									-- upvalues: v42 (copy), v30 (copy), CloseCFM (copy), v35 (copy), FriendAction (copy)
									v42()
									v30(CloseCFM())
									v35(FriendAction.NoAction)
								end
							}
						}
					}
				},
				screenSize = v36
			})
		end)
	end, {
		v38,
		v40,
		v34,
		v32.combinedName,
		v32.userName,
		v33.cancelAction,
		v33.confirmationDescription
	})

	return React.createElement(Roact.Portal, {
		target = CoreGui
	}, {
		PlayerMenuScreen = React.createElement("ScreenGui", {
			Enabled = v31,
			IgnoreGuiInset = true,
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
			DisplayOrder = 8,
			[React.Change.AbsoluteSize] = function(p7) -- line: 180
				-- upvalues: v37 (copy)
				v37(p7.AbsoluteSize)
			end
		}, {
			Overlay = React.createElement("TextButton", {
				AutoButtonColor = false,
				BackgroundColor3 = Theme.Overlay.Color,
				BackgroundTransparency = Theme.Overlay.Transparency,
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 1, 0),
				Text = "",
				[React.Event.Activated] = function() -- line: 191
					-- upvalues: v30 (copy), CloseCFM (copy), v35 (copy), FriendAction (copy)
					v30(CloseCFM())
					v35(FriendAction.NoAction)
				end
			}),
			PlayerMenu = if v34 ~= FriendAction.NoAction then v45 else v44
		})
	})
end

return PlayerMenuContainer
