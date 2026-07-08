local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.InGameMenuDependencies).Roact
local ParentParent = script.Parent.Parent.Parent.Parent
local Controls = require(ParentParent.Resources.Controls)
local ControlLayoutContainer = require(script.Parent.Parent.ControlLayoutContainer)
local PaddedScrollFrame = require(ParentParent.Components.PaddedScrollFrame)
local ControlEntry = require(script.Parent.Parent.ControlEntry)
local ControlEntryHeader = require(script.Parent.Parent.ControlEntryHeader)

local function KeyboardControls(_) -- line: 26
	-- upvalues: Roact (copy), Controls (copy), ControlEntryHeader (copy), ControlEntry (copy), ControlLayoutContainer (copy), PaddedScrollFrame (copy)
	local t1 = {
		ListLayout = Roact.createElement("UIListLayout", {
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
	local n1 = 0
	local n2 = 0
	local n3 = 1

	for _, v in ipairs(Controls.keybinds) do
		local title = v.title

		n1 += 1
		t1[title .. "_header"] = Roact.createElement(ControlEntryHeader, {
			title = title,
			LayoutOrder = n3
		})
		n3 += 1

		for i, v2 in ipairs(v.controls) do
			n2 += 1
			t1[title .. "_" .. i] = Roact.createElement(ControlEntry, {
				LayoutOrder = n3,
				actionDescription = v2.desc,
				inputs = v2.inputs,
				isList = v2.list,
				hasDivider = i ~= #v.controls
			})
			n3 += 1
		end
	end

	local v20 = n1 * 45 + n2 * 50

	return Roact.createElement(ControlLayoutContainer, {
		titleText = "CoreScripts.InGameMenu.Controls.KeyboardAndMouseTitle"
	}, {
		ScrollContent = Roact.createElement(PaddedScrollFrame, {
			CanvasSize = UDim2.new(0, 0, 0, v20),
			ScrollingDirection = Enum.ScrollingDirection.Y,
			Size = UDim2.new(1, 0, 1, -130)
		}, {
			ListContainer = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, 0),
				AnchorPoint = Vector2.new(0.5, 0),
				Position = UDim2.new(0.5, 0, 0, 0)
			}, t1)
		})
	})
end

return KeyboardControls
