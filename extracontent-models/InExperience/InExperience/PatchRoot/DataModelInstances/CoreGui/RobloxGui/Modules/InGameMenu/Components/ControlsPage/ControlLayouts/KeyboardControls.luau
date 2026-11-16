local CorePackages = game:GetService("CorePackages")

local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact

local parent = script.Parent.Parent.Parent.Parent

local Controls = require(parent.Resources.Controls)

local ControlLayoutContainer = require(script.Parent.Parent.ControlLayoutContainer)
local PaddedScrollFrame = require(parent.Components.PaddedScrollFrame)
local ControlEntry = require(script.Parent.Parent.ControlEntry)
local ControlEntryHeader = require(script.Parent.Parent.ControlEntryHeader)

local function KeyboardControls(_)
	local children = {
		["ListLayout"] = Roact.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		Padding = Roact.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, 95),
			PaddingRight = UDim.new(0, 95)
		}),
		SizeConstraint = Roact.createElement("UISizeConstraint", {
			MaxSize = Vector2.new(1090, 1e999),
			MinSize = Vector2.new(150, 0)
		})
	}
	local count = 0
	local layoutOrder = 1
	local count2 = 0

	for _, keybind in ipairs(Controls.keybinds) do
		local title = keybind.title
		count += 1

		children[title .. "_header"] = Roact.createElement(ControlEntryHeader, {
			title = title,
			LayoutOrder = layoutOrder
		})

		layoutOrder += 1

		for i, control in ipairs(keybind.controls) do
			count2 += 1
			children[title .. "_" .. i] = Roact.createElement(ControlEntry, {
				LayoutOrder = layoutOrder,
				actionDescription = control.desc,
				inputs = control.inputs,
				isList = control.list,
				hasDivider = i ~= #keybind.controls
			})

			layoutOrder += 1
		end
	end

	local v = count * 45 + count2 * 50

	return Roact.createElement(
		ControlLayoutContainer,
		{ titleText = "CoreScripts.InGameMenu.Controls.KeyboardAndMouseTitle" },
		{
			ScrollContent = Roact.createElement(
				PaddedScrollFrame,
				{
					CanvasSize = UDim2.new(0, 0, 0, v),
					ScrollingDirection = Enum.ScrollingDirection.Y,
					Size = UDim2.new(1, 0, 1, -130)
				},
				{
					ListContainer = Roact.createElement(
						"Frame",
						{
							Size = UDim2.new(1, 0, 1, 0),
							BackgroundTransparency = 1,
							AnchorPoint = Vector2.new(0.5, 0),
							Position = UDim2.new(0.5, 0, 0, 0)
						},
						children
					)
				}
			)
		}
	)
end

return KeyboardControls
