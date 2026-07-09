local ParentParent = script.Parent.Parent
local Roact = require(ParentParent.Roact)
local Interactable = require(ParentParent.UIBlox).Core.Control.Interactable
local LinkingProtocol = require(ParentParent.LinkingProtocol).LinkingProtocol
local v5 = require(ParentParent.RobloxTranslator):FormatByKey("CoreScripts.Ads.Label.IllegalContentReportingLink")

function ReportAdFooter(t1: {[any]: any}) -- line: 18
	-- upvalues: LinkingProtocol (copy), Roact (copy), Interactable (copy), v5 (copy)
	local default = LinkingProtocol.default
	local v8 = "https://www.roblox.com/illegal-content-reporting?contentURL=" .. "https://create.roblox.com/store/asset/" .. t1.assetId

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 48)
	}, {
		UIListLayout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		UIPadding = Roact.createElement("UIPadding", {
			PaddingTop = UDim.new(0, 16)
		}),
		Border = Roact.createElement("Frame", {
			BackgroundTransparency = 0.8,
			LayoutOrder = 1,
			Size = UDim2.new(1, 0, 0, 1),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		}),
		InteractableText = Roact.createElement(Interactable, {
			AutomaticSize = Enum.AutomaticSize.XY,
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			[Roact.Event.Activated] = function() -- line: 46
				-- upvalues: default (copy), v8 (copy)
				default:openURL(v8)
			end
		}, {
			UIListLayout = Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			FooterText = Roact.createElement("TextLabel", {
				BackgroundTransparency = 1,
				TextSize = 16,
				TextScaled = false,
				TextWrapped = false,
				Text = v5,
				TextColor3 = Color3.fromRGB(82, 173, 244),
				Font = Enum.Font.GothamBold,
				AutomaticSize = Enum.AutomaticSize.XY,
				AnchorPoint = Vector2.new(0.5, 0.5)
			}, {
				UIPadding = Roact.createElement("UIPadding", {
					PaddingTop = UDim.new(0, 16)
				})
			})
		})
	})
end

return ReportAdFooter
