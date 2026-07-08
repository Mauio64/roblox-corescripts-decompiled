local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local ContactList = CoreGui:WaitForChild("RobloxGui").Modules.ContactList
local UIBlox = require(ContactList.dependencies).UIBlox
local Colors = UIBlox.App.Style.Colors
local useStyle = UIBlox.Core.Style.useStyle
local Interactable = UIBlox.Core.Control.Interactable
local TooltipOrientation = UIBlox.App.Dialog.Enum.TooltipOrientation
local withTooltip = UIBlox.App.Dialog.TooltipV2.withTooltip
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Images = UIBlox.App.ImageSet.Images

local function v13() -- line: 29
end
local function SectionHeader(t1: {[any]: any}) -- line: 31
	-- upvalues: useStyle (copy), React (copy), withTooltip (copy), TooltipOrientation (copy), CoreGui (copy), Interactable (copy), v13 (copy), ImageSetLabel (copy), Images (copy), Colors (copy)
	local v16 = useStyle()
	local Theme = v16.Theme
	local Font = v16.Font
	local v19, v20 = React.useState(false)

	return React.createElement("Frame", {
		Position = UDim2.fromOffset(0, 0),
		Size = UDim2.new(1, 0, 0, 24),
		BackgroundColor3 = Theme.BackgroundContrast.Color,
		LayoutOrder = t1.layoutOrder
	}, {
		UIPadding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, 24)
		}),
		HeaderText = React.createElement("TextLabel", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, -28, 1, 0),
			Font = Font.Footer.Font,
			Text = string.upper(t1.name),
			TextColor3 = Theme.TextDefault.Color,
			TextSize = Font.Footer.RelativeSize * Font.BaseSize,
			TextTransparency = Theme.TextDefault.Transparency,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Center,
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0, 0, 0.5, 0)
		}),
		Tooltip = withTooltip({
			headerText = t1.name,
			bodyText = t1.description
		}, {
			DisplayOrder = 100,
			preferredOrientation = TooltipOrientation.Right,
			guiTarget = CoreGui,
			active = v19
		}, function(p1) -- line: 68
			-- upvalues: React (copy), Interactable (copy), v20 (copy), v19 (copy), v13 (copy), ImageSetLabel (copy), Images (copy), Colors (copy)
			return React.createElement(Interactable, {
				Position = UDim2.new(1, -28, 0.5, 0),
				AnchorPoint = Vector2.new(1, 0.5),
				Size = UDim2.fromOffset(28, 28),
				BackgroundTransparency = 1,
				[React.Change.AbsolutePosition] = p1,
				[React.Change.AbsoluteSize] = p1,
				[React.Event.Activated] = function(_) -- line: 76
					-- upvalues: v20 (copy), v19 (copy)
					v20(not v19)
				end,
				onStateChanged = v13
			}, {
				Label = React.createElement(ImageSetLabel, {
					BackgroundTransparency = 1,
					Size = UDim2.fromScale(1, 1),
					Image = Images["icons/actions/info"],
					ImageColor3 = Colors.White
				})
			})
		end)
	})
end

return SectionHeader
