local CorePackages = game:GetService("CorePackages")

local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local UIBlox = InGameMenuDependencies.UIBlox
local Otter = InGameMenuDependencies.Otter
local t = InGameMenuDependencies.t

local CoreGuiCommon = require(CorePackages.Workspace.Packages.CoreGuiCommon)
local withFoundationOrUIBloxStyle = CoreGuiCommon.withFoundationOrUIBloxStyle
local Foundation = require(CorePackages.Packages.Foundation)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagCoreUiMigrateUIBloxToFoundation = SharedFlags.FFlagCoreUiMigrateUIBloxToFoundation
local v

if FFlagCoreUiMigrateUIBloxToFoundation then
	v = Foundation.UNSTABLE.withCursorMigration
else
	v = UIBlox.App.SelectionImage.withSelectionCursorProvider
end

local v2

if FFlagCoreUiMigrateUIBloxToFoundation then
	v2 = Foundation.Enums.CursorType
else
	v2 = UIBlox.App.SelectionImage.CursorKind
end

local parent = script.Parent.Parent

local divideTransparency = require(parent.Utility.divideTransparency)

local AssetImage = require(script.Parent.AssetImage)

local udim = UDim2.new(0, -3, 0.5, 0)
local udim2 = UDim2.new(1, -39, 0.5, 0)
local v3 = { frequency = 4 }

local extended = Roact.PureComponent:extend("ToggleSwitch")
extended.validateProps = t.strictInterface({
	checked = t.boolean,
	onToggled = t.callback,
	disabled = t.optional(t.boolean),
	buttonRef = t.optional(t.union(t.callback, t.table)),
	AnchorPoint = t.optional(t.Vector2),
	LayoutOrder = t.optional(t.integer),
	Position = t.optional(t.UDim2),
	NextSelectionUp = t.optional(t.union(t.Instance, t.table)),
	onSelectionLost = t.optional(t.callback),
	onSelectionGained = t.optional(t.callback)
})

function extended:init()
	local v4 = self.props.checked and 1 or 0
	local binding, setProgress = Roact.createBinding(v4)
	self.progress = binding
	self.setProgress = setProgress

	self.fillTransparency = self.progress:map(function(p)
		return divideTransparency(1 - p, self.props.disabled and 4 or 1)
	end)

	self.knobPosition = self.progress:map(function(p)
		return udim:lerp(udim2, p)
	end)

	self.motor = Otter.createSingleMotor(v4)
	self.motor:onStep(self.setProgress)
end

function extended:renderWithSelectionCursor(callback)
	return withFoundationOrUIBloxStyle(function(p)
		return {
			Theme = {
				SecondaryDefault = {
					Color = p.Color.Extended.White.White_70.Color3,
					Transparency = p.Color.Extended.White.White_70.Transparency
				},
				Success = {
					Color = p.Color.System.Success.Color3,
					Transparency = p.Color.System.Success.Transparency
				}
			}
		}
	end, function(p)
		return Roact.createElement(AssetImage.Button, {
			Size = UDim2.new(0, 60, 0, 36),
			BackgroundTransparency = 1,
			Position = self.props.Position,
			LayoutOrder = self.props.LayoutOrder,
			imageKey = "ToggleOutline",
			AnchorPoint = self.props.AnchorPoint,
			ImageColor3 = p.Theme.SecondaryDefault.Color,
			ImageTransparency = divideTransparency(
				p.Theme.SecondaryDefault.Transparency,
				self.props.disabled and 4 or 1
			),
			NextSelectionUp = self.props.NextSelectionUp,
			[Roact.Event.Activated] = self.props.onToggled,
			[Roact.Ref] = self.props.buttonRef,
			[Roact.Event.SelectionLost] = self.props.onSelectionLost,
			[Roact.Event.SelectionGained] = self.props.onSelectionGained,
			SelectionImageObject = callback(v2.Toggle)
		}, {
			Fill = Roact.createElement(AssetImage.Label, {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, 0),
				imageKey = "ToggleFill",
				ImageColor3 = p.Theme.Success.Color,
				ImageTransparency = self.fillTransparency
			}),
			Knob = Roact.createElement(AssetImage.Label, {
				BackgroundTransparency = 1,
				Size = UDim2.new(0, 42, 0, 42),
				AnchorPoint = Vector2.new(0, 0.5),
				Position = self.knobPosition,
				imageKey = "ToggleKnob",
				ImageTransparency = divideTransparency(0, self.props.disabled and 4 or 1),
				ZIndex = 2
			})
		})
	end)
end

function extended:render()
	return v(function(p)
		return self:renderWithSelectionCursor(p)
	end)
end

function extended.didUpdate(p)
	local v4 = p.props.checked and 1 or 0
	p.motor:setGoal(Otter.spring(v4, v3))
end

function extended.willUnmount(p)
	p.motor:destroy()
end

return extended
