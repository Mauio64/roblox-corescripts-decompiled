local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)

local parent = script.Parent.Parent.Parent
local FFlagTopBarDeprecateDisplayOptionsRodux = require(parent.Flags.FFlagTopBarDeprecateDisplayOptionsRodux)

if FFlagTopBarDeprecateDisplayOptionsRodux then
	return nil
end

local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local ChatSelector = require(RobloxGui.Modules.ChatSelector)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagEnableNewBackpack = SharedFlags.FFlagEnableNewBackpack
local BackpackScript

if FFlagEnableNewBackpack then
	BackpackScript = nil
else
	BackpackScript = require(RobloxGui.Modules.BackpackScript)
end

local EmotesMenuMaster = require(RobloxGui.Modules.EmotesMenu.EmotesMenuMaster)
local PlayerListManager = require(RobloxGui.Modules.PlayerList.PlayerListManager)

local extended = Roact.PureComponent:extend("CoreGuiCEnabledNotifieronnector")

extended.validateProps = t.strictInterface({ topBarEnabled = t.boolean })

function extended:notifyEnabled()
	PlayerListManager:SetTopBarEnabled(self.props.topBarEnabled)
	ChatSelector:TopbarEnabledChanged(self.props.topBarEnabled)

	if not FFlagEnableNewBackpack and BackpackScript then
		BackpackScript:TopbarEnabledChanged(self.props.topBarEnabled)
	end

	EmotesMenuMaster:setTopBarEnabled(self.props.topBarEnabled)
end

function extended:didMount()
	self:notifyEnabled()
end

function extended.render(_): nil
	return nil
end

function extended:didUpdate(p, _)
	if self.props.topBarEnabled ~= p.topBarEnabled then
		self:notifyEnabled()
	end
end

local function mapStateToProps(p)
	return { topBarEnabled = p.displayOptions.topbarEnabled }
end

return RoactRodux.UNSTABLE_connect2(mapStateToProps, nil)(extended)
