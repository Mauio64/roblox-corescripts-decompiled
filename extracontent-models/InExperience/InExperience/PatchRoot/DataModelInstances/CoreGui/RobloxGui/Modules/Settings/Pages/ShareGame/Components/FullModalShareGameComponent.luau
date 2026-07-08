local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local useStyleSheet = require(CorePackages.Packages.Foundation).Hooks.useStyleSheet
local Modules = CoreGui.RobloxGui.Modules
local scriptParent = script.Parent
local GetFFlagExtraInviteModalStringValidation = require(Modules.Flags.GetFFlagExtraInviteModalStringValidation)
local FFlagFixPromptGameInviteUIButtonScaling = require(Modules.Flags.FFlagFixPromptGameInviteUIButtonScaling)
local ShareGameContainer = require(scriptParent.ShareGameContainer)
local ModalShareGamePageFrame = require(scriptParent.ModalShareGamePageFrame)
local LayoutProvider = require(scriptParent.LayoutProvider)
local InviteSingleUserContainer = require(scriptParent.InviteSingleUserContainer)
local LoadingModal = require(scriptParent.LoadingModal)

local function FoundationStyleLink() -- line: 22
	-- upvalues: useStyleSheet (copy), Roact (copy)
	local v17 = useStyleSheet()

	return Roact.createElement("StyleLink", {
		StyleSheet = v17
	})
end

local v16 = Roact.PureComponent:extend("FullModalShareGameComponent")

function v16.render(p1) -- line: 31
	-- upvalues: GetFFlagExtraInviteModalStringValidation (copy), Roact (copy), RoactRodux (copy), FFlagFixPromptGameInviteUIButtonScaling (copy), FoundationStyleLink (copy), LoadingModal (copy), LayoutProvider (copy), ShareGameContainer (copy), InviteSingleUserContainer (copy), ModalShareGamePageFrame (copy)
	local isVisible = p1.props.isVisible
	local analytics = p1.props.analytics
	local onAfterClosePage = p1.props.onAfterClosePage
	local store = p1.props.store
	local promptMessage = p1.props.promptMessage
	local inviteUserId = p1.props.inviteUserId
	local inviteMessageId = p1.props.inviteMessageId
	local launchData = p1.props.launchData
	local isLoading = p1.props.isLoading

	if GetFFlagExtraInviteModalStringValidation() and promptMessage then
		if not inviteUserId then
			promptMessage = promptMessage:gsub("\n", " ")
		end

		if promptMessage:gsub("%s", "") == "" then
			promptMessage = nil
		end
	end

	return Roact.createElement(RoactRodux.StoreProvider, {
		store = store
	}, {
		screenGui = Roact.createElement("ScreenGui", {
			AutoLocalize = false,
			DisplayOrder = -1,
			Enabled = isVisible,
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		}, {
			foundationStyleLink = if not FFlagFixPromptGameInviteUIButtonScaling then nil else Roact.createElement(FoundationStyleLink),
			loadingIndicator = isLoading and Roact.createElement(LoadingModal),
			layoutProvider = not isLoading and Roact.createElement(LayoutProvider, nil, {
				ShareGameContainer = Roact.createElement(ShareGameContainer, {
					analytics = analytics,
					isVisible = isVisible,
					skeletonComponent = if not inviteUserId then ModalShareGamePageFrame else InviteSingleUserContainer,
					promptMessage = promptMessage,
					inviteUserId = inviteUserId,
					inviteMessageId = inviteMessageId,
					launchData = launchData,
					onAfterClosePage = function() -- line: 74
						-- upvalues: store (copy), onAfterClosePage (copy)
						local t1 = {}

						for k, _ in pairs(store:getState().Invites) do
							table.insert(t1, k)
						end

						onAfterClosePage(t1)
					end
				})
			})
		})
	})
end

return v16
