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
local COLORS = require(CorePackages.Workspace.Packages.CoreScriptsCommon).Constants.COLORS
local Constants = require(ShareGame.Constants)
local GameInviteEvents = require(CorePackages.Workspace.Packages.GameInvite).GameInviteEvents
local InviteStatus = Constants.InviteStatus
local v15 = require(ShareGame.getTranslator)()
local httpRequest = require(Modules.Common.httpRequest)
local InviteUserIdToPlaceId = require(ShareGame.Thunks.InviteUserIdToPlaceId)
local RetrievalStatus = require(CorePackages.Workspace.Packages.Http).Enum.RetrievalStatus
local InviteUserIdToPlaceIdCustomized = require(ShareGame.Thunks.InviteUserIdToPlaceIdCustomized)
local ThrottleFunctionCall = require(ShareGame.ThrottleFunctionCall)
local SingleUserThumbnail = require(ShareGame.Components.SingleUserThumbnail)
local GetFFlagAbuseReportAnalyticsHasLaunchData = require(Modules.Settings.Flags.GetFFlagAbuseReportAnalyticsHasLaunchData)
local GetFFlagEnableNewInviteSendEndpoint = require(Modules.Flags.GetFFlagEnableNewInviteSendEndpoint)
local GetFFlagThrottleInviteSendEndpoint = require(Modules.Flags.GetFFlagThrottleInviteSendEndpoint)
local GetFIntThrottleInviteSendEndpointDelay = require(Modules.Flags.GetFIntThrottleInviteSendEndpointDelay)
local GetFFlagSingleUserInvitePageKeybind = require(Modules.Settings.Flags.GetFFlagSingleUserInvitePageKeybind)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Button = UIBlox.App.Button.Button
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local useStyle = UIBlox.Core.Style.useStyle
local color3 = Color3.fromRGB(41, 41, 41)

