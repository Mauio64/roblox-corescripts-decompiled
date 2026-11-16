local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local module = require("@luauforge/bundled/edC")
local GameHydrationReact = require("@game/CorePackages/Workspace/Packages/GameHydrationReact")

local module3 = require("@luauforge/deferred/gce")
local compose = module3.SocialLibraries.RoduxTools.compose
local universalAppPolicy = module3.UniversalAppPolicy

local module4 = require("@luauforge/deferred/gcg")
local module5 = require("@luauforge/deferred/gcY")
local extended = Roact.PureComponent:extend("ShareTargetGameContainer")

local module6 = require("@luauforge/deferred/gda")
local module7 = require("@luauforge/deferred/gdg")
local module8 = require("@luauforge/deferred/gdp")

extended.defaultProps = { analytics = nil, networkImpl = nil }

function extended:init()
	function self.hasAllInformation(): boolean
		local gameIconUrl = self.state.gameIconUrl

		if self.props.appLoaded and self.props.placeInfo and self.props.gameCreator and gameIconUrl then
			return true
		end

		return false
	end

	self.gameIconSubscription = GameHydrationReact.subscribeGameIcon({
		universeId = self.props.placeInfo and self.props.placeInfo.universeId,
		onChange = function(p2)
			self:setState({
				gameIconUrl = p2 and p2.url or ""
			})
		end
	})

	local current = self.gameIconSubscription.getCurrent()
	self.state = {
		conversationSendingStatuses = {},
		gameIconUrl = current and current.url or ""
	}
end

function extended.getDerivedStateFromProps(p2, p3)
	return {
		formattedConversations = module8(p2.conversations, p3.formattedConversations)
	}
end

function LUAUFORGE_MODULE_GLOBALS_gcf_getChatRecipient(items, p2)
	for k, item in items do
		if item ~= p2 then
			return item
		end
	end

	return nil
end

function extended.render(data)
	return UIBlox.Style.withStyle(function(p2)
		local function renderFrame(p3)
			local function onSendButtonActivated(p4)
				data:setState({
					conversationSendingStatuses = Cryo.Dictionary.join(
						data.state.conversationSendingStatuses,
						{ [p4.conversationId] = "sending" }
					)
				})

				local sendGameLinkToConversation = data.props.sendGameLinkToConversation
				local conversationId = p4.conversationId
				local universeId = tostring(data.props.placeInfo.universeId)
				local v9

				if game:DefineFastFlag("ExperienceInviteNotification", false) then
					v9 = LUAUFORGE_MODULE_GLOBALS_gcf_getChatRecipient(p4.participants, data.props.senderId)
				end

				return sendGameLinkToConversation(
					conversationId,
					universeId,
					true,
					v9,
					data.props.placeInfo.universeRootPlaceId
				):andThen(
					function()
						data.props.analytics:onActivatedInviteSent(
							tostring(data.props.placeInfo.universeRootPlaceId),
							tostring(data.props.placeInfo.universeId),
							tostring(data.props.senderId),
							p4.conversationId,
							p4.participants
						)

						data:setState({
							conversationSendingStatuses = Cryo.Dictionary.join(
								data.state.conversationSendingStatuses,
								{ [p4.conversationId] = "sent" }
							)
						})
					end,
					function()
						data:setState({
							conversationSendingStatuses = Cryo.Dictionary.join(
								data.state.conversationSendingStatuses,
								{ [p4.conversationId] = "failed" }
							)
						})
					end
				)
			end

			return Roact.createElement(
				"Frame",
				{ BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0) },
				{
					layout = Roact.createElement("UIListLayout", {
						SortOrder = Enum.SortOrder.LayoutOrder
					}),
					shareTargetGame = Roact.createElement(
						"Frame",
						{
							Size = UDim2.new(1, 0, 1, 0),
							BackgroundTransparency = 0,
							BackgroundColor3 = p2.Theme.BackgroundDefault.Color,
							BorderSizePixel = 0
						},
						{
							layout = Roact.createElement("UIListLayout", {
								VerticalAlignment = Enum.VerticalAlignment.Top,
								HorizontalAlignment = Enum.HorizontalAlignment.Center,
								SortOrder = Enum.SortOrder.LayoutOrder
							}),
							topBar = Roact.createElement(module5, { LayoutOrder = 1 }),
							content = Roact.createElement(module4, Cryo.Dictionary.join(data.props, p3, {
								onSendButtonActivated = onSendButtonActivated,
								formattedConversations = data.state.formattedConversations,
								conversationSendingStatuses = data.state.conversationSendingStatuses,
								LayoutOrder = 2,
								isLoading = not data.hasAllInformation(),
								gameThumbnail = data.state.gameIconUrl
							}))
						}
					)
				}
			)
		end

		return module({
			byBuilderText = {
				"Feature.Chat.Label.ByBuilder",
				USERNAME = data.props.gameCreator
			},
			filterBoxPlaceHolderText = "Feature.Chat.Label.SearchForFriendsAndChat",
			sentText = "Feature.Chat.Label.Sent",
			sendText = "Feature.Chat.Action.Send",
			sendingText = "Feature.Chat.Response.Sending",
			failedText = "Feature.Chat.Response.Failed",
			offlinePresence = "Common.Presence.Label.Offline",
			onlinePresence = "Common.Presence.Label.Online"
		})(function(p3)
			return renderFrame(p3)
		end)
	end)
end

function extended.didMount(p2)
	if p2.props.placeInfo.universeId then
		p2.props.fetchGameData(p2.props.networkImpl, p2.props.placeInfo.universeId)
	else
		p2.props.fetchPlaceInfos(p2.props.networkImpl, p2.props.placeId)
	end

	if not p2.props.appLoaded then
		spawn(function()
			p2.props.fetchConversations(1):andThen(function()
				p2.props.setAppLoaded()
			end)
		end)
	end

	p2.props.analytics:inputShareGameEntryPoint(p2.props.placeId, p2.props.placeInfo.universeId)
end

function extended.didUpdate(p2)
	p2.gameIconSubscription.update(p2.props.placeInfo and p2.props.placeInfo.universeId)
end

function extended:willUnmount()
	self.gameIconSubscription.dispose()
	self.gameIconSubscription = nil
end

return compose(RoactRodux.connect(module6, module7), universalAppPolicy.connect(function(p2)
	return { shouldShowCreatorName = p2.shouldShowCreatorName() }
end))(extended)
