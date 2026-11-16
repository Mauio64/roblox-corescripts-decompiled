local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local Foundation = require(CorePackages.Packages.Foundation)

local useStyleSheet = Foundation.Hooks.useStyleSheet

local Modules = CoreGui.RobloxGui.Modules
local parent = script.Parent

local GetFFlagExtraInviteModalStringValidation = require(Modules.Flags.GetFFlagExtraInviteModalStringValidation)
local FFlagFixPromptGameInviteUIButtonScaling = require(Modules.Flags.FFlagFixPromptGameInviteUIButtonScaling)

local ShareGameContainer = require(parent.ShareGameContainer)
local ModalShareGamePageFrame = require(parent.ModalShareGamePageFrame)
local LayoutProvider = require(parent.LayoutProvider)
local InviteSingleUserContainer = require(parent.InviteSingleUserContainer)
local LoadingModal = require(parent.LoadingModal)

local function FoundationStyleLink()
	local styleSheet = useStyleSheet()
	return Roact.createElement("StyleLink", { StyleSheet = styleSheet })
end

local extended = Roact.PureComponent:extend("FullModalShareGameComponent")

function extended.render(p)
	local isVisible = p.props.isVisible
	local analytics = p.props.analytics
	local onAfterClosePage = p.props.onAfterClosePage
	local store = p.props.store
	local promptMessage = p.props.promptMessage
	local inviteUserId = p.props.inviteUserId
	local inviteMessageId = p.props.inviteMessageId
	local launchData = p.props.launchData
	local isLoading = p.props.isLoading
	local requestImpl = p.props.requestImpl

	if GetFFlagExtraInviteModalStringValidation() and promptMessage then
		if not inviteUserId then
			promptMessage = promptMessage:gsub("\n", " ")
		end

		if promptMessage:gsub("%s", "") == "" then
			promptMessage = nil
		end
	end

	local createElement = Roact.createElement
	local storeProvider = RoactRodux.StoreProvider

	local createElement2 = Roact.createElement
	local v = {
		AutoLocalize = false,
		Enabled = isVisible,
		DisplayOrder = -1,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	}
	local foundationStyleLink

	if FFlagFixPromptGameInviteUIButtonScaling then
		foundationStyleLink = Roact.createElement(FoundationStyleLink)
	end

	local v2 = {
		foundationStyleLink = foundationStyleLink,
		loadingIndicator = isLoading and Roact.createElement(LoadingModal),
		layoutProvider = 0
	}
	local layoutProvider = not isLoading

	if layoutProvider then
		local createElement3 = Roact.createElement
		local createElement4 = Roact.createElement
		local skeletonComponent

		if inviteUserId then
			skeletonComponent = InviteSingleUserContainer
		else
			skeletonComponent = ModalShareGamePageFrame
		end

		layoutProvider = createElement3(LayoutProvider, nil, {
			ShareGameContainer = createElement4(ShareGameContainer, {
				analytics = analytics,
				isVisible = isVisible,
				skeletonComponent = skeletonComponent,
				promptMessage = promptMessage,
				inviteUserId = inviteUserId,
				inviteMessageId = inviteMessageId,
				launchData = launchData,
				requestImpl = requestImpl,
				onAfterClosePage = function()
					local v3 = {}

					for k, _ in pairs(store:getState().Invites) do
						table.insert(v3, k)
					end

					onAfterClosePage(v3)
				end
			})
		})
	end

	v2.layoutProvider = layoutProvider
	return createElement(storeProvider, { store = store }, {
		screenGui = createElement2("ScreenGui", v, v2)
	})
end

return extended
