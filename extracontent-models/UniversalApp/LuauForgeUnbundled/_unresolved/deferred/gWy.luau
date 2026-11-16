local RunService = game:GetService("RunService")

local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local Cryo = require(CorePackages.Packages.Cryo)
local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState

local withStyle = UIBlox.Style.withStyle
local images = UIBlox.App.ImageSet.Images
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local module = require("@luauforge/deferred/ggP")
local module2 = require("@luauforge/bundled/dOJ")
local setOrderForTryOns = require("@luauforge/bundled/dHL").Actions.SetOrderForTryOns
local module3 = require("@luauforge/bundled/dTB")
local module4 = require("@luauforge/bundled/dOD")
local fFlagAXUseSignalsForLayeredClothingCurrentSort = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXUseSignalsForLayeredClothingCurrentSort
local getLayeredClothingCurrentSortStore

if fFlagAXUseSignalsForLayeredClothingCurrentSort then
	getLayeredClothingCurrentSortStore = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").Stores.getLayeredClothingCurrentSortStore
else
	getLayeredClothingCurrentSortStore = nil
end

local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local module5 = require("@luauforge/deferred/gge")
local module6 = require("@luauforge/deferred/ggf")

local iconsnavigationcycleUp = images["icons/navigation/cycleUp"]
local iconsnavigationcycleDown = images["icons/navigation/cycleDown"]

local extended = Roact.PureComponent:extend("LCSortArrowNav")

extended.validateProps = t.strictInterface({
	Visible = t.union(t.boolean, t.table),
	index = t.number,
	asset = t.table,
	currentSort = t.table,
	equippedAssets = t.table,
	tryOnItems = t.table,
	lookType = t.optional(t.string),
	setOrder = t.callback,
	setOrderForTryOns = t.callback,
	setCurrentSort = t.callback,
	sendAnalytics = t.callback,
	analytics = t.table
})

function extended:moveTile(p3)
	local v5 = {}

	for k, v6 in self.props.currentSort do
		if k ~= self.props.index then
			table.insert(v5, v6)
		end
	end

	local v6 = { id = self.props.asset.id, typeId = self.props.asset.typeId }

	table.insert(v5, self.props.index + p3, v6)
	local formatForSetOrderWithTryOns, v7 = module4.formatForSetOrderWithTryOns(
		v5,
		self.props.equippedAssets,
		self.props.tryOnItems,
		self.props.lookType
	)

	self.props.setOrder(formatForSetOrderWithTryOns)
	self.props.setOrderForTryOns(v7)
	self.props.setCurrentSort(v5)

	self.props.sendAnalytics(self.props.analytics.avatarRefineAutosaved)
end

function extended:init()
	self.animLoopConn = nil
	self.animOutConn = nil
	self.animInConn = nil
	self.animating = false
	local binding, v5 = Roact.createBinding(UDim2.fromOffset(0, 4))
	self.upArrowPos = binding
	self.updateUpArrowPos = v5
	local binding2, v6 = Roact.createBinding(UDim2.fromScale(0, 0))
	self.downArrowPos = binding2
	self.updateDownArrowPos = v6

	function self.onUpActivated()
		self:moveTile(-1)
	end

	function self.onDownActivated()
		self:moveTile(1)
	end
end

function extended:animateOut()
	local v5 = 4
	local total = 0
	self.animOutConn = RunService.RenderStepped:connect(function(p2)
		v5 -= p2 * 14
		total += p2 * 14
		local v6 = (math.max)(v5, 0)
		local v7 = (math.min)(total, 4)
		self.updateUpArrowPos(UDim2.new(0, 0, 0, v6))
		self.updateDownArrowPos(UDim2.new(0, 0, 0, v7))

		if v6 == 0 then
			self.animOutConn:Disconnect()
			self.animOutConn = nil
			self:animateIn()
		end
	end)
end

function extended:animateIn()
	local total = 0
	local v5 = 4
	self.animInConn = RunService.RenderStepped:connect(function(p2)
		total += p2 * 14
		v5 -= p2 * 14
		local v6 = (math.min)(total, 4)
		local v7 = (math.max)(v5, 0)
		self.updateUpArrowPos(UDim2.new(0, 0, 0, v6))
		self.updateDownArrowPos(UDim2.new(0, 0, 0, v7))

		if v6 == 4 then
			self.animInConn:Disconnect()
			self.animInConn = nil
			self.timeOfLastAnimation = tick()
			self.animating = false
		end
	end)
end

