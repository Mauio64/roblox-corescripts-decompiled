local CorePackages = game:GetService("CorePackages")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local t = InGameMenuDependencies.t
local Roact = InGameMenuDependencies.Roact
local UIBlox = InGameMenuDependencies.UIBlox
local Cryo = InGameMenuDependencies.Cryo
local withSelectionCursorProvider = UIBlox.App.SelectionImage.withSelectionCursorProvider
local CursorKind = UIBlox.App.SelectionImage.CursorKind
local ParentParent = script.Parent.Parent.Parent
local Assets = require(ParentParent.Resources.Assets)
local GlobalConfig = require(ParentParent.GlobalConfig)
local ImageSetButton = UIBlox.Core.ImageSet.ImageSetButton
local Foundation = require(CorePackages.Packages.Foundation)
local FoundationImage = Foundation.Image
local FFlagCoreUiMigrateUIBloxToFoundation = require(CorePackages.Workspace.Packages.SharedFlags).FFlagCoreUiMigrateUIBloxToFoundation
local ControlState = Foundation.Enums.ControlState
local v17 = t.strictInterface({
	AnchorPoint = t.optional(t.Vector2),
	Position = t.optional(t.UDim2),
	layoutOrder = t.optional(t.integer),
	onActivated = t.callback,
	onSelectionGained = t.optional(t.callback),
	onSelectionLost = t.optional(t.callback),
	forwardRef = t.optional(t.table)
})

local function isSelectedState(p1) -- line: 35
	-- upvalues: ControlState (copy)
	return p1 == ControlState.Selected or p1 == ControlState.SelectedPressed
end

local u19

if FFlagCoreUiMigrateUIBloxToFoundation then
	u19 = Roact.Component:extend("CloseMenuButton")

	function u19.init(p2) -- line: 44
		p2.wasSelected = false
	end
	function u19.render(p3) -- line: 48
		-- upvalues: withSelectionCursorProvider (copy), GlobalConfig (copy), v17 (copy), Roact (copy), FoundationImage (copy), Assets (copy), CursorKind (copy), ControlState (copy)
		local props = p3.props

		return withSelectionCursorProvider(function(p4) -- line: 50
			-- upvalues: GlobalConfig (copy), v17 (copy), props (copy), Roact (copy), FoundationImage (copy), Assets (copy), CursorKind (copy), ControlState (copy), p3 (copy)
			if GlobalConfig.propValidation then
				assert(v17(props))
			end

			return Roact.createElement(FoundationImage, {
				AnchorPoint = props.AnchorPoint,
				Position = props.Position,
				Size = UDim2.new(0, 32, 0, 32),
				LayoutOrder = props.layoutOrder,
				Image = Assets.Images.CloseButton,
				selection = {
					SelectionImageObject = p4(CursorKind.RoundedRect)
				},
				onActivated = props.onActivated,
				onStateChanged = function(p5) -- line: 63
					-- upvalues: ControlState (copy), p3 (copy), props (copy)
					local v30 = p5 == ControlState.Selected or p5 == ControlState.SelectedPressed

					if v30 and not p3.wasSelected then
						if props.onSelectionGained then
							props.onSelectionGained()
						end
					elseif not v30 and p3.wasSelected and props.onSelectionLost then
						props.onSelectionLost()
					end

					p3.wasSelected = v30
				end,
				ref = props.forwardRef
			})
		end)
	end
else
	function u19(p6) -- line: 81
		-- upvalues: withSelectionCursorProvider (copy), GlobalConfig (copy), v17 (copy), Roact (copy), ImageSetButton (copy), Assets (copy), CursorKind (copy)
		return withSelectionCursorProvider(function(p7) -- line: 82
			-- upvalues: GlobalConfig (copy), v17 (copy), p6 (copy), Roact (copy), ImageSetButton (copy), Assets (copy), CursorKind (copy)
			if GlobalConfig.propValidation then
				assert(v17(p6))
			end

			return Roact.createElement(ImageSetButton, {
				AnchorPoint = p6.AnchorPoint,
				BackgroundTransparency = 1,
				Image = Assets.Images.CloseButton,
				Position = p6.Position,
				Size = UDim2.new(0, 32, 0, 32),
				LayoutOrder = p6.layoutOrder,
				SelectionImageObject = p7(CursorKind.RoundedRect),
				[Roact.Event.Activated] = p6.onActivated,
				[Roact.Event.SelectionGained] = p6.onSelectionGained,
				[Roact.Event.SelectionLost] = p6.onSelectionLost,
				[Roact.Ref] = p6.forwardRef
			})
		end)
	end
end

return Roact.forwardRef(function(p8, p9) -- line: 105
	-- upvalues: Roact (copy), u19 (ref), Cryo (copy)
	return Roact.createElement(u19, Cryo.Dictionary.join(p8, {
		forwardRef = p9
	}))
end)
