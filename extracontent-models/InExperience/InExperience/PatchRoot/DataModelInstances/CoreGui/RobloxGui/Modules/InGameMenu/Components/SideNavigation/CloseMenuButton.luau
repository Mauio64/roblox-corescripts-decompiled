local CorePackages = game:GetService("CorePackages")

local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local t = InGameMenuDependencies.t
local Roact = InGameMenuDependencies.Roact
local UIBlox = InGameMenuDependencies.UIBlox
local Cryo = InGameMenuDependencies.Cryo
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

local parent = script.Parent.Parent.Parent

local Assets = require(parent.Resources.Assets)
local GlobalConfig = require(parent.GlobalConfig)

local ImageSetButton = UIBlox.Core.ImageSet.ImageSetButton

local Image = Foundation.Image
local ControlState = Foundation.Enums.ControlState

local strictInterface = t.strictInterface({
	AnchorPoint = t.optional(t.Vector2),
	Position = t.optional(t.UDim2),
	layoutOrder = t.optional(t.integer),
	onActivated = t.callback,
	onSelectionGained = t.optional(t.callback),
	onSelectionLost = t.optional(t.callback),
	forwardRef = t.optional(t.table)
})

local function isSelectedState(p): boolean -- 1 equivalent call inferred from this helper
	return p == ControlState.Selected or p == ControlState.SelectedPressed
end

local v3

if FFlagCoreUiMigrateUIBloxToFoundation then
	v3 = Roact.Component:extend("CloseMenuButton")

	function v3:init()
		self.wasSelected = false
	end

	function v3:render()
		local props = self.props
		return v(function(callback)
			if GlobalConfig.propValidation then
				assert(strictInterface(props))
			end

			return Roact.createElement(Image, {
				AnchorPoint = props.AnchorPoint,
				Position = props.Position,
				Size = UDim2.new(0, 32, 0, 32),
				backgroundStyle = { Transparency = 1 },
				LayoutOrder = props.layoutOrder,
				Image = Assets.Images.CloseButton,
				selection = { SelectionImageObject = callback(v2.RoundedRect) },
				onActivated = props.onActivated,
				onStateChanged = function(p)
					local selectedState = isSelectedState(p) -- inferred equivalent call

					if selectedState and not self.wasSelected then
						if props.onSelectionGained then
							props.onSelectionGained()
						end
					elseif not selectedState and self.wasSelected and props.onSelectionLost then
						props.onSelectionLost()
					end

					self.wasSelected = selectedState
				end,
				ref = props.forwardRef
			})
		end)
	end
else
	v3 = function(data)
		return v(function(callback)
			if GlobalConfig.propValidation then
				assert(strictInterface(data))
			end

			return Roact.createElement(ImageSetButton, {
				AnchorPoint = data.AnchorPoint,
				BackgroundTransparency = 1,
				Image = Assets.Images.CloseButton,
				Position = data.Position,
				Size = UDim2.new(0, 32, 0, 32),
				LayoutOrder = data.layoutOrder,
				SelectionImageObject = callback(v2.RoundedRect),
				[Roact.Event.Activated] = data.onActivated,
				[Roact.Event.SelectionGained] = data.onSelectionGained,
				[Roact.Event.SelectionLost] = data.onSelectionLost,
				[Roact.Ref] = data.forwardRef
			})
		end)
	end
end

return Roact.forwardRef(function(p, forwardRef)
	return Roact.createElement(v3, Cryo.Dictionary.join(p, { forwardRef = forwardRef }))
end)
