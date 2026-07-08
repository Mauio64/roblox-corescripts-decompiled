local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local ParentParent = script.Parent.Parent.Parent

if require(ParentParent.Flags.FFlagTopBarDeprecateDisplayOptionsRodux) then
	return nil
end

local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local ChatSelector = require(RobloxGui.Modules.ChatSelector)
local FFlagEnableNewBackpack = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableNewBackpack
local v10 = if FFlagEnableNewBackpack then nil else require(RobloxGui.Modules.BackpackScript)
local EmotesMenuMaster = require(RobloxGui.Modules.EmotesMenu.EmotesMenuMaster)
local PlayerListManager = require(RobloxGui.Modules.PlayerList.PlayerListManager)
local v13 = Roact.PureComponent:extend("CoreGuiCEnabledNotifieronnector")

v13.validateProps = t.strictInterface({
	topBarEnabled = t.boolean
})

function v13.notifyEnabled(p1) -- line: 29
	-- upvalues: PlayerListManager (copy), ChatSelector (copy), FFlagEnableNewBackpack (copy), v10 (copy), EmotesMenuMaster (copy)
	PlayerListManager:SetTopBarEnabled(p1.props.topBarEnabled)
	ChatSelector:TopbarEnabledChanged(p1.props.topBarEnabled)

	if not FFlagEnableNewBackpack and v10 then
		v10:TopbarEnabledChanged(p1.props.topBarEnabled)
	end

	EmotesMenuMaster:setTopBarEnabled(p1.props.topBarEnabled)
end
function v13.didMount(p2) -- line: 38
	p2:notifyEnabled()
end
function v13.render(_) -- line: 42
	return nil
end
function v13.didUpdate(p4, p5, _) -- line: 46
	if p4.props.topBarEnabled ~= p5.topBarEnabled then
		p4:notifyEnabled()
	end
end

local function mapStateToProps(p7) -- line: 52
	return {
		topBarEnabled = p7.displayOptions.topbarEnabled
	}
end

return RoactRodux.UNSTABLE_connect2(mapStateToProps, nil)(v13)
