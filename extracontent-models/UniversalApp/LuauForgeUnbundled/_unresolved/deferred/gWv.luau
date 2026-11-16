local CorePackages = game:GetService("CorePackages")
local RunService = game:GetService("RunService")

local Roact = require(CorePackages.Packages.Roact)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local t = require(CorePackages.Packages.t)
local Cryo = require(CorePackages.Packages.Cryo)

local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle
local springAnimatedItem = UIBlox.Utility.SpringAnimatedItem
local withSelectionCursorProvider = UIBlox.App.SelectionImage.withSelectionCursorProvider
local cursorKind = UIBlox.App.SelectionImage.CursorKind

local module = require("@luauforge/deferred/ggP")
local module2 = require("@luauforge/deferred/gWw")
local module3 = require("@luauforge/deferred/gWx")
local module4 = require("@luauforge/deferred/gWy")
local wrapped = springAnimatedItem.wrap(RoactGamepad.Focusable.Frame)
local module5 = require("@luauforge/bundled/cgr")
local constants = module5.Utils.Constants
local getRbxthumbWithTypeSizeAndOptions = module5.Utils.getRbxthumbWithTypeSizeAndOptions
local isVRAppBuild = require("@game/CorePackages/Workspace/Packages/AppCommonLib").IsVRAppBuild

local udim = UDim.new(0, 10)

local v5 = { dampingRatio = 1, frequency = 10 }

local extended = Roact.PureComponent:extend("VerticalClothingListTile")