local function v33(p1) -- line: 52
	-- upvalues: useStyle (copy), React (copy), Constants (copy), GameInviteEvents (copy), InviteStatus (copy), GetFFlagAbuseReportAnalyticsHasLaunchData (copy), Players (copy), GetFFlagSingleUserInvitePageKeybind (copy), ContextActionService (copy), GetFFlagThrottleInviteSendEndpoint (copy), ThrottleFunctionCall (copy), GetFIntThrottleInviteSendEndpointDelay (copy), RetrievalStatus (copy), color3 (copy), StyledTextLabel (copy), v15 (copy), COLORS (copy), SingleUserThumbnail (copy), Button (copy), ButtonType (copy)
	local v35 = p1.friends[tostring(p1.inviteUserId)]
	local v36 = v35 and p1.invites[v35.id]
	local v37 = useStyle()
	local v38, v39 = React.useState(false)

	React.useEffect(function() -- line: 59
		-- upvalues: p1 (copy), Constants (copy), GameInviteEvents (copy)
		if p1.promptMessage and p1.analytics then
			p1.analytics:sendEvent(Constants.Triggers.DeveloperSingle, GameInviteEvents.CustomTextShown)
		end
	end, {})

	local v40 = React.useCallback(function() -- line: 66
		-- upvalues: p1 (copy)
		p1.closePage()

		if p1.onAfterClosePage then
			p1.onAfterClosePage()
		end
	end, {
		p1.closePage,
		p1.onAfterClosePage
	})
	local v41 = React.useCallback(function() -- line: 78
		-- upvalues: p1 (copy), Constants (copy), GameInviteEvents (copy), v40 (copy)
		p1.analytics:sendEvent(Constants.Triggers.DeveloperSingle, GameInviteEvents.CancelInvite)
		v40()
	end, { v40 })
	local u42 = React.useCallback(function() -- line: 86
		-- upvalues: v39 (copy), p1 (copy), v36 (copy), InviteStatus (copy), Constants (copy), GameInviteEvents (copy), v35 (copy), GetFFlagAbuseReportAnalyticsHasLaunchData (copy), Players (copy), v40 (copy)
		v39(true)

		local inviteUser = p1.inviteUser
		local analytics = p1.analytics

		if v36 and v36 ~= InviteStatus.Failed then
			return
		end

		local v50 = p1.launchData ~= nil and p1.launchData ~= ""

		analytics:sendEvent(Constants.Triggers.DeveloperSingle, GameInviteEvents.SendInvite, {
			recipient = v35.id,
			isLaunchDataProvided = if not GetFFlagAbuseReportAnalyticsHasLaunchData() then nil else v50
		})
		inviteUser(tostring(v35.id), analytics, p1.inviteMessageId, p1.launchData):andThen(function(p2) -- line: 102
			-- upvalues: v39 (copy), v35 (copy), Players (copy), analytics (copy), v40 (copy)
			v39(false)

			if not p2 then
				return
			end

			local t1 = { v35.id }

			if Players.LocalPlayer and p2.conversationId then
				local LocalPlayer = Players.LocalPlayer

				analytics:onActivatedInviteSent(LocalPlayer.UserId, p2.conversationId, t1)
			end

			v40()
		end, v40)
	end, {
		p1.inviteUser,
		p1.inviteMessageId,
		p1.launchData,
		p1.analytics,
		v39,
		v36,
		v35,
		v40
	})

	if GetFFlagSingleUserInvitePageKeybind() then
		React.useEffect(function() -- line: 136
			-- upvalues: p1 (copy), ContextActionService (copy), u42 (ref), v41 (copy)
			if p1.isVisible then
				ContextActionService:BindCoreAction("ProductPurchaseConfirmButtonBind", function(_, p4, _) -- line: 138
					-- upvalues: u42 (ref)
					if p4 == Enum.UserInputState.Begin then
						u42()
					end
				end, false, Enum.KeyCode.ButtonA)
				ContextActionService:BindCoreAction("ProductPurchaseCancelButtonBind", function(_, p7, _) -- line: 143
					-- upvalues: v41 (copy)
					if p7 == Enum.UserInputState.Begin then
						v41()
					end
				end, false, Enum.KeyCode.ButtonB)

				return function() -- line: 148
					-- upvalues: ContextActionService (copy)
					ContextActionService:UnbindCoreAction("ProductPurchaseConfirmButtonBind")
					ContextActionService:UnbindCoreAction("ProductPurchaseCancelButtonBind")
				end
			end

			return nil
		end, {
			p1.isVisible,
			u42,
			v41
		})
	end

	if GetFFlagThrottleInviteSendEndpoint() then
		u42 = React.useCallback(ThrottleFunctionCall(GetFIntThrottleInviteSendEndpointDelay(), u42), { u42 })
	end

	if not v35 then
		if p1.friendsRetrievalStatus == RetrievalStatus.Done or p1.friendsRetrievalStatus == RetrievalStatus.Failed then
			v40()
		end

		return
	end

	local v43 = v36 and v36 ~= InviteStatus.Failed
	local v44 = not v43 and "Feature.SettingsHub.Action.InviteFriend" or "Feature.SettingsHub.Label.Invited"

	return React.createElement("Frame", {
		BorderSizePixel = 0,
		BackgroundTransparency = 0.1,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		Position = UDim2.new(0.5, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = color3
	}, {
		SizeConstraint = React.createElement("UISizeConstraint", {
			MaxSize = Vector2.new(442, 1e999),
			MinSize = Vector2.new(0, 0)
		}),
		Corner = React.createElement("UICorner", {
			CornerRadius = UDim.new(0, 8)
		}),
		Padding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, 24),
			PaddingRight = UDim.new(0, 24),
			PaddingBottom = UDim.new(0, 24)
		}),
		Header = React.createElement(StyledTextLabel, {
			fontStyle = v37.Font.Header1,
			colorStyle = v37.Theme.TextEmphasis,
			text = v15:FormatByKey("Feature.SettingsHub.Heading.InviteUser", {
				DisplayName = v35.displayName
			}),
			size = UDim2.new(1, 0, 0, 48),
			textXAlignment = Enum.TextXAlignment.Center
		}),
		Divider = React.createElement("Frame", {
			BorderSizePixel = 0,
			Position = UDim2.new(0, 0, 0, 48),
			Size = UDim2.new(1, 0, 0, 1),
			BackgroundColor3 = COLORS.GRAPHITE
		}),
		Wrapper = React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			Position = UDim2.new(0, 0, 0, 56)
		}, {
			ListLayout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				Padding = UDim.new(0, 24)
			}),
			Thumbnail = React.createElement(SingleUserThumbnail, {
				layoutOrder = 1,
				square = true,
				backgroundTransparency = 1,
				user = v35,
				size = UDim2.new(0, 95, 0, 95)
			}),
			TextBody = React.createElement(StyledTextLabel, {
				layoutOrder = 2,
				fontStyle = v37.Font.Header2,
				colorStyle = v37.Theme.TextEmphasis,
				text = p1.promptMessage or v15:FormatByKey("Feature.SettingsHub.Label.DefaultInviteMessage", {
					DisplayName = v35.displayName
				}),
				textXAlignment = Enum.TextXAlignment.Center,
				automaticSize = Enum.AutomaticSize.Y,
				size = UDim2.new(1, 0, 0, 0)
			}),
			ButtonWrapper = React.createElement("Frame", {
				LayoutOrder = 3,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 48)
			}, {
				CancelButton = React.createElement(Button, {
					buttonType = ButtonType.Secondary,
					size = UDim2.new(0.5, -12, 1, 0),
					text = v15:FormatByKey("Feature.SettingsHub.Action.Cancel"),
					onActivated = v41,
					isDisabled = v38
				}),
				InviteButton = React.createElement(Button, {
					buttonType = ButtonType.PrimarySystem,
					size = UDim2.new(0.5, -12, 1, 0),
					position = UDim2.new(0.5, 12, 0, 0),
					text = v15:FormatByKey(v44),
					onActivated = u42,
					isLoading = v38,
					isDisabled = v43
				})
			})
		})
	})
