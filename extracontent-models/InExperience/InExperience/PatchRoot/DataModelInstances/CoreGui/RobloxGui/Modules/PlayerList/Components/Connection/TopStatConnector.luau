local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local PlayerList = require(CorePackages.Workspace.Packages.PlayerList)
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local TenFootInterface = require(RobloxGui.Modules.TenFootInterface)
local ParentParent = script.Parent.Parent.Parent
local FFlagPlayerListReduceRerenders = require(ParentParent.Flags.FFlagPlayerListReduceRerenders)
local FFlagEnableMobilePlayerListOnConsole = PlayerList.Flags.FFlagEnableMobilePlayerListOnConsole
local v14 = game:DefineFastFlag("PlayerListTopStatCheckGamepad", false)
local u15 = nil
local v16 = not v14 or UserInputService.PreferredInput == Enum.PreferredInput.Gamepad

if if not FFlagEnableMobilePlayerListOnConsole then TenFootInterface:IsEnabled() else GuiService.ViewportDisplaySize == Enum.DisplaySize.Large and v16 then
	u15 = TenFootInterface:SetupTopStat()
end

local v17 = Roact.PureComponent:extend("TopStatConnector")

function v17.render(p1) -- line: 33
	-- upvalues: u15 (ref)
	if u15 then
		u15:SetTopStatEnabled(p1.props.displayOptions.playerlistCoreGuiEnabled)
	end

	return nil
end

local function mapStateToProps(p2) -- line: 40
	return {
		displayOptions = p2.displayOptions
	}
end

if FFlagPlayerListReduceRerenders then
	return React.memo(RoactRodux.connect(mapStateToProps, nil)(v17))
end

return RoactRodux.connect(mapStateToProps, nil)(v17)
