local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local RunService = game:GetService("RunService")
local Roact = require(CorePackages.Packages.Roact)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local t = require(CorePackages.Packages.t)
local Cryo = require(CorePackages.Packages.Cryo)
local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle
local SpringAnimatedItem = UIBlox.Utility.SpringAnimatedItem
local withSelectionCursorProvider = UIBlox.App.SelectionImage.withSelectionCursorProvider
local CursorKind = UIBlox.App.SelectionImage.CursorKind
local Modules = CoreGui.RobloxGui.Modules
local Constants = require(Modules.AvatarExperience.AvatarRefinement.Constants)
local DraggableTile = require(Modules.AvatarExperience.LayeredClothingSort.Components.DraggableTile)
local LCSortMoreButton = require(Modules.AvatarExperience.LayeredClothingSort.Components.LCSortMoreButton)
local LCSortArrowNav = require(Modules.AvatarExperience.LayeredClothingSort.Components.LCSortArrowNav)
local v18 = SpringAnimatedItem.wrap(RoactGamepad.Focusable.Frame)
local UserLib = require(CorePackages.Workspace.Packages.UserLib)
local Constants2 = UserLib.Utils.Constants
local getRbxthumbWithTypeSizeAndOptions = UserLib.Utils.getRbxthumbWithTypeSizeAndOptions
local IsVRAppBuild = require(CorePackages.Workspace.Packages.AppCommonLib).IsVRAppBuild
local FFlagAXMigrateAXToGlobalAutofocus = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateAXToGlobalAutofocus
local uDim = UDim.new(0, 10)
local t1 = {
	dampingRatio = 1,
	frequency = 10
}
local v26 = Roact.PureComponent:extend("VerticalClothingListTile")

v26.validateProps = t.strictInterface({
	asset = t.table,
	selectedAssetId = t.optional(t.string),
	positionYOffset = t.number,
	dragging = t.boolean,
	positionBinding = t.union(t.UDim2, t.table),
	isTileSelected = t.boolean,
	tileIndex = t.number,
	contextualOptionsVisible = t.union(t.boolean, t.table),
	updateContextualOptionsVisible = t.callback,
	resetSelectedTile = t.callback,
	initializeDrag = t.callback,
	onEndClick = t.callback,
	tileRef = t.optional(t.table),
	lastInputIsGamepad = t.boolean,
	NextSelectionUp = t.optional(t.table),
	NextSelectionDown = t.optional(t.table),
	NextSelectionLeft = t.optional(t.table),
	NextSelectionRight = t.optional(t.table),
	wrapperRef = t.optional(t.table)
})
v26.defaultProps = {
	lastInputIsGamepad = false
}

function v26.init(p1) -- line: 77
	-- upvalues: Roact (copy)
	p1.tileRef = p1.props.tileRef or Roact.createRef()
	p1.timeOfInputBegan = 0
	p1.clickAndHoldConn = nil
	p1:setState({
		dragAfterShortPress = false
	})
end
function v26.disconnectConn(p2) -- line: 87
	if p2.clickAndHoldConn then
		p2.clickAndHoldConn:Disconnect()
		p2.clickAndHoldConn = nil
	end
