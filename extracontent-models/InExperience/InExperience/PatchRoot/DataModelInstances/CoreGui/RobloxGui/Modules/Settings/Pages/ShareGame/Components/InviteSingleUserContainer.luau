local ContextActionService = game:GetService("ContextActionService")
local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Players = game:GetService("Players")
local HttpRbxApiService = game:GetService("HttpRbxApiService")
local React = require(CorePackages.Packages.React)
local RoactRodux = require(CorePackages.Packages.RoactRodux)

local Modules = CoreGui.RobloxGui.Modules
local renderWithCoreScriptsStyleProvider = require(Modules.Common.renderWithCoreScriptsStyleProvider)
local ShareGame = Modules.Settings.Pages.ShareGame
local CoreScriptsCommon = require(CorePackages.Workspace.Packages.CoreScriptsCommon)
local colors = CoreScriptsCommon.Constants.COLORS
local Constants = require(ShareGame.Constants)
local GameInvite = require(CorePackages.Workspace.Packages.GameInvite)
local GameInviteEvents = GameInvite.GameInviteEvents
local InviteStatus = Constants.InviteStatus
local getTranslator = require(ShareGame.getTranslator)
local translator = getTranslator()

local httpRequest = require(Modules.Common.httpRequest)

local InviteUserIdToPlaceId = require(ShareGame.Thunks.InviteUserIdToPlaceId)
local Http = require(CorePackages.Workspace.Packages.Http)
local RetrievalStatus = Http.Enum.RetrievalStatus
local InviteUserIdToPlaceIdCustomized = require(ShareGame.Thunks.InviteUserIdToPlaceIdCustomized)
local ThrottleFunctionCall = require(ShareGame.ThrottleFunctionCall)

local SingleUserThumbnail = require(ShareGame.Components.SingleUserThumbnail)

local Signals = require(CorePackages.Packages.Signals)
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local UserProfiles = require(CorePackages.Workspace.Packages.UserProfiles)
local UserProfileStore = UserProfiles.Stores.UserProfileStore

local LoadingModal = require(ShareGame.Components.LoadingModal)

local GetFFlagAbuseReportAnalyticsHasLaunchData = require(Modules.Settings.Flags.GetFFlagAbuseReportAnalyticsHasLaunchData)
local GetFFlagEnableNewInviteSendEndpoint = require(Modules.Flags.GetFFlagEnableNewInviteSendEndpoint)

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagFixPromptGameInviteUIMissingDisplayName = SharedFlags.FFlagFixPromptGameInviteUIMissingDisplayName
local GetFFlagThrottleInviteSendEndpoint = require(Modules.Flags.GetFFlagThrottleInviteSendEndpoint)
local GetFIntThrottleInviteSendEndpointDelay = require(Modules.Flags.GetFIntThrottleInviteSendEndpointDelay)
local GetFFlagSingleUserInvitePageKeybind = require(Modules.Settings.Flags.GetFFlagSingleUserInvitePageKeybind)

local UIBlox = require(CorePackages.Packages.UIBlox)
local Button = UIBlox.App.Button.Button
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel

local useStyle = UIBlox.Core.Style.useStyle

local color = Color3.fromRGB(41, 41, 41)

