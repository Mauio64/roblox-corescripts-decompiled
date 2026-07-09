local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local Roact = require(CorePackages.Packages.Roact)
local withLocalization = require(CorePackages.Workspace.Packages.Localization).withLocalization
local t = require(CorePackages.Packages.t)
local GamepadBottomBarElement = require(Modules.AvatarExperience.Common.Components.GamepadBottomBarElement)
local t1 = {
	[Enum.KeyCode.ButtonA] = "rbxasset://textures/ui/Controls/DesignSystem/ButtonA.png",
	[Enum.KeyCode.ButtonB] = "rbxasset://textures/ui/Controls/DesignSystem/ButtonB.png",
	[Enum.KeyCode.ButtonX] = "rbxasset://textures/ui/Controls/DesignSystem/ButtonX.png",
	[Enum.KeyCode.ButtonY] = "rbxasset://textures/ui/Controls/DesignSystem/ButtonY.png",
	[Enum.KeyCode.ButtonL3] = "rbxasset://textures/ui/Controls/DesignSystem/ButtonL3.png",
	[Enum.KeyCode.ButtonR3] = "rbxasset://textures/ui/Controls/DesignSystem/ButtonR3.png",
	[Enum.KeyCode.Thumbstick1] = "rbxasset://textures/ui/Controls/DesignSystem/Thumbstick1Directional.png",
	[Enum.KeyCode.Thumbstick2] = "rbxasset://textures/ui/Controls/DesignSystem/Thumbstick2Directional.png"
}
local t2 = {
	[Enum.KeyCode.Thumbstick1] = {
		vertical = "rbxasset://textures/ui/Controls/DesignSystem/Thumbstick1Vertical.png",
		horizontal = "rbxasset://textures/ui/Controls/DesignSystem/Thumbstick1Horizontal.png"
	},
	[Enum.KeyCode.Thumbstick2] = {
		vertical = "rbxasset://textures/ui/Controls/DesignSystem/Thumbstick2Vertical.png",
		horizontal = "rbxasset://textures/ui/Controls/DesignSystem/Thumbstick2Horizontal.png"
	}
}
local t3 = {
	["Feature.Catalog.Action.ItemOptions"] = 1,
	["CommonUI.Messages.Action.Apply"] = 1,
	["CommonUI.Messages.Action.Reset"] = 2,
	["Feature.Catalog.Action.OpenDetails"] = 2,
	["Feature.Catalog.Action.CloseDetails"] = 2,
	["Feature.Catalog.Action.Buy"] = 3,
	["Feature.Avatar.Heading.WearConfirmation"] = 4,
	["CommonUI.Controls.Action.Confirm"] = 5,
	["Feature.Catalog.Action.Remove"] = 6,
	["Feature.Avatar.Title.Move"] = 7,
	["Feature.Avatar.Action.Pan"] = 1,
	["Feature.Avatar.Action.Zoom"] = 2,
	["Feature.Avatar.Action.Rotate"] = 3,
	["Feature.Avatar.Action.DefaultView"] = 4
}
local v11 = Roact.PureComponent:extend("GamepadBottomBarContent")

v11.validateProps = t.strictInterface({
	boundInputs = t.table,
	width = t.number
})

function v11.renderElements(p1, p2, p3) -- line: 92
	-- upvalues: Roact (copy), GamepadBottomBarElement (copy)
	local width = p1.props.width
	local t4 = {}
	local v17 = #p2

	if v17 > 0 and width > 0 then
		local v18 = (width - (v17 - 1) * 36 - 24) / v17

		for i = 1, v17 do
			local v20 = p2[i]
			local v21 = p3[i]

			t4[i] = Roact.createElement(GamepadBottomBarElement, {
				elementIcon = v21.elementIcon,
				elementText = v20,
				layoutOrder = v21.layoutOrder,
				disabled = v21.disabled,
				width = v18
			})
		end
	end

	return Roact.createFragment(t4)
end
function v11.render(p4) -- line: 119
	-- upvalues: t2 (copy), t3 (copy), t1 (copy), withLocalization (copy)
	local boundInputs = p4.props.boundInputs
	local t5 = {}
	local t6 = {}

	if boundInputs then
		for v26, v27 in boundInputs do
			if typeof(v27) == "table" and v26 ~= Enum.KeyCode.ButtonB then
				if v27.axes then
					local vertical = v27.axes.vertical
					local horizontal = v27.axes.horizontal
					local v30 = t2[v26]

					if vertical then
						table.insert(t5, vertical.key)
						table.insert(t6, {
							elementIcon = v30.vertical,
							layoutOrder = t3[vertical.key] or 0,
							disabled = vertical.disabled
						})
					end

					if horizontal then
						table.insert(t5, horizontal.key)
						table.insert(t6, {
							elementIcon = v30.horizontal,
							layoutOrder = t3[horizontal.key] or 0,
							disabled = horizontal.disabled
						})
					end
				elseif v27.key then
					table.insert(t5, v27.key)
					table.insert(t6, {
						elementIcon = t1[v26],
						layoutOrder = t3[v27.key] or 0,
						disabled = v27.disabled
					})
				end
			end
		end
	end

	return withLocalization(t5)(function(p5) -- line: 174
		-- upvalues: p4 (copy), t6 (copy)
		return p4:renderElements(p5, t6)
	end)
end

return v11
