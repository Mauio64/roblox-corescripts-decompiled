local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local RunService = game:GetService("RunService")
local VRService = game:GetService("VRService")

local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local t = InGameMenuDependencies.t

local InGameMenu = script:FindFirstAncestor("InGameMenu")
local Constants = require(InGameMenu.Resources.Constants)

local extended = Roact.PureComponent:extend("BlurredModalPortal")

extended.validateProps = t.strictInterface({
	Enabled = t.boolean,
	[Roact.Children] = t.optional(t.table)
})

function extended.render(p)
	return Roact.createElement(Roact.Portal, { target = CoreGui }, {
		InGameMenuModalBlur = Roact.createElement(
			"ScreenGui",
			{
				OnTopOfCoreBlur = true,
				Enabled = p.props.Enabled,
				IgnoreGuiInset = true,
				DisplayOrder = Constants.DisplayOrder.BlurredModalPortal
			},
			p.props[Roact.Children]
		)
	})
end

function extended.didUpdate(p, p2)
	if VRService.VREnabled then
		return
	end

	local enabled = p2.Enabled
	local enabled2 = p.props.Enabled

	if enabled ~= enabled2 then
		RunService:SetRobloxGuiFocused(enabled2)
	end
end

return extended