local function fn(props)
	local friend = props.friends[tostring(props.inviteUserId)]
	local v = friend and props.invites[friend.id]

	local v2 = useStyle()
	local state, setState = React.useState(false)
	local v3

	if FFlagFixPromptGameInviteUIMissingDisplayName then
		v3 = React.useMemo(function()
			return UserProfileStore.get().fetchNamesByUserIds({ (tostring(props.inviteUserId)) })
		end, { props.inviteUserId })
	else
		v3 = nil
	end

	local v4

	if FFlagFixPromptGameInviteUIMissingDisplayName then
		v4 = React.useMemo(function()
			return Signals.createComputed(function(p)
				local v5 = v3(p)
				local v6 = v5 and v5.data and v5.data[1]
				local names = v6 and v6.names
				local name

				if names then
					name = names.getCombinedName(p)

					if name == "" then
						name = names.getUsername(p)
					end
				else
					name = ""
				end

				return {
					name = name,
					isFetching = v5 == nil or v5.status == "fetching"
				}
			end)
		end, { v3 })
	end

	local v5

	if FFlagFixPromptGameInviteUIMissingDisplayName then
		v5 = SignalsReact.useSignalState(v4)
	end

	React.useEffect(function()
		if props.promptMessage and props.analytics then
			props.analytics:sendEvent(Constants.Triggers.DeveloperSingle, GameInviteEvents.CustomTextShown)
		end
	end, {})

	local v6 = React.useCallback(function()
		props.closePage()

		if props.onAfterClosePage then
			props.onAfterClosePage()
		end
	end, { props.closePage, props.onAfterClosePage })

	local onActivated = React.useCallback(function()
		props.analytics:sendEvent(Constants.Triggers.DeveloperSingle, GameInviteEvents.CancelInvite)
		v6()
	end, { v6 })

	local onActivated2 = React.useCallback(function()
		setState(true)
		local inviteUser = props.inviteUser
		local analytics = props.analytics

		if v and v ~= InviteStatus.Failed then
			return
		end

		local isLaunchDataProvided

		if props.launchData == nil then
			isLaunchDataProvided = false
		else
			isLaunchDataProvided = props.launchData ~= ""
		end

		local developerSingle = Constants.Triggers.DeveloperSingle
		local sendInvite = GameInviteEvents.SendInvite
		local v7 = { recipient = friend.id, isLaunchDataProvided = 0 }

		if not GetFFlagAbuseReportAnalyticsHasLaunchData() then
			isLaunchDataProvided = nil
		end

		v7.isLaunchDataProvided = isLaunchDataProvided
		analytics:sendEvent(developerSingle, sendInvite, v7)

		local function fn2(p)
			setState(false)

			if not p then
				return
			end

			local v8 = { friend.id }

			if Players.LocalPlayer and p.conversationId then
				analytics:onActivatedInviteSent(Players.LocalPlayer.UserId, p.conversationId, v8)
			end

			v6()
		end

		inviteUser(tostring(friend.id), analytics, props.inviteMessageId, props.launchData):andThen(fn2, v6)
	end, {
		props.inviteUser,
		props.inviteMessageId,
		props.launchData,
		props.analytics,
		setState,
		v,
		friend,
		v6
	})

	if GetFFlagSingleUserInvitePageKeybind() then
		React.useEffect(function()
			if not props.isVisible then
				return nil
			end

			ContextActionService:BindCoreAction("ProductPurchaseConfirmButtonBind", function(_, p, _)
				if p == Enum.UserInputState.Begin then
					onActivated2()
				end
			end, false, Enum.KeyCode.ButtonA)
			ContextActionService:BindCoreAction("ProductPurchaseCancelButtonBind", function(_, p, _)
				if p == Enum.UserInputState.Begin then
					onActivated()
				end
			end, false, Enum.KeyCode.ButtonB)
			return function()
				ContextActionService:UnbindCoreAction("ProductPurchaseConfirmButtonBind")
				ContextActionService:UnbindCoreAction("ProductPurchaseCancelButtonBind")
			end
		end, { props.isVisible, onActivated2, onActivated })
	end

	if GetFFlagThrottleInviteSendEndpoint() then
		onActivated2 = React.useCallback(ThrottleFunctionCall(GetFIntThrottleInviteSendEndpointDelay(), onActivated2), {
			onActivated2
		})
	end

	if friend then
		if FFlagFixPromptGameInviteUIMissingDisplayName and v5.name == "" and v5.isFetching then
			return React.createElement(LoadingModal)
		end

		local displayName

		if FFlagFixPromptGameInviteUIMissingDisplayName then
			if v5.name == "" then
				displayName = friend.displayName or ""
			else
				displayName = v5.name
			end
		else
			displayName = friend.displayName
		end

		local isDisabled = v and v ~= InviteStatus.Failed

		return React.createElement("Frame", {
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			BorderSizePixel = 0,
			BackgroundColor3 = color,
			BackgroundTransparency = 0.1
		}, {
			SizeConstraint = React.createElement("UISizeConstraint", {
				MaxSize = Vector2.new(442, 1e999),
				MinSize = Vector2.new(0, 0)
			}),
			Corner = React.createElement("UICorner", { CornerRadius = UDim.new(0, 8) }),
			Padding = React.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, 24),
				PaddingRight = UDim.new(0, 24),
				PaddingBottom = UDim.new(0, 24)
			}),
			Header = React.createElement(StyledTextLabel, {
				fontStyle = v2.Font.Header1,
				colorStyle = v2.Theme.TextEmphasis,
				text = translator:FormatByKey("Feature.SettingsHub.Heading.InviteUser", {
					DisplayName = displayName
				}),
				size = UDim2.new(1, 0, 0, 48),
				textXAlignment = Enum.TextXAlignment.Center
			}),
			Divider = React.createElement("Frame", {
				Position = UDim2.new(0, 0, 0, 48),
				Size = UDim2.new(1, 0, 0, 1),
				BorderSizePixel = 0,
				BackgroundColor3 = colors.GRAPHITE
			}),
			Wrapper = React.createElement(
				"Frame",
				{
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					Position = UDim2.new(0, 0, 0, 56),
					BackgroundTransparency = 1
				},
				{
					ListLayout = React.createElement("UIListLayout", {
						SortOrder = Enum.SortOrder.LayoutOrder,
						FillDirection = Enum.FillDirection.Vertical,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						Padding = UDim.new(0, 24)
					}),
					Thumbnail = React.createElement(SingleUserThumbnail, {
						user = friend,
						size = UDim2.new(0, 95, 0, 95),
						layoutOrder = 1,
						square = true,
						backgroundTransparency = 1
					}),
					TextBody = React.createElement(StyledTextLabel, {
						fontStyle = v2.Font.Header2,
						colorStyle = v2.Theme.TextEmphasis,
						text = props.promptMessage or translator:FormatByKey(
							"Feature.SettingsHub.Label.DefaultInviteMessage",
							{ DisplayName = displayName }
						),
						textXAlignment = Enum.TextXAlignment.Center,
						automaticSize = Enum.AutomaticSize.Y,
						size = UDim2.new(1, 0, 0, 0),
						layoutOrder = 2
					}),
					ButtonWrapper = React.createElement(
						"Frame",
						{
							Size = UDim2.new(1, 0, 0, 48),
							LayoutOrder = 3,
							BackgroundTransparency = 1
						},
						{
							CancelButton = React.createElement(Button, {
								buttonType = ButtonType.Secondary,
								size = UDim2.new(0.5, -12, 1, 0),
								text = translator:FormatByKey("Feature.SettingsHub.Action.Cancel"),
								onActivated = onActivated,
								isDisabled = state
							}),
							InviteButton = React.createElement(Button, {
								buttonType = ButtonType.PrimarySystem,
								size = UDim2.new(0.5, -12, 1, 0),
								position = UDim2.new(0.5, 12, 0, 0),
								text = translator:FormatByKey(isDisabled and "Feature.SettingsHub.Label.Invited" or "Feature.SettingsHub.Action.InviteFriend"),
								onActivated = onActivated2,
								isLoading = state,
								isDisabled = isDisabled
							})
						}
					)
				}
			)
		})
	elseif
		props.friendsRetrievalStatus == RetrievalStatus.Done
		or props.friendsRetrievalStatus == RetrievalStatus.Failed
	then
		v6()
	end
end

return RoactRodux.connect(function(data)
	return {
		friends = data.Users,
		friendsRetrievalStatus = Players.LocalPlayer and data.Friends.retrievalStatus[tostring(Players.LocalPlayer.UserId)],
		invites = data.Invites
	}
end, function(callback)
	return {
		inviteUser = function(p: string, p2, p3: string?, p4: string?)
			local v = httpRequest(HttpRbxApiService)
			local placeId = tostring(game.PlaceId)

			if GetFFlagEnableNewInviteSendEndpoint() then
				return callback(InviteUserIdToPlaceIdCustomized(
					v,
					p,
					placeId,
					p2,
					Constants.Triggers.DeveloperSingle,
					p3,
					p4
				))
			end

			return callback(InviteUserIdToPlaceId(v, p, placeId))
		end
	}
end)(function(p)
	return renderWithCoreScriptsStyleProvider({ SingleUserInvite = React.createElement(fn, p) })
end)
