local Parent = script:FindFirstAncestor("InGameAssetReporting").Parent
local React = require(Parent.React)
local UIBlox = require(Parent.UIBlox)
local Foundation = require(Parent.Foundation)
local Button = Foundation.Button
local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize
local HeaderBar = UIBlox.App.Bar.HeaderBar
local IconButton = UIBlox.App.Button.IconButton
local IconSize = UIBlox.App.ImageSet.Enum.IconSize
local Images = UIBlox.App.ImageSet.Images
local withStyle = UIBlox.Style.withStyle

local function renderHeaderBarLeft(p1) -- line: 36
	-- upvalues: React (copy), IconButton (copy), IconSize (copy), Images (copy)
	return function() -- line: 37
		-- upvalues: React (copy), IconButton (copy), IconSize (copy), Images (copy), p1 (copy)
		return React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(0, 30, 1, 0)
		}, {
			Layout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			BackButton = React.createElement(IconButton, {
				layoutOrder = 1,
				iconSize = IconSize.Medium,
				icon = Images["icons/navigation/pushBack"],
				onActivated = p1
			})
		})
	end
end
local function renderHeaderBarCenter(p2) -- line: 58
	-- upvalues: withStyle (copy), React (copy)
	return function() -- line: 59
		-- upvalues: withStyle (copy), React (copy), p2 (copy)
		return withStyle(function(p3) -- line: 60
			-- upvalues: React (copy), p2 (copy)
			local CurrentCamera = game.Workspace.CurrentCamera
			local n1 = 300

			if CurrentCamera ~= nil then
				n1 = CurrentCamera.ViewportSize.X - 150
			end

			local Theme = p3.Theme
			local p3Font = p3.Font

			return React.createElement("TextLabel", {
				TextSize = 20,
				TextWrapped = true,
				BackgroundTransparency = 1,
				Text = p2,
				Font = p3Font.Header2.Font,
				TextColor3 = Theme.TextEmphasis.Color,
				TextTransparency = Theme.TextEmphasis.Transparency,
				TextXAlignment = Enum.TextXAlignment.Center,
				TextYAlignment = Enum.TextYAlignment.Center,
				Size = UDim2.new(0, n1, 1, 0)
			})
		end)
	end
end
local function renderHeaderBarRight() -- line: 87
	-- upvalues: React (copy)
	return function() -- line: 88
		-- upvalues: React (copy)
		return React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(0, 60, 1, 0)
		}, {
			Layout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder
			})
		})
	end
end

return {
	PortraitModeHeader = function(t1: {[any]: any}) -- line: 103
		-- upvalues: React (copy), HeaderBar (copy), IconButton (copy), IconSize (copy), Images (copy), withStyle (copy)
		local createElement = React.createElement
		local t2 = {
			BorderSizePixel = 0,
			BackgroundTransparency = 0.1,
			LayoutOrder = 1,
			ZIndex = 2,
			BackgroundColor3 = Color3.fromHex("#000000"),
			Size = UDim2.new(1, 0, 0, 72)
		}
		local t3 = {}
		local createElement2 = React.createElement
		local v23 = HeaderBar
		local t4 = {
			backgroundTransparency = 1,
			barHeight = 72,
			margin = 12,
			isSecondary = true
		}
		local backAction = t1.backAction

		function t4.renderLeft() -- line: 37
			-- upvalues: React (copy), IconButton (copy), IconSize (copy), Images (copy), backAction (copy)
			return React.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(0, 30, 1, 0)
			}, {
				Layout = React.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalAlignment = Enum.HorizontalAlignment.Left,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					SortOrder = Enum.SortOrder.LayoutOrder
				}),
				BackButton = React.createElement(IconButton, {
					layoutOrder = 1,
					iconSize = IconSize.Medium,
					icon = Images["icons/navigation/pushBack"],
					onActivated = backAction
				})
			})
		end
		function t4.renderRight() -- line: 88
			-- upvalues: React (copy)
			return React.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(0, 60, 1, 0)
			}, {
				Layout = React.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					SortOrder = Enum.SortOrder.LayoutOrder
				})
			})
		end

		local titleText = t1.titleText

		function t4.renderCenter() -- line: 59
			-- upvalues: withStyle (copy), React (copy), titleText (copy)
			return withStyle(function(p4) -- line: 60
				-- upvalues: React (copy), titleText (copy)
				local CurrentCamera = game.Workspace.CurrentCamera
				local n2 = 300

				if CurrentCamera ~= nil then
					n2 = CurrentCamera.ViewportSize.X - 150
				end

				local Theme = p4.Theme
				local p4Font = p4.Font

				return React.createElement("TextLabel", {
					TextSize = 20,
					TextWrapped = true,
					BackgroundTransparency = 1,
					Text = titleText,
					Font = p4Font.Header2.Font,
					TextColor3 = Theme.TextEmphasis.Color,
					TextTransparency = Theme.TextEmphasis.Transparency,
					TextXAlignment = Enum.TextXAlignment.Center,
					TextYAlignment = Enum.TextYAlignment.Center,
					Size = UDim2.new(0, n2, 1, 0)
				})
			end)
		end

		t3.Bar = createElement2(v23, t4)

		return createElement("Frame", t2, t3)
	end,
	PortraitModeFooter = function(t5: {[any]: any}) -- line: 124
		-- upvalues: React (copy), Foundation (copy), Button (copy), ButtonVariant (copy), InputSize (copy)
		return React.createElement("Frame", {
			BorderSizePixel = 0,
			BackgroundTransparency = 0.1,
			LayoutOrder = 4,
			Size = UDim2.new(1, 0, 0, 60),
			BackgroundColor3 = Color3.fromHex("#000000"),
			AnchorPoint = Vector2.new(0, 1),
			Position = UDim2.fromScale(0, 1)
		}, {
			Layout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center
			}),
			CoachmarkWrapper = React.createElement(Foundation.Coachmark, {
				title = t5.coachmarkTitle,
				text = t5.coachmarkText,
				isOpen = t5.isCoachmarkOpen or false,
				side = Foundation.Enums.PopoverSide.Top,
				align = Foundation.Enums.PopoverAlign.Center,
				onClose = t5.onCoachmarkClose
			}, {
				NextButton = React.createElement(Button, {
					variant = ButtonVariant.Emphasis,
					inputSize = InputSize.Large,
					width = UDim.new(0, 400),
					onActivated = t5.nextAction,
					text = t5.nextText
				})
			})
		})
	end
}
