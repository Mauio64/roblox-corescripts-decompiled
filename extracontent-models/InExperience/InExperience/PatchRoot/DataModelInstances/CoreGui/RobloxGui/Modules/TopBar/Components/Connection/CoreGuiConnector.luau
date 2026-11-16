local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local StarterGui = game:GetService("StarterGui")

local Modules = RobloxGui.Modules
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)

local parent = script.Parent.Parent.Parent

local UpdateCoreGuiEnabled = require(parent.Actions.UpdateCoreGuiEnabled)

local EventConnection = require(parent.Parent.Common.EventConnection)

local FFlagMountCoreGuiBackpack = require(Modules.Flags.FFlagMountCoreGuiBackpack)
local FFlagTopBarDeprecateCoreGuiRodux = require(parent.Flags.FFlagTopBarDeprecateCoreGuiRodux)

if FFlagTopBarDeprecateCoreGuiRodux then
	return nil
end

local CoreGuiCommon = require(CorePackages.Workspace.Packages.CoreGuiCommon)
local FFlagTopBarSignalizeHealthBar = CoreGuiCommon.Flags.FFlagTopBarSignalizeHealthBar

local extended = Roact.PureComponent:extend("CoreGuiConnector")

extended.validateProps = t.strictInterface({ updateCoreGuiEnabled = t.callback })

function extended.didMount(p)
	local enumItems = Enum.CoreGuiType:GetEnumItems()

	for _, enumItem in ipairs(enumItems) do
		if not ((not FFlagMountCoreGuiBackpack or enumItem ~= Enum.CoreGuiType.Backpack) and (not FFlagTopBarSignalizeHealthBar or enumItem ~= Enum.CoreGuiType.Health) and enumItem ~= Enum.CoreGuiType.All) then
			continue
		end

		p.props.updateCoreGuiEnabled(enumItem, StarterGui:GetCoreGuiEnabled(enumItem))
	end
end

function extended.render(p)
	return Roact.createFragment({
		CoreGuiChangedConnection = Roact.createElement(EventConnection, {
			event = StarterGui.CoreGuiChangedSignal,
			callback = function(p2, p3)
				if FFlagMountCoreGuiBackpack then
					if p2 ~= Enum.CoreGuiType.Backpack then
						p.props.updateCoreGuiEnabled(p2, p3)
					end
				else
					p.props.updateCoreGuiEnabled(p2, p3)
				end
			end
		})
	})
end

local function mapDispatchToProps(callback)
	return {
		updateCoreGuiEnabled = function(p, p2)
			return callback(UpdateCoreGuiEnabled(p, p2))
		end
	}
end

return RoactRodux.UNSTABLE_connect2(nil, mapDispatchToProps)(extended)
