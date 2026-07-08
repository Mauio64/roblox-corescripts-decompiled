local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local ParentParent = script.Parent.Parent.Parent

if require(ParentParent.Flags.FFlagTopBarDeprecateChatRodux) then
	return nil
end

local UpdateChatVisible = require(ParentParent.Actions.UpdateChatVisible)
local UpdateChatMessages = require(ParentParent.Actions.UpdateChatMessages)
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local ChatSelector = require(RobloxGui.Modules.ChatSelector)
local GameSettings = UserSettings().GameSettings
local v12 = Roact.PureComponent:extend("ChatConnector")

v12.validateProps = t.strictInterface({
	isSmallTouchScreen = t.boolean,
	updateChatVisible = t.callback,
	updateChatMessages = t.callback
})

function v12.didMount(p1) -- line: 35
	-- upvalues: GameSettings (copy), ChatSelector (copy)
	local ChatVisible = GameSettings.ChatVisible

	if p1.props.isSmallTouchScreen then
		ChatVisible = false
	end

	ChatSelector:SetVisible(ChatVisible)
	p1.props.updateChatMessages(ChatSelector:GetMessageCount())
	p1.props.updateChatVisible(ChatSelector:GetVisibility())
	p1.chatVisibleConnection = ChatSelector.VisibilityStateChanged:connect(function(p2) -- line: 45
		-- upvalues: p1 (copy)
		p1.props.updateChatVisible(p2)
	end)
	p1.chatMessagesConnection = ChatSelector.MessagesChanged:connect(function(p3) -- line: 49
		-- upvalues: p1 (copy)
		p1.props.updateChatMessages(p3)
	end)
end
function v12.render(_) -- line: 54
	return nil
end
function v12.willUnmount(p5) -- line: 58
	p5.chatVisibleConnection:disconnect()
	p5.chatMessagesConnection:disconnect()
end

local function mapStateToProps(p6) -- line: 63
	return {
		isSmallTouchScreen = p6.displayOptions.isSmallTouchDevice
	}
end
local function mapDispatchToProps(p7) -- line: 69
	-- upvalues: UpdateChatVisible (copy), UpdateChatMessages (copy)
	return {
		updateChatVisible = function(p8) -- line: 71
			-- upvalues: p7 (copy), UpdateChatVisible (copy)
			return p7(UpdateChatVisible(p8))
		end,
		updateChatMessages = function(p9) -- line: 75
			-- upvalues: p7 (copy), UpdateChatMessages (copy)
			return p7(UpdateChatMessages(p9))
		end
	}
end

return RoactRodux.UNSTABLE_connect2(mapStateToProps, mapDispatchToProps)(v12)
