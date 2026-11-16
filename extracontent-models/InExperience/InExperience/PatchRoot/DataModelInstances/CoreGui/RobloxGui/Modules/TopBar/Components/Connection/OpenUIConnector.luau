local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)

local parent = script.Parent.Parent.Parent

local FFlagTopBarDeprecateMoreMenuRodux = require(parent.Flags.FFlagTopBarDeprecateMoreMenuRodux)

if FFlagTopBarDeprecateMoreMenuRodux then
	return nil
end

local SetBackpackOpen = require(parent.Actions.SetBackpackOpen)
local SetEmotesOpen = require(parent.Actions.SetEmotesOpen)
local SetLeaderboardOpen = require(parent.Actions.SetLeaderboardOpen)
local SetEmotesEnabled = require(parent.Actions.SetEmotesEnabled)

local EventConnection = require(parent.Parent.Common.EventConnection)

local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagEnableNewBackpack = SharedFlags.FFlagEnableNewBackpack
local BackpackScript

if FFlagEnableNewBackpack then
	BackpackScript = nil
else
	BackpackScript = require(RobloxGui.Modules.BackpackScript)
end

local features

if FFlagEnableNewBackpack then
	local System = require(CorePackages.Workspace.Packages.System)
	features = System.Features
else
	features = nil
end

local EmotesMenuMaster = require(RobloxGui.Modules.EmotesMenu.EmotesMenuMaster)
local PlayerListManager = require(RobloxGui.Modules.PlayerList.PlayerListManager)

local extended = Roact.PureComponent:extend("OpenUIConnector")

extended.validateProps = t.strictInterface({
	setBackpackOpen = t.callback,
	setEmotesOpen = t.callback,
	setLeaderboardOpen = t.callback,
	setEmotesEnabled = t.callback
})

function extended:didMount()
	self.props.setLeaderboardOpen(PlayerListManager:GetSetVisible())

	if FFlagEnableNewBackpack then
		self.props.setBackpackOpen(features.getVisibility(features.FeatureName.Backpack))
		self.disposeBackpackListener = features.onVisibilityChanged(features.FeatureName.Backpack, function(p)
			self.props.setBackpackOpen(p)
		end)
	else
		self.props.setBackpackOpen(BackpackScript.IsOpen)
	end

	self.props.setEmotesOpen(EmotesMenuMaster:isOpen())
	self.props.setEmotesEnabled(EmotesMenuMaster.MenuIsVisible)
end

function extended:willUnmount()
	if self.disposeBackpackListener then
		self.disposeBackpackListener()
		self.disposeBackpackListener = nil
	end
end

function extended.render(p)
	local setVisibleChangedEvent = PlayerListManager:GetSetVisibleChangedEvent()

	local createFragment = Roact.createFragment
	local children = {
		LeaderboardOpenChangedConnection = Roact.createElement(EventConnection, {
			event = setVisibleChangedEvent.Event,
			callback = function(p2)
				p.props.setLeaderboardOpen(p2)
			end
		}),
		BackpackOpenChangedConnection = 0,
		EmotesOpenChangedConnection = 0,
		EmotesEnabledChangedConnection = 0
	}
	local backpackOpenChangedConnection

	if not FFlagEnableNewBackpack then
		backpackOpenChangedConnection = Roact.createElement(EventConnection, {
			event = BackpackScript.StateChanged.Event,
			callback = function(p2)
				p.props.setBackpackOpen(p2)
			end
		})
	end

	children.BackpackOpenChangedConnection = backpackOpenChangedConnection

	children.EmotesOpenChangedConnection = Roact.createElement(EventConnection, {
		event = EmotesMenuMaster.EmotesMenuToggled.Event,
		callback = function(p2)
			p.props.setEmotesOpen(p2)
		end
	})

	children.EmotesEnabledChangedConnection = Roact.createElement(EventConnection, {
		event = EmotesMenuMaster.MenuVisibilityChanged.Event,
		callback = function(p2)
			p.props.setEmotesEnabled(p2)
		end
	})
	return createFragment(children)
end

local function mapDispatchToProps(callback)
	return {
		setBackpackOpen = function(p)
			return callback(SetBackpackOpen(p))
		end,
		setEmotesOpen = function(p)
			return callback(SetEmotesOpen(p))
		end,
		setLeaderboardOpen = function(p)
			return callback(SetLeaderboardOpen(p))
		end,
		setEmotesEnabled = function(p)
			return callback(SetEmotesEnabled(p))
		end
	}
end

return RoactRodux.UNSTABLE_connect2(nil, mapDispatchToProps)(extended)