end
function v26.renderSelectedTile(p3, _, p5) -- line: 94
	-- upvalues: Constants2 (copy), getRbxthumbWithTypeSizeAndOptions (copy), Constants (copy), Roact (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), RoactGamepad (copy), uDim (copy), DraggableTile (copy), IsVRAppBuild (copy), LCSortMoreButton (copy), LCSortArrowNav (copy)
	local Theme = p5.Theme
	local Asset = Constants2.RbxthumbTypes.Asset
	local v34 = getRbxthumbWithTypeSizeAndOptions(p3.props.asset.id, Asset, 150)
	local uDim2 = UDim2.fromOffset(Constants.Tile.Padding + Constants.Tile.Size / 2, p3.props.positionYOffset + Constants.Tile.Size / 2)
	local v36 = not (not p3.props.dragging and not p3.state.dragAfterShortPress) and p3.props.positionBinding or uDim2

	return Roact.createElement(if not FFlagAXMigrateAXToGlobalAutofocus then RoactGamepad.Focusable.Frame else "Frame", {
		Active = true,
		BackgroundTransparency = 1,
		Size = UDim2.fromOffset(Constants.Tile.SelectedSize, Constants.Tile.SelectedSize),
		Position = v36,
		AnchorPoint = Vector2.new(0.5, 0.5),
		[Roact.Event.InputBegan] = function(p6, p7) -- line: 114
			-- upvalues: p3 (copy), Constants (copy)
			local UserInputType = p7.UserInputType

			if p3.props.dragging or UserInputType ~= Enum.UserInputType.MouseButton1 and UserInputType ~= Enum.UserInputType.Touch then
				return
			end

			p3:setState({
				dragAfterShortPress = true
			})
			p3.props.updateContextualOptionsVisible(false)
			p3.props.initializeDrag(p6, p7, p3.props.asset, p3.props.tileIndex, Constants.Tile.Size / 2)
		end
	}, {
		SelectionBackground = not p3.props.lastInputIsGamepad and Roact.createElement("Frame", {
			BackgroundTransparency = 0,
			ZIndex = 3,
			BackgroundColor3 = Theme.IconEmphasis.Color,
			Size = UDim2.fromScale(1, 1)
		}, {
			UICorner = Roact.createElement("UICorner", {
				CornerRadius = uDim
			})
		}),
		ItemTile = Roact.createElement(DraggableTile, {
			isSelectedByTap = true,
			ZIndex = 4,
			thumbnail = v34,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.new(1, -4, 1, -4),
			assetTypeId = p3.props.asset.typeId
		}),
		LCSortMoreButton = if not IsVRAppBuild() then Roact.createElement(LCSortMoreButton, {
			ZIndex = 2,
			Visible = p3.props.contextualOptionsVisible,
			asset = p3.props.asset,
			onUnequip = p3.props.resetSelectedTile
		}) else nil,
		LCSortArrowNav = Roact.createElement(LCSortArrowNav, {
			Visible = p3.props.contextualOptionsVisible,
			index = p3.props.tileIndex,
			asset = p3.props.asset
		})
	})
end
function v26.renderUnselectedTile(p8, _) -- line: 168
	-- upvalues: Constants2 (copy), getRbxthumbWithTypeSizeAndOptions (copy), Roact (copy), v18 (copy), Constants (copy), RunService (copy), t1 (copy), DraggableTile (copy)
	local Asset = Constants2.RbxthumbTypes.Asset
	local v40 = getRbxthumbWithTypeSizeAndOptions(p8.props.asset.id, Asset, 150)
	local positionYOffset = p8.props.positionYOffset

	return Roact.createElement(v18, {
		animatedValues = {
			positionY = positionYOffset
		},
		mapValuesToProps = function(p10) -- line: 178
			-- upvalues: Constants (copy)
			return {
				Position = UDim2.fromOffset(Constants.Tile.Padding, p10.positionY)
			}
		end,
		regularProps = {
			Active = true,
			BackgroundTransparency = 1,
			Size = UDim2.fromOffset(Constants.Tile.Size, Constants.Tile.Size),
			AnchorPoint = Vector2.new(0, 0),
			[Roact.Event.InputBegan] = function(p11, p12) -- line: 188
				-- upvalues: p8 (copy), RunService (copy), Constants (copy)
				if p8.props.dragging then
					return
				end

				local UserInputType = p12.UserInputType

				if UserInputType ~= Enum.UserInputType.MouseButton1 and UserInputType ~= Enum.UserInputType.Touch then
					return
				end

				if p12.UserInputState ~= Enum.UserInputState.Begin then
					return
				end

				p8:disconnectConn()
				p8.timeOfInputBegan = tick()
				p8.clickAndHoldConn = RunService.RenderStepped:connect(function(_) -- line: 208
					-- upvalues: p8 (copy), Constants (copy), p11 (copy), p12 (copy)
					if tick() - p8.timeOfInputBegan >= Constants.LongPressSeconds then
						if not p8.props.dragging then
							p8.props.initializeDrag(p11, p12, p8.props.asset, p8.props.tileIndex)
						end

						p8:disconnectConn()
					end
				end)
			end,
			[Roact.Event.InputEnded] = function(p14, p15) -- line: 221
				-- upvalues: p8 (copy)
				if p8.props.dragging or not p8.clickAndHoldConn then
					return
				end

				local UserInputType = p15.UserInputType

				if UserInputType ~= Enum.UserInputType.MouseButton1 and UserInputType ~= Enum.UserInputType.Touch then
					return
				end

				if p15.UserInputState == Enum.UserInputState.Change then
					p8.props.initializeDrag(p14, p15, p8.props.asset, p8.props.tileIndex)
					p8:disconnectConn()

					return
				end

				p8:disconnectConn()
				p8.props.updateContextualOptionsVisible(true)
				p8.props.onEndClick(p8.props.asset)
			end
		},
		springOptions = t1
	}, {
		ItemTile = Roact.createElement(DraggableTile, {
			thumbnail = v40,
			imageTransparency = p8.props.selectedAssetId ~= nil and 0.5 or 0,
			assetTypeId = p8.props.asset.typeId
		})
	})
