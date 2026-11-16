local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")

local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local t = InGameMenuDependencies.t

local parent = script.Parent.Parent.Parent

local ToggleSwitch = require(parent.Components.ToggleSwitch)

local InputLabel = require(script.Parent.InputLabel)
local DeveloperLockLabel = require(script.Parent.DeveloperLockLabel)
local ThemedTextLabel = require(parent.Components.ThemedTextLabel)
local withLocalization = require(parent.Localization.withLocalization)

local extended = Roact.PureComponent:extend("ToggleEntry")
extended.validateProps = t.strictInterface({
	LayoutOrder = t.integer,
	labelKey = t.string,
	lockedToOff = t.optional(t.boolean),
	isDisabled = t.optional(t.boolean),
	subtextEnabled = t.optional(t.boolean),
	subtextKey = t.optional(t.string),
	checked = t.boolean,
	onToggled = t.callback,
	buttonRef = t.optional(t.table),
	NextSelectionUp = t.optional(t.union(t.Instance, t.table))
})

function extended:init()
	self.state = { isSelectable = true }
end

function extended.render(object)
	local buttonRef = object.props.buttonRef or Roact.createRef()

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		LayoutOrder = object.props.LayoutOrder,
		Size = UDim2.new(1, 0, 0, 56),
		Selectable = object.state.isSelectable,
		[Roact.Event.SelectionGained] = function()
			GuiService.SelectedCoreObject = buttonRef:getValue()
			object:setState({ isSelectable = false })
		end
	}, {
		Padding = Roact.createElement("UIPadding", {
			PaddingRight = UDim.new(0, 30),
			PaddingLeft = UDim.new(0, 24)
		}),
		ControlLabel = Roact.createElement(InputLabel, { localizationKey = object.props.labelKey }),
		LockedLabel = object.props.lockedToOff and Roact.createElement(DeveloperLockLabel, {
			Size = UDim2.new(1, -72, 0.25, 0),
			Position = UDim2.new(0, 0, 1, 0),
			AnchorPoint = Vector2.new(0, 1)
		}),
		SubtextLabel = object.props.subtextEnabled and withLocalization({
			text = object.props.subtextKey
		})(function(p)
			return Roact.createElement(ThemedTextLabel, {
				Text = p.text,
				themeKey = "TextDefault",
				fontKey = "CaptionBody",
				TextTransparency = 0.5,
				Size = UDim2.new(1, -72, 0.25, 0),
				Position = UDim2.new(0, 0, 1, 0),
				AnchorPoint = Vector2.new(0, 1),
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Bottom
			})
		end),
		Toggle = Roact.createElement(ToggleSwitch, {
			Position = UDim2.new(1, 0, 0.5, 0),
			AnchorPoint = Vector2.new(1, 0.5),
			checked = object.props.checked and not object.props.lockedToOff,
			onToggled = object.props.onToggled,
			disabled = object.props.lockedToOff or object.props.isDisabled,
			buttonRef = buttonRef,
			onSelectionLost = function()
				object:setState({ isSelectable = true })
			end,
			onSelectionGained = function()
				object:setState({ isSelectable = false })
			end,
			NextSelectionUp = object.props.NextSelectionUp
		})
	})
end

return extended
