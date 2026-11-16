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

local parent = script.Parent.Parent.Parent
local FFlagPlayerListReduceRerenders = require(parent.Flags.FFlagPlayerListReduceRerenders)
local FFlagPlayerListRemoveTopStat = require(parent.Flags.FFlagPlayerListRemoveTopStat)

local FFlagEnableMobilePlayerListOnConsole = PlayerList.Flags.FFlagEnableMobilePlayerListOnConsole
local defineFastFlag = game:DefineFastFlag("PlayerListTopStatCheckGamepad", false)

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagLuaSupportMicroGamepadPreferredInput = SharedFlags.FFlagLuaSupportMicroGamepadPreferredInput

local v = nil

if not FFlagPlayerListRemoveTopStat then
	local v2 = not defineFastFlag
		or UserInputService.PreferredInput == Enum.PreferredInput.Gamepad
		or FFlagLuaSupportMicroGamepadPreferredInput
		and UserInputService.PreferredInput == Enum.PreferredInput.MicroGamepad

	if FFlagEnableMobilePlayerListOnConsole then
		if GuiService.ViewportDisplaySize ~= Enum.DisplaySize.Large then
			v2 = false
		end
	else
		v2 = TenFootInterface:IsEnabled()
	end

	if v2 then
		v = TenFootInterface:SetupTopStat()
	end
end

local extended = Roact.PureComponent:extend("TopStatConnector")

function extended.render(p): nil
	if v then
		v:SetTopStatEnabled(p.props.displayOptions.playerlistCoreGuiEnabled)
	end

	return nil
end

local function mapStateToProps(p)
	return { displayOptions = p.displayOptions }
end

if FFlagPlayerListReduceRerenders then
	return React.memo(RoactRodux.connect(mapStateToProps, nil)(extended))
end

return RoactRodux.connect(mapStateToProps, nil)(extended)
