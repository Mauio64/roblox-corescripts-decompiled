local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)

local parent = script.Parent.Parent.Parent

local FFlagTopBarDeprecateChatRodux = require(parent.Flags.FFlagTopBarDeprecateChatRodux)

if FFlagTopBarDeprecateChatRodux then
	return nil
end

local UpdateChatVisible = require(parent.Actions.UpdateChatVisible)
local UpdateChatMessages = require(parent.Actions.UpdateChatMessages)

local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local ChatSelector = require(RobloxGui.Modules.ChatSelector)

local gameSettings = UserSettings().GameSettings

local extended = Roact.PureComponent:extend("ChatConnector")

extended.validateProps = t.strictInterface({
	isSmallTouchScreen = t.boolean,
	updateChatVisible = t.callback,
	updateChatMessages = t.callback
})

function extended:didMount()
	local v = gameSettings.ChatVisible

	if self.props.isSmallTouchScreen then
		v = false
	end

	ChatSelector:SetVisible(v)

	self.props.updateChatMessages(ChatSelector:GetMessageCount())
	self.props.updateChatVisible(ChatSelector:GetVisibility())

	self.chatVisibleConnection = ChatSelector.VisibilityStateChanged:connect(function(p)
		self.props.updateChatVisible(p)
	end)

	self.chatMessagesConnection = ChatSelector.MessagesChanged:connect(function(p)
		self.props.updateChatMessages(p)
	end)
end

function extended.render(_): nil
	return nil
end

function extended.willUnmount(p)
	p.chatVisibleConnection:disconnect()
	p.chatMessagesConnection:disconnect()
end

local function mapStateToProps(p)
	return { isSmallTouchScreen = p.displayOptions.isSmallTouchDevice }
end

local function mapDispatchToProps(callback)
	return {
		updateChatVisible = function(p)
			return callback(UpdateChatVisible(p))
		end,
		updateChatMessages = function(p)
			return callback(UpdateChatMessages(p))
		end
	}
end

return RoactRodux.UNSTABLE_connect2(mapStateToProps, mapDispatchToProps)(extended)
