local parent = script.Parent.Parent
local Roact = require(parent.Roact)
local UIBlox = require(parent.UIBlox)
local Interactable = UIBlox.Core.Control.Interactable
local LinkingProtocol = require(parent.LinkingProtocol)
local linkingProtocol = LinkingProtocol.LinkingProtocol

local RobloxTranslator = require(parent.RobloxTranslator)
local formatByKey = RobloxTranslator:FormatByKey("CoreScripts.Ads.Label.IllegalContentReportingLink")

function ReportAdFooter(p)
	local default = linkingProtocol.default
	local v = "https://www.roblox.com/illegal-content-reporting?contentURL=" .. "https://create.roblox.com/store/asset/" .. p.assetId

	return Roact.createElement("Frame", {
		Size = UDim2.new(1, 0, 0, 48),
		BackgroundTransparency = 1
	}, {
		UIListLayout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		UIPadding = Roact.createElement("UIPadding", { PaddingTop = UDim.new(0, 16) }),
		Border = Roact.createElement("Frame", {
			Size = UDim2.new(1, 0, 0, 1),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 0.8,
			LayoutOrder = 1
		}),
		InteractableText = Roact.createElement(Interactable, {
			AutomaticSize = Enum.AutomaticSize.XY,
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			[Roact.Event.Activated] = function()
				default:openURL(v)
			end
		}, {
			UIListLayout = Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			FooterText = Roact.createElement("TextLabel", {
				Text = formatByKey,
				TextColor3 = Color3.fromRGB(82, 173, 244),
				BackgroundTransparency = 1,
				Font = Enum.Font.GothamBold,
				TextSize = 16,
				TextScaled = false,
				TextWrapped = false,
				AutomaticSize = Enum.AutomaticSize.XY,
				AnchorPoint = Vector2.new(0.5, 0.5)
			}, {
				UIPadding = Roact.createElement("UIPadding", { PaddingTop = UDim.new(0, 16) })
			})
		})
	})
end

return ReportAdFooter
