local CorePackages = game:GetService("CorePackages")
local RobloxGui = game:GetService("CoreGui"):WaitForChild("RobloxGui")
local StarterGui = game:GetService("StarterGui")
local Modules = RobloxGui.Modules
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local ParentParent = script.Parent.Parent.Parent
local UpdateCoreGuiEnabled = require(ParentParent.Actions.UpdateCoreGuiEnabled)
local EventConnection = require(ParentParent.Parent.Common.EventConnection)
local FFlagMountCoreGuiBackpack = require(Modules.Flags.FFlagMountCoreGuiBackpack)

if require(ParentParent.Flags.FFlagTopBarDeprecateCoreGuiRodux) then
	return nil
end

local FFlagTopBarSignalizeHealthBar = require(CorePackages.Workspace.Packages.CoreGuiCommon).Flags.FFlagTopBarSignalizeHealthBar
local v13 = Roact.PureComponent:extend("CoreGuiConnector")

v13.validateProps = t.strictInterface({
	updateCoreGuiEnabled = t.callback
})

function v13.didMount(p1) -- line: 37
	-- upvalues: FFlagMountCoreGuiBackpack (copy), FFlagTopBarSignalizeHealthBar (copy), StarterGui (copy)
	local EnumItems = Enum.CoreGuiType:GetEnumItems()

	for _, v in ipairs(EnumItems) do
		if (not FFlagMountCoreGuiBackpack or v ~= Enum.CoreGuiType.Backpack) and ((not FFlagTopBarSignalizeHealthBar or v ~= Enum.CoreGuiType.Health) and v ~= Enum.CoreGuiType.All) then
			p1.props.updateCoreGuiEnabled(v, StarterGui:GetCoreGuiEnabled(v))
		end
	end
end
function v13.render(p2) -- line: 50
	-- upvalues: Roact (copy), EventConnection (copy), StarterGui (copy), FFlagMountCoreGuiBackpack (copy)
	return Roact.createFragment({
		CoreGuiChangedConnection = Roact.createElement(EventConnection, {
			event = StarterGui.CoreGuiChangedSignal,
			callback = function(p3, p4) -- line: 54
				-- upvalues: FFlagMountCoreGuiBackpack (copy), p2 (copy)
				if FFlagMountCoreGuiBackpack then
					if p3 ~= Enum.CoreGuiType.Backpack then
						p2.props.updateCoreGuiEnabled(p3, p4)

						return
					end
				else
					p2.props.updateCoreGuiEnabled(p3, p4)
				end
			end
		})
	})
end

local function mapDispatchToProps(p5) -- line: 68
	-- upvalues: UpdateCoreGuiEnabled (copy)
	return {
		updateCoreGuiEnabled = function(p6, p7) -- line: 70
			-- upvalues: p5 (copy), UpdateCoreGuiEnabled (copy)
			return p5(UpdateCoreGuiEnabled(p6, p7))
		end
	}
end

return RoactRodux.UNSTABLE_connect2(nil, mapDispatchToProps)(v13)
