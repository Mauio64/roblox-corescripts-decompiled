local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local t = InGameMenuDependencies.t
local ParentParent = script.Parent.Parent.Parent
local ToggleSwitch = require(ParentParent.Components.ToggleSwitch)
local InputLabel = require(script.Parent.InputLabel)
local DeveloperLockLabel = require(script.Parent.DeveloperLockLabel)
local ThemedTextLabel = require(ParentParent.Components.ThemedTextLabel)
local withLocalization = require(ParentParent.Localization.withLocalization)
local v12 = Roact.PureComponent:extend("ToggleEntry")

v12.validateProps = t.strictInterface({
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

function v12.init(p1) -- line: 31
	p1.state = {
		isSelectable = true
	}
end
function v12.render(p2) -- line: 37
	-- upvalues: Roact (copy), GuiService (copy), InputLabel (copy), DeveloperLockLabel (copy), withLocalization (copy), ThemedTextLabel (copy), ToggleSwitch (copy)
	local v15 = p2.props.buttonRef or Roact.createRef()

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		LayoutOrder = p2.props.LayoutOrder,
		Size = UDim2.new(1, 0, 0, 56),
		Selectable = p2.state.isSelectable,
		[Roact.Event.SelectionGained] = function() -- line: 45
			-- upvalues: GuiService (copy), v15 (copy), p2 (copy)
			GuiService.SelectedCoreObject = v15:getValue()
			p2:setState({
				isSelectable = false
			})
		end
	}, {
		Padding = Roact.createElement("UIPadding", {
			PaddingRight = UDim.new(0, 30),
			PaddingLeft = UDim.new(0, 24)
		}),
		ControlLabel = Roact.createElement(InputLabel, {
			localizationKey = p2.props.labelKey
		}),
		LockedLabel = p2.props.lockedToOff and Roact.createElement(DeveloperLockLabel, {
			Size = UDim2.new(1, -72, 0.25, 0),
			Position = UDim2.new(0, 0, 1, 0),
			AnchorPoint = Vector2.new(0, 1)
		}),
		SubtextLabel = p2.props.subtextEnabled and withLocalization({
			text = p2.props.subtextKey
		})(function(p3) -- line: 66
			-- upvalues: Roact (copy), ThemedTextLabel (copy)
			return Roact.createElement(ThemedTextLabel, {
				themeKey = "TextDefault",
				fontKey = "CaptionBody",
				TextTransparency = 0.5,
				Text = p3.text,
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
			checked = p2.props.checked and not p2.props.lockedToOff,
			onToggled = p2.props.onToggled,
			disabled = p2.props.lockedToOff or p2.props.isDisabled,
			buttonRef = v15,
			onSelectionLost = function() -- line: 86
				-- upvalues: p2 (copy)
				p2:setState({
					isSelectable = true
				})
			end,
			onSelectionGained = function() -- line: 91
				-- upvalues: p2 (copy)
				p2:setState({
					isSelectable = false
				})
			end,
			NextSelectionUp = p2.props.NextSelectionUp
		})
	})
end

return v12