end

return RoactRodux.connect(function(p9) -- line: 280
	-- upvalues: Players (copy)
	return {
		friends = p9.Users,
		friendsRetrievalStatus = Players.LocalPlayer and p9.Friends.retrievalStatus[tostring(Players.LocalPlayer.UserId)],
		invites = p9.Invites
	}
end, function(p10: ((...any) -> ...any)) -- line: 287
	-- upvalues: httpRequest (copy), HttpRbxApiService (copy), GetFFlagEnableNewInviteSendEndpoint (copy), InviteUserIdToPlaceIdCustomized (copy), Constants (copy), InviteUserIdToPlaceId (copy)
	return {
		inviteUser = function(s1: string, p11, s2: string?, s3: string?) -- line: 289
			-- upvalues: httpRequest (copy), HttpRbxApiService (copy), GetFFlagEnableNewInviteSendEndpoint (copy), p10 (copy), InviteUserIdToPlaceIdCustomized (copy), Constants (copy), InviteUserIdToPlaceId (copy)
			local v55 = httpRequest(HttpRbxApiService)
			local str = tostring(game.PlaceId)

			if GetFFlagEnableNewInviteSendEndpoint() then
				return p10(InviteUserIdToPlaceIdCustomized(v55, s1, str, p11, Constants.Triggers.DeveloperSingle, s2, s3))
			end

			return p10(InviteUserIdToPlaceId(v55, s1, str))
		end
	}
end)(function(p12) -- line: 310
	-- upvalues: renderWithCoreScriptsStyleProvider (copy), React (copy), v33 (copy)
	return renderWithCoreScriptsStyleProvider({
		SingleUserInvite = React.createElement(v33, p12)
	})
end)
