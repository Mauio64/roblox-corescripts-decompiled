local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local parent = script.Parent.Parent
local SetDetailsInformation = require(parent.Actions.SetDetailsInformation)
local SetTryingOnInfo = require(parent.Actions.SetTryingOnInfo)

local InspectAndBuyContext = require(parent.Components.InspectAndBuyContext)
local CoreGui = game:GetService("CoreGui")
local Modules = CoreGui.RobloxGui.Modules
local Theme = require(Modules.Settings.Theme)

local extended = Roact.PureComponent:extend("CloseButton")

function extended.render(p)
	local view = p.props.view
	local viewingDetails = p.props.detailsInformation.viewingDetails
	local closeDetails = p.props.closeDetails
	local setTryingOnInfo = p.props.setTryingOnInfo

	return Roact.createElement(InspectAndBuyContext.Consumer, {
		render = function(p2)
			local v = p2[view]
			local udim = UDim2.new(0, 0, 0, 0)
			local v2

			if Theme.UseInspectAndBuyPanel() then
				udim = UDim2.new(0, v.BorderPaddingSize, 0, 0)
				v2 = 18
			else
				v2 = 26
			end

			return Roact.createElement("ImageButton", {
				Size = UDim2.new(0, v2, 0, v2),
				Position = v.CloseButtonPosition + udim,
				BackgroundTransparency = 1,
				Selectable = false,
				Image = viewingDetails and "rbxasset://textures/ui/InspectMenu/caret_tail_left.png" or "rbxasset://textures/ui/InspectMenu/x.png",
				ZIndex = 2,
				[Roact.Event.Activated] = function()
					if not viewingDetails then
						GuiService:CloseInspectMenu()

						return
					end

					closeDetails()
					setTryingOnInfo(false, nil)
				end
			})
		end
	})
end

return RoactRodux.UNSTABLE_connect2(function(p, _)
	return { view = p.view, detailsInformation = p.detailsInformation }
end, function(callback)
	return {
		closeDetails = function()
			callback(SetDetailsInformation(false, nil))
		end,
		setTryingOnInfo = function(p, p2)
			callback(SetTryingOnInfo(p, p2))
		end
	}
end)(extended)
