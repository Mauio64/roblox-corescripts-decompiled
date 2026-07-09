local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local withLocalization = require(Modules.LuaApp.withLocalization)
local dependencies = require(script:FindFirstAncestor("ShareTargetGame").dependencies)
local compose = dependencies.SocialLibraries.RoduxTools.compose
local UniversalAppPolicy = dependencies.UniversalAppPolicy
local ShareTargetGame = require(script.Parent.ShareTargetGame)
local ShareTargetGameTopBar = require(script.Parent.ShareTargetGameTopBar)
local v13 = Roact.PureComponent:extend("ShareTargetGameContainer")
local mapStateToProps = require(script.Parent.Parent.mapStateToProps)
local mapDispatchToProps = require(script.Parent.Parent.mapDispatchToProps)
local keepConversationOrderSame = require(script.Parent.Parent.Utils.keepConversationOrderSame)

v13.defaultProps = {
	analytics = nil,
	networkImpl = nil
}

function v13.init(p1) -- line: 29
	function p1.hasAllInformation() -- line: 30
		-- upvalues: p1 (copy)
		if p1.props.appLoaded and (p1.props.placeInfo and p1.props.gameCreator and p1.props.gameThumbnail) then
			return true
		end

		return false
	end

	p1.state = {
		conversationSendingStatuses = {}
	}
end
function v13.getDerivedStateFromProps(p2, p3) -- line: 41
	-- upvalues: keepConversationOrderSame (copy)
	return {
		formattedConversations = keepConversationOrderSame(p2.conversations, p3.formattedConversations)
	}
end
function getChatRecipient(p4, p5) -- line: 47
	for _, v23 in p4 do
		if v23 ~= p5 then
			return v23
		end
	end

	return nil
end
function v13.render(p6) -- line: 57
	-- upvalues: UIBlox (copy), Cryo (copy), Roact (copy), ShareTargetGameTopBar (copy), ShareTargetGame (copy), withLocalization (copy)
	return UIBlox.Style.withStyle(function(p7) -- line: 58
		-- upvalues: p6 (copy), Cryo (copy), Roact (copy), ShareTargetGameTopBar (copy), ShareTargetGame (copy), withLocalization (copy)
		local function renderFrame(p8) -- line: 59
			-- upvalues: p6 (copy), Cryo (copy), Roact (copy), p7 (copy), ShareTargetGameTopBar (copy), ShareTargetGame (copy)
			return Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, 0)
			}, {
				layout = Roact.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder
				}),
				shareTargetGame = Roact.createElement("Frame", {
					BackgroundTransparency = 0,
					BorderSizePixel = 0,
					Size = UDim2.new(1, 0, 1, 0),
					BackgroundColor3 = p7.Theme.BackgroundDefault.Color
				}, {
					layout = Roact.createElement("UIListLayout", {
						VerticalAlignment = Enum.VerticalAlignment.Top,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						SortOrder = Enum.SortOrder.LayoutOrder
					}),
					topBar = Roact.createElement(ShareTargetGameTopBar, {
						LayoutOrder = 1
					}),
					content = Roact.createElement(ShareTargetGame, Cryo.Dictionary.join(p6.props, p8, {
						LayoutOrder = 2,
						onSendButtonActivated = function(p9) -- line: 60
							-- upvalues: p6 (copy), Cryo (copy)
							p6:setState({
								conversationSendingStatuses = Cryo.Dictionary.join(p6.state.conversationSendingStatuses, {
									[p9.conversationId] = "sending"
								})
							})

							return p6.props.sendGameLinkToConversation(p9.conversationId, tostring(p6.props.placeInfo.universeId), true, (if not game:DefineFastFlag("ExperienceInviteNotification", false) then nil else getChatRecipient(p9.participants, p6.props.senderId)), p6.props.placeInfo.universeRootPlaceId):andThen(function() -- line: 77
								-- upvalues: p6 (copy), p9 (copy), Cryo (copy)
								p6.props.analytics:onActivatedInviteSent(tostring(p6.props.placeInfo.universeRootPlaceId), tostring(p6.props.placeInfo.universeId), tostring(p6.props.senderId), p9.conversationId, p9.participants)
								p6:setState({
									conversationSendingStatuses = Cryo.Dictionary.join(p6.state.conversationSendingStatuses, {
										[p9.conversationId] = "sent"
									})
								})
							end, function() -- line: 91
								-- upvalues: p6 (copy), Cryo (copy), p9 (copy)
								p6:setState({
									conversationSendingStatuses = Cryo.Dictionary.join(p6.state.conversationSendingStatuses, {
										[p9.conversationId] = "failed"
									})
								})
							end)
						end,
						formattedConversations = p6.state.formattedConversations,
						conversationSendingStatuses = p6.state.conversationSendingStatuses,
						isLoading = not p6.hasAllInformation()
					}))
				})
			})
		end

		return withLocalization({
			filterBoxPlaceHolderText = "Feature.Chat.Label.SearchForFriendsAndChat",
			sentText = "Feature.Chat.Label.Sent",
			sendText = "Feature.Chat.Action.Send",
			sendingText = "Feature.Chat.Response.Sending",
			failedText = "Feature.Chat.Response.Failed",
			offlinePresence = "Common.Presence.Label.Offline",
			onlinePresence = "Common.Presence.Label.Online",
			byBuilderText = {
				"Feature.Chat.Label.ByBuilder",
				USERNAME = p6.props.gameCreator
			}
		})(function(p10) -- line: 149
			-- upvalues: renderFrame (copy)
			return renderFrame(p10)
		end)
	end)
end
function v13.didMount(p11) -- line: 155
	if not p11.props.placeInfo.universeId then
		p11.props.fetchPlaceInfos(p11.props.networkImpl, p11.props.placeId)
	else
		p11.props.fetchGameData(p11.props.networkImpl, p11.props.placeInfo.universeId)
	end

	if not p11.props.appLoaded then
		spawn(function() -- line: 164
			-- upvalues: p11 (copy)
			p11.props.fetchConversations(1):andThen(function() -- line: 165
				-- upvalues: p11 (copy)
				p11.props.setAppLoaded()
			end)
		end)
	end

	p11.props.analytics:inputShareGameEntryPoint(p11.props.placeId, p11.props.placeInfo.universeId)
end

return compose(RoactRodux.connect(mapStateToProps, mapDispatchToProps), UniversalAppPolicy.connect(function(p12) -- line: 176
	return {
		shouldShowCreatorName = p12.shouldShowCreatorName()
	}
end))(v13)
