local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local ParentParent = script.Parent.Parent
local SetDetailsInformation = require(ParentParent.Actions.SetDetailsInformation)
local SetTryingOnInfo = require(ParentParent.Actions.SetTryingOnInfo)
local InspectAndBuyContext = require(ParentParent.Components.InspectAndBuyContext)
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Theme = require(Modules.Settings.Theme)
local v11 = Roact.PureComponent:extend("CloseButton")

function v11.render(p1) -- line: 19
	-- upvalues: Roact (copy), InspectAndBuyContext (copy), Theme (copy), GuiService (copy)
	local view = p1.props.view
	local viewingDetails = p1.props.detailsInformation.viewingDetails
	local closeDetails = p1.props.closeDetails
	local setTryingOnInfo = p1.props.setTryingOnInfo

	return Roact.createElement(InspectAndBuyContext.Consumer, {
		render = function(p2) -- line: 26
			-- upvalues: view (copy), Theme (copy), Roact (copy), viewingDetails (copy), closeDetails (copy), setTryingOnInfo (copy), GuiService (copy)
			local v21 = p2[view]
			local uDim2 = UDim2.new(0, 0, 0, 0)
			local n1 = 26

			if Theme.UseInspectAndBuyPanel() then
				n1 = 18
				uDim2 = UDim2.new(0, v21.BorderPaddingSize, 0, 0)
			end

			return Roact.createElement("ImageButton", {
				Size = UDim2.new(0, n1, 0, n1),
				Position = v21.CloseButtonPosition + uDim2,
				BackgroundTransparency = 1,
				Selectable = false,
				Image = not viewingDetails and "rbxasset://textures/ui/InspectMenu/x.png" or "rbxasset://textures/ui/InspectMenu/caret_tail_left.png",
				ZIndex = 2,
				[Roact.Event.Activated] = function() -- line: 42
					-- upvalues: viewingDetails (copy), closeDetails (copy), setTryingOnInfo (copy), GuiService (copy)
					if viewingDetails then
						closeDetails()
						setTryingOnInfo(false, nil)

						return
					end

					GuiService:CloseInspectMenu()
				end
			})
		end
	})
end

return RoactRodux.UNSTABLE_connect2(function(p3, _) -- line: 55
	return {
		view = p3.view,
		detailsInformation = p3.detailsInformation
	}
end, function(p5) -- line: 60
	-- upvalues: SetDetailsInformation (copy), SetTryingOnInfo (copy)
	return {
		closeDetails = function() -- line: 62
			-- upvalues: p5 (copy), SetDetailsInformation (copy)
			p5(SetDetailsInformation(false, nil))
		end,
		setTryingOnInfo = function(p6, p7) -- line: 65
			-- upvalues: p5 (copy), SetTryingOnInfo (copy)
			p5(SetTryingOnInfo(p6, p7))
		end
	}
end)(v11)
