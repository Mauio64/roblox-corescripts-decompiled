local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
require(script.Parent.Parent.EventType)
local Roact = require(CorePackages.Packages.Roact)
local VRFTUXToolTips = require(script.Parent.Parent.Parent.Components.Tooltips.VRFTUXToolTips)

local renderWithCoreScriptsStyleProvider = require(script.Parent.Parent.Parent.Parent.Common.renderWithCoreScriptsStyleProvider)

local MovementTooltipEvent = { Name = "MovementTooltipEvent" }

local v = nil

function MovementTooltipEvent.StartEvent()
	local v2 = renderWithCoreScriptsStyleProvider({ (Roact.createElement(VRFTUXToolTips, {
			tooltipButtons = {
				{
					Text = "Turn",
					Controller = Enum.UserCFrame.RightHand,
					ButtonKeycode = Enum.KeyCode.ButtonR3
				},
				{
					Text = "Move",
					Controller = Enum.UserCFrame.LeftHand,
					ButtonKeycode = Enum.KeyCode.ButtonL3
				},
				{
					Text = "Jump",
					Controller = Enum.UserCFrame.RightHand,
					ButtonKeycode = Enum.KeyCode.ButtonA
				}
			}
		})) })

	v = Roact.mount(v2, CoreGui:FindFirstChild("FTUXMenu"), "MovementTooltip")
end

function MovementTooltipEvent.StopEvent()
	if v then
		Roact.unmount(v)
	end
end

return MovementTooltipEvent