end
function v26.renderWithProviders(p16, p17, p18) -- line: 256
	-- upvalues: Roact (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), RoactGamepad (copy), CursorKind (copy)
	local v45 = p16.props.isTileSelected and p16:renderSelectedTile(p17, p18) or p16:renderUnselectedTile(p17)
	local v46 = Roact.createElement(if not FFlagAXMigrateAXToGlobalAutofocus then RoactGamepad.Focusable.Frame else "Frame", {
		[Roact.Ref] = p16.tileRef,
		SelectionImageObject = p17(CursorKind.RoundedRectNoInset)
	}, v45)

	return Roact.createElement("Frame", {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		ZIndex = not p16.props.isTileSelected and 4 or 6,
		SelectionGroup = not not FFlagAXMigrateAXToGlobalAutofocus or nil,
		SelectionBehaviorUp = if not FFlagAXMigrateAXToGlobalAutofocus or not p16.props.isTileSelected then nil else Enum.SelectionBehavior.Stop,
		SelectionBehaviorDown = if not FFlagAXMigrateAXToGlobalAutofocus or not p16.props.isTileSelected then nil else Enum.SelectionBehavior.Stop,
		[Roact.Ref] = p16.props.wrapperRef,
		NextSelectionUp = if not FFlagAXMigrateAXToGlobalAutofocus then p16.props.NextSelectionUp else nil,
		NextSelectionDown = if not FFlagAXMigrateAXToGlobalAutofocus then p16.props.NextSelectionDown else nil,
		NextSelectionRight = if not FFlagAXMigrateAXToGlobalAutofocus then p16.props.NextSelectionRight else nil,
		NextSelectionLeft = if not FFlagAXMigrateAXToGlobalAutofocus then p16.props.NextSelectionLeft else nil
	}, v46)
end
function v26.render(p19) -- line: 291
	-- upvalues: withSelectionCursorProvider (copy), withStyle (copy)
	return withSelectionCursorProvider(function(p20) -- line: 292
		-- upvalues: withStyle (copy), p19 (copy)
		return withStyle(function(p21) -- line: 293
			-- upvalues: p19 (copy), p20 (copy)
			return p19:renderWithProviders(p20, p21)
		end)
	end)
end
function v26.didUpdate(p22, p23) -- line: 299
	if p22.state.dragAfterShortPress and (not p22.props.isTileSelected and p23.isTileSelected) then
		p22:setState({
			dragAfterShortPress = false
		})
	end
end
function v26.willUnmount(p24) -- line: 307
	p24:disconnectConn()
end

return Roact.forwardRef(function(p25, p26) -- line: 311
	-- upvalues: Roact (copy), v26 (copy), Cryo (copy)
	return Roact.createElement(v26, Cryo.Dictionary.join(p25, {
		wrapperRef = p26
	}))
end)