function extended.render(data)
	return withStyle(function(p2)
		local theme = p2.Theme
		local v5 = data.props.Visible and data.props.index ~= 1
		local v6 = data.props.Visible and data.props.index ~= #data.props.currentSort

		return Roact.createFragment({
			UpArrowButton = Roact.createElement("TextButton", {
				Text = "",
				BackgroundTransparency = 1,
				Visible = v5,
				Selectable = false,
				Size = UDim2.fromOffset(module.Tile.ArrowSize.X.Offset, module.Tile.ArrowSize.Y.Offset + 4),
				AnchorPoint = Vector2.new(0.5, 1),
				Position = UDim2.fromScale(0.5, 0),
				[Roact.Event.Activated] = data.onUpActivated
			}, {
				UpArrowIcon = Roact.createElement(imageSetLabel, {
					BackgroundTransparency = 1,
					Size = module.Tile.ArrowSize,
					Position = data.upArrowPos,
					Image = iconsnavigationcycleUp,
					ImageColor3 = theme.IconEmphasis.Color
				})
			}),
			DownArrowButton = Roact.createElement("TextButton", {
				Text = "",
				BackgroundTransparency = 1,
				Visible = v6,
				Selectable = false,
				Size = UDim2.fromOffset(module.Tile.ArrowSize.X.Offset, module.Tile.ArrowSize.Y.Offset + 4),
				AnchorPoint = Vector2.new(0.5, 0),
				Position = UDim2.new(0.5, 0, 0, module.Tile.SelectedSize),
				[Roact.Event.Activated] = data.onDownActivated
			}, {
				DownArrowIcon = Roact.createElement(imageSetLabel, {
					BackgroundTransparency = 1,
					Size = module.Tile.ArrowSize,
					Position = data.downArrowPos,
					Image = iconsnavigationcycleDown,
					ImageColor3 = theme.IconEmphasis.Color
				})
			})
		})
	end)
end

function extended:didMount()
	self.timeOfLastAnimation = tick()
	self.animLoopConn = RunService.RenderStepped:connect(function(p2)
		if tick() - self.timeOfLastAnimation >= 1 and not self.animating then
			self.animating = true
			self:animateOut()
		end
	end)
end

function extended:willUnmount()
	if self.animLoopConn then
		self.animLoopConn:Disconnect()
		self.animLoopConn = nil
	end

	if self.animOutConn then
		self.animOutConn:Disconnect()
		self.animOutConn = nil
	end

	if self.animInConn then
		self.animInConn:Disconnect()
		self.animInConn = nil
	end
end

local function mapStateToProps(p2, p3)
	local v6 = if not fFlagAXUseSignalsForLayeredClothingCurrentSort then p2.AvatarExperience.LayeredClothingSort.CurrentSort.OrderedList else nil
	local v5 = {
		currentSort = v6,
		equippedAssets = p2.AvatarExperience.AvatarEditor.Character.EquippedAssets,
		tryOnItems = p2.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems,
		lookType = 0
	}
	local lookType = nil
	local looks = p2.AvatarExperience.AvatarScene.Looks
	local lookId = p2.AvatarExperience.AvatarScene.OutfitTryOn.LookId

	if lookId ~= nil and looks ~= nil then
		local look = looks[lookId]

		if look then
			lookType = look.lookType
		end
	end

	v5.lookType = lookType
	return v5
end

local function mapDispatchToProps(callback)
	return {
		setOrder = function(p2)
			callback(module2(p2))
		end,
		setOrderForTryOns = function(p2)
			callback(setOrderForTryOns(p2))
		end,
		setCurrentSort = function(p2)
			if fFlagAXUseSignalsForLayeredClothingCurrentSort then
				getLayeredClothingCurrentSortStore(false).setCurrentSort(p2)
			else
				callback(module3(p2))
			end
		end,
		sendAnalytics = function(p2)
			callback(module6(p2))
		end
	}
end

local v5 = roactServices.connect({ analytics = module5 })(extended)

local v6 = RoactRodux.connect(mapStateToProps, mapDispatchToProps)(v5)

local function LCSortArrowNavWithSignals(p2)
	local v7 = useSignalState(getLayeredClothingCurrentSortStore(false).getOrderedList)
	return React.createElement(v6, Cryo.Dictionary.union(p2, { currentSort = v7 }))
end

if fFlagAXUseSignalsForLayeredClothingCurrentSort then
	return React.memo(LCSortArrowNavWithSignals)
end

return v6
