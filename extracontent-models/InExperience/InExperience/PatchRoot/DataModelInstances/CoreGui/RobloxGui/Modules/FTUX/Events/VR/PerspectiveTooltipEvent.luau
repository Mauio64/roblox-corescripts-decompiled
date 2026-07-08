local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")

require(script.Parent.Parent.EventType)

local Roact = require(CorePackages.Packages.Roact)
local VRFTUXToolTips = require(script.Parent.Parent.Parent.Components.Tooltips.VRFTUXToolTips)
local renderWithCoreScriptsStyleProvider = require(script.Parent.Parent.Parent.Parent.Common.renderWithCoreScriptsStyleProvider)
local t1 = {
	Name = "PerspectiveTooltipEvent"
}
local u7 = nil

function t1.StartEvent() -- line: 27
	-- upvalues: Roact (copy), VRFTUXToolTips (copy), renderWithCoreScriptsStyleProvider (copy), u7 (ref), CoreGui (copy)
	local v8 = Roact.createElement(VRFTUXToolTips, {
		tooltipButtons = {{
			Text = "Press",
			Controller = Enum.UserCFrame.RightHand,
			ButtonKeycode = Enum.KeyCode.ButtonR3
		}}
	})
	local v9 = renderWithCoreScriptsStyleProvider({ v8 })

	u7 = Roact.mount(v9, CoreGui:FindFirstChild("FTUXMenu"), "PerspectiveTooltip")
end
function t1.StopEvent() -- line: 48
	-- upvalues: u7 (ref), Roact (copy)
	if u7 then
		Roact.unmount(u7)
	end
end

return t1
