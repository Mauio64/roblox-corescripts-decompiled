local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
require(script.Parent.Parent.EventType)
local Roact = require(CorePackages.Packages.Roact)
local VRFTUXToolTips = require(script.Parent.Parent.Parent.Components.Tooltips.VRFTUXToolTips)

local renderWithCoreScriptsStyleProvider = require(script.Parent.Parent.Parent.Parent.Common.renderWithCoreScriptsStyleProvider)

local PerspectiveTooltipEvent = { Name = "PerspectiveTooltipEvent" }

local v = nil

function PerspectiveTooltipEvent.StartEvent()
	local v2 = renderWithCoreScriptsStyleProvider({ (Roact.createElement(VRFTUXToolTips, {
			tooltipButtons = {
				{
					Text = "Press",
					Controller = Enum.UserCFrame.RightHand,
					ButtonKeycode = Enum.KeyCode.ButtonR3
				}
			}
		})) })

	v = Roact.mount(v2, CoreGui:FindFirstChild("FTUXMenu"), "PerspectiveTooltip")
end

function PerspectiveTooltipEvent.StopEvent()
	if v then
		Roact.unmount(v)
	end
end

return PerspectiveTooltipEvent