extended.validateProps = t.strictInterface({
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

extended.defaultProps = { lastInputIsGamepad = false }

function extended:init()
	self.tileRef = self.props.tileRef or Roact.createRef()
	self.timeOfInputBegan = 0
	self.clickAndHoldConn = nil

	self:setState({ dragAfterShortPress = false })
end

function extended:disconnectConn()
	if self.clickAndHoldConn then
		self.clickAndHoldConn:Disconnect()
		self.clickAndHoldConn = nil
	end
end

function extended:renderSelectedTile(p2, p3)
	local theme = p3.Theme
	local asset = constants.RbxthumbTypes.Asset
	local rbxthumbWithTypeSizeAndOptions = getRbxthumbWithTypeSizeAndOptions(
		self.props.asset.id,
		asset,
		150
	)

	local v6 = UDim2.fromOffset(
		module.Tile.Padding + module.Tile.Size / 2,
		self.props.positionYOffset + module.Tile.Size / 2
	)

	v6 = (self.props.dragging or self.state.dragAfterShortPress) and self.props.positionBinding or v6

	local createElement = Roact.createElement
	local v8 = {
		Active = true,
		BackgroundTransparency = 1,
		Size = UDim2.fromOffset(module.Tile.SelectedSize, module.Tile.SelectedSize),
		Position = v6,
		AnchorPoint = Vector2.new(0.5, 0.5),
		[Roact.Event.InputBegan] = function(p4, p5)
			local userInputType = p5.UserInputType

			if
				self.props.dragging
				or userInputType ~= Enum.UserInputType.MouseButton1
				and userInputType ~= Enum.UserInputType.Touch
			then
				return
			end

			self:setState({ dragAfterShortPress = true })

			self.props.updateContextualOptionsVisible(false)
			self.props.initializeDrag(p4, p5, self.props.asset, self.props.tileIndex, module.Tile.Size / 2)
		end
	}
	local v9 = {
		SelectionBackground = not self.props.lastInputIsGamepad and Roact.createElement(
			"Frame",
			{
				BackgroundTransparency = 0,
				BackgroundColor3 = theme.IconEmphasis.Color,
				ZIndex = 3,
				Size = UDim2.fromScale(1, 1)
			},
			{
				UICorner = Roact.createElement("UICorner", { CornerRadius = udim })
			}
		),
		ItemTile = Roact.createElement(module2, {
			thumbnail = rbxthumbWithTypeSizeAndOptions,
			isSelectedByTap = true,
			ZIndex = 4,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.new(1, -4, 1, -4),
			assetTypeId = self.props.asset.typeId
		}),
		LCSortMoreButton = 0,
		LCSortArrowNav = 0
	}

	local v10 = if not isVRAppBuild() then Roact.createElement(module3, {
		ZIndex = 2,
		Visible = self.props.contextualOptionsVisible,
		asset = self.props.asset,
		onUnequip = self.props.resetSelectedTile
	}) else nil
	v9.LCSortMoreButton = v10

	v9.LCSortArrowNav = Roact.createElement(module4, {
		Visible = self.props.contextualOptionsVisible,
		index = self.props.tileIndex,
		asset = self.props.asset
	})
	return createElement("Frame", v8, v9)
end

function extended:renderUnselectedTile(p2)
	local asset = constants.RbxthumbTypes.Asset
	local rbxthumbWithTypeSizeAndOptions = getRbxthumbWithTypeSizeAndOptions(
		self.props.asset.id,
		asset,
		150
	)

	local positionYOffset = self.props.positionYOffset

	return Roact.createElement(wrapped, {
		animatedValues = { positionY = positionYOffset },
		mapValuesToProps = function(p3)
			return {
				Position = UDim2.fromOffset(module.Tile.Padding, p3.positionY)
			}
		end,
		regularProps = {
			Active = true,
			BackgroundTransparency = 1,
			Size = UDim2.fromOffset(module.Tile.Size, module.Tile.Size),
			AnchorPoint = Vector2.new(0, 0),
			[Roact.Event.InputBegan] = function(p3, p4)
				if self.props.dragging then
					return
				end

				local userInputType = p4.UserInputType

				if
					userInputType ~= Enum.UserInputType.MouseButton1
					and userInputType ~= Enum.UserInputType.Touch
					or p4.UserInputState ~= Enum.UserInputState.Begin
				then
					return
				end

				self:disconnectConn()

				self.timeOfInputBegan = tick()
				self.clickAndHoldConn = RunService.RenderStepped:connect(function(p5)
					if tick() - self.timeOfInputBegan >= module.LongPressSeconds then
						if not self.props.dragging then
							self.props.initializeDrag(p3, p4, self.props.asset, self.props.tileIndex)
						end

						self:disconnectConn()
					end
				end)
			end,
			[Roact.Event.InputEnded] = function(p3, p4)
				if self.props.dragging or not self.clickAndHoldConn then
					return
				end

				local userInputType = p4.UserInputType

				if
					userInputType ~= Enum.UserInputType.MouseButton1
					and userInputType ~= Enum.UserInputType.Touch
				then
					return
				end

				if p4.UserInputState == Enum.UserInputState.Change then
					self.props.initializeDrag(p3, p4, self.props.asset, self.props.tileIndex)
					self:disconnectConn()
				else
					self:disconnectConn()
					self.props.updateContextualOptionsVisible(true)
					self.props.onEndClick(self.props.asset)
				end
			end
		},
		springOptions = v5
	}, {
		ItemTile = Roact.createElement(module2, {
			thumbnail = rbxthumbWithTypeSizeAndOptions,
			imageTransparency = self.props.selectedAssetId == nil and 0 or 0.5,
			assetTypeId = self.props.asset.typeId
		})
	})
end

function extended:renderWithProviders(callback, p2)
	local v6 = self.props.isTileSelected and self:renderSelectedTile(callback, p2)
		or self:renderUnselectedTile(callback)

	local element = Roact.createElement(
		"Frame",
		{
			[Roact.Ref] = self.tileRef,
			SelectionImageObject = callback(cursorKind.RoundedRectNoInset)
		},
		v6
	)

	local createElement2 = Roact.createElement
	local wrapperRefsByRef = {}
	wrapperRefsByRef.Size = UDim2.fromScale(1, 1)
	wrapperRefsByRef.BackgroundTransparency = 1
	wrapperRefsByRef.ZIndex = self.props.isTileSelected and 6 or 4
	wrapperRefsByRef.SelectionGroup = true
	local v8 = if self.props.isTileSelected then Enum.SelectionBehavior.Stop else nil
	wrapperRefsByRef.SelectionBehaviorUp = v8
	local v9 = if self.props.isTileSelected then Enum.SelectionBehavior.Stop else nil
	wrapperRefsByRef.SelectionBehaviorDown = v9
	wrapperRefsByRef[Roact.Ref] = self.props.wrapperRef
	return createElement2("Frame", wrapperRefsByRef, element)
end

function extended:render()
	return withSelectionCursorProvider(function(p2)
		return withStyle(function(p3)
			return self:renderWithProviders(p2, p3)
		end)
	end)
end

function extended.didUpdate(object, p2)
	if object.state.dragAfterShortPress and not object.props.isTileSelected and p2.isTileSelected then
		object:setState({ dragAfterShortPress = false })
	end
end

function extended:willUnmount()
	self:disconnectConn()
end

return Roact.forwardRef(function(p2, p3)
	return Roact.createElement(extended, Cryo.Dictionary.join(p2, { wrapperRef = p3 }))
end)
