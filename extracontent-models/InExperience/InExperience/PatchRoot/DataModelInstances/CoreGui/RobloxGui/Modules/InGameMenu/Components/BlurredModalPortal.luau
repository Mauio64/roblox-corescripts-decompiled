local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local RunService = game:GetService("RunService")
local VRService = game:GetService("VRService")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local t = InGameMenuDependencies.t
local InGameMenu = script:FindFirstAncestor("InGameMenu")
local Constants = require(InGameMenu.Resources.Constants)
local v10 = Roact.PureComponent:extend("BlurredModalPortal")

v10.validateProps = t.strictInterface({
	Enabled = t.boolean,
	[Roact.Children] = t.optional(t.table)
})

function v10.render(p1) -- line: 20
	-- upvalues: Roact (copy), CoreGui (copy), Constants (copy)
	return Roact.createElement(Roact.Portal, {
		target = CoreGui
	}, {
		InGameMenuModalBlur = Roact.createElement("ScreenGui", {
			OnTopOfCoreBlur = true,
			IgnoreGuiInset = true,
			Enabled = p1.props.Enabled,
			DisplayOrder = Constants.DisplayOrder.BlurredModalPortal
		}, p1.props[Roact.Children])
	})
end
function v10.didUpdate(p2, p3) -- line: 34
	-- upvalues: VRService (copy), RunService (copy)
	if VRService.VREnabled then
		return
	end

	local p3Enabled = p3.Enabled
	local propsEnabled = p2.props.Enabled

	if p3Enabled ~= propsEnabled then
		RunService:SetRobloxGuiFocused(propsEnabled)
	end
end

return v10
